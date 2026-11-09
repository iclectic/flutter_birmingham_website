# Deploying Flutter Birmingham to Hostinger

Production: https://www.flutterbirmingham.co.uk (Hostinger shared hosting, LiteSpeed).

## Why the site returned 403

Hostinger's Git integration was deploying the source repository (`main`) into `public_html`. The server therefore held `README.md`, `pubspec.yaml`, `lib/`, `web/` and so on, but no `index.html` at the root. LiteSpeed does not list directories, so it answered `403 Forbidden` for `/`.

Evidence, collected with `curl -I`:

| URL | Status |
| --- | --- |
| `/` | 403 |
| `/index.html` | 404 |
| `/README.md`, `/pubspec.yaml`, `/web/index.html` | 200 (source files served publicly) |

Flutter Web has to be compiled (`flutter build web`). The deployable site is `build/web`, which is git-ignored and was never on the server. Hostinger does not run Flutter builds.

## Architecture

```
push to main
  -> GitHub Actions: format, analyze, test, flutter build web --release --wasm
  -> stamp <meta name="build-revision" content="<sha>"> into index.html
  -> commit build/web (only) to branch hostinger-deploy
  -> Hostinger Git auto-deploy webhook pulls hostinger-deploy into public_html
  -> smoke-test job waits until the live site serves <sha>, then checks routes
```

How each requirement is met:

- **Source and output kept apart.** Source lives on `main`. Compiled output lives only on `hostinger-deploy`, with `index.html` and `.htaccess` at its root.
- **No hosting credentials in GitHub.** The workflow only uses the built-in `GITHUB_TOKEN`, with `contents: write` granted to the deploy job alone. Hostinger SSH/FTP passwords never enter GitHub. SSH deploys would need extra secrets and plan-level SSH access, and the Git integration already exists in hPanel.
- **No deploy loops.** Pushes made with `GITHUB_TOKEN` do not trigger workflows, and the workflow only listens to `main`.
- **No overlapping deploys.** The deploy job uses `concurrency: deploy-hostinger` with `cancel-in-progress: false`, so deploys queue instead of overlapping.
- **One commit per release.** Each deploy is one commit on `hostinger-deploy` that links back to the source commit, which makes rollback a revert.
- **Untracked files survive.** Hostinger's pull only touches tracked files, so any untracked files you put in `public_html` are not deleted.

## One-time setup in hPanel

1. **Back up first.** In hPanel → Websites → flutterbirmingham.co.uk → File Manager, download anything in `public_html` you want to keep. It currently holds a copy of the repository source, which is safe to delete.
2. **Run the workflow once.** Merge the deployment PR or run *Actions → CI / Deploy → Run workflow* on `main`. Check that a `hostinger-deploy` branch now exists on GitHub with `index.html` at its root.
3. **Remove the old Git deployment.** In hPanel → Advanced → **GIT**, delete the existing repository entry that points at `main`.
4. **Empty `public_html`.** In File Manager, delete everything in `public_html`. Hostinger requires an empty install directory for a Git deployment.
5. **Create the new deployment.** Back in **GIT**, under *Create a New Repository*, enter:
   - Repository: `https://github.com/iclectic/flutter_birmingham_website.git` (public, so no deploy key is needed)
   - Branch: `hostinger-deploy`
   - Directory: leave empty, which means `public_html`

   Click **Create**, then **Deploy**.
6. **Turn on auto-deploy.** In the new entry, click **Auto Deployment** and copy the webhook URL. On GitHub, go to *Settings → Webhooks → Add webhook* and set:
   - Payload URL: the copied URL
   - Content type: `application/json`
   - Events: *Just the push event*

   Hostinger pulls the configured branch, so pushes to other branches are harmless.
7. **Verify.** Run `scripts/smoke_test.sh https://www.flutterbirmingham.co.uk`.

### Domain and DNS

The domain uses Namecheap DNS (`dns1/dns2.registrar-servers.com`). Both `flutterbirmingham.co.uk` and `www` resolve to Hostinger (`77.37.34.141`), and HTTP already redirects to HTTPS. No DNS change is needed.

Check it with `dig +short www.flutterbirmingham.co.uk` and `curl -I http://www.flutterbirmingham.co.uk/`. `.htaccess` sends the bare domain to `https://www.flutterbirmingham.co.uk`.

## GitHub settings

- **Secrets:** none required.
- **Actions permissions:** *Settings → Actions → General → Workflow permissions* may stay "Read repository contents". The deploy job asks for `contents: write` itself. If an org or repo policy blocks that, allow "Read and write permissions".
- **Branch protection on `hostinger-deploy`:** don't add any. If you protect it, allow GitHub Actions to push.

## Local commands

```bash
flutter pub get
flutter run -d chrome                     # develop
flutter analyze && flutter test           # checks
flutter build web --release --wasm        # production build -> build/web
scripts/smoke_test.sh http://localhost:8080   # against any server with .htaccess support
```

The `--wasm` build also emits `main.dart.js`. Browsers without WasmGC, such as older Safari, fall back to it automatically. If wasm causes problems on the host, drop `--wasm` in `ci.yml`. The site will still work, just with slower rendering on Chrome and Firefox.

## Server config (`web/.htaccess`)

`web/.htaccess` is copied into `build/web` by Flutter and ships with every deploy. It:

- Rewrites extensionless paths (`/events`, `/team`, `/code-of-conduct`, `/events/<id>`) to `index.html`. Real files and missing files with extensions are not rewritten, so a missing file gets a genuine 404.
- Sets `application/wasm` and `text/javascript` MIME types.
- Sets `no-cache` on html/js/mjs/wasm/json, because Flutter's file names are not content-hashed, and a 7-day cache on images and fonts.
- Sends COOP `same-origin` and COEP `credentialless` so the wasm renderer can run multi-threaded, plus `nosniff` and a referrer policy.
- Disables directory listings and redirects the bare domain to `www`.

## Troubleshooting

| Symptom | Likely cause |
| --- | --- |
| 403 on `/` | No `index.html` in `public_html`. The Git deployment points at the wrong branch or directory, or the first deploy never ran. |
| `/pubspec.yaml` or `/README.md` returns 200 | Hostinger is deploying `main`. Re-point it to `hostinger-deploy`. |
| `/events` returns 404 on refresh | `.htaccess` is missing from `public_html`. Check the `hostinger-deploy` branch contains it. |
| Smoke-test job times out | The webhook isn't configured or failed. Check hPanel → GIT → deployment log, and GitHub → Settings → Webhooks → Recent deliveries. Click **Deploy** in hPanel to pull manually. |
| Old version still showing | Browser or CDN cache. Check `curl -s https://www.flutterbirmingham.co.uk/ \| grep build-revision`. If Hostinger CDN is on, purge it in hPanel. |
| Deploy job fails on `git push` | Actions lacks write permission (see GitHub settings) or `hostinger-deploy` is protected. |

## Rollback

`hostinger-deploy` holds one commit per release. To roll back:

1. Revert the latest deploy commit and push:

   ```bash
   git fetch origin hostinger-deploy
   git switch hostinger-deploy
   git revert --no-edit HEAD
   git push origin hostinger-deploy
   ```

   The webhook redeploys the previous build. If it doesn't, click **Deploy** in hPanel.
2. Alternatively, revert the bad change on `main`. The pipeline then rebuilds and redeploys.

Either way, the next push to `main` deploys forward again.
