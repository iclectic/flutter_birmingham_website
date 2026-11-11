# Flutter Birmingham Website

The community website for **Flutter Birmingham**, the free, independent Flutter & Dart meetup for Birmingham and the West Midlands. Built with Flutter Web.

The site has three pages. Events are run on [Meetup](https://www.meetup.com/flutter-birmingham/); every events link points there.

| Route | Page |
|---|---|
| `/` | Home: hero, events (links to Meetup), what we do, get involved, Flutter resources |
| `/team` | Organiser and co-organisers |
| `/code-of-conduct` | Code of Conduct |

Old routes (`/about`, `/gallery`, `/contact`) redirect to `/`. `/events` redirects to the Meetup group (server-side, in `web/.htaccess`).

## Tech stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Web), built with `--wasm` |
| Routing | `go_router` with path URLs (`usePathUrlStrategy`) and per-route `<title>` |
| State | `flutter_riverpod` (content providers, easy to override in tests) |
| Fonts | Google Sans, bundled in `assets/fonts/` (no runtime font fetch) |
| Animations | `visibility_detector` for scroll fade-ins (respects reduced motion) |
| Links | `url_launcher` |
| Dates | `intl` |

Colours follow flutter.dev (`#027DFD`, `#0553B1`, light-blue tints, `#833EF2` accent); see `lib/core/constants/app_colors.dart`.

## Project structure

```
lib/
  app/            app widget, router, theme, providers
  core/           constants, responsive helpers, shared widgets (nav, footer, logo…)
  data/
    content/      team.dart: the site's editable content
    models/       TeamMember
  features/       home, team, code_of_conduct
  services/       url_service.dart
assets/
  fonts/          Google Sans
  logos/          Flutter Birmingham logo (WebP)
  images/team/    organiser photos
web/              index.html (meta, OG tags, loading screen), manifest, icons, og-image.png
```

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

## Checks

```bash
dart format lib test
flutter analyze
flutter test
flutter build web --release --wasm   # output in build/web/
```

GitHub Actions (`.github/workflows/ci.yml`) runs format, analyze, test and a wasm build on every PR and push to `main`.

## Updating content

### Events
Create and manage events on Meetup. The site links to `AppStrings.meetupUrl` and needs no change per event.

### Team
Edit `lib/data/content/team.dart`. Put photos in `assets/images/team/`. To fill a co-organiser slot, replace the placeholder entry with their name, bio and `photoAsset`, and remove `isPlaceholder: true`.

### Links and copy
URLs, emails and copy live in `lib/core/constants/app_strings.dart`.

## Deployment (Hostinger)

Production is https://www.flutterbirmingham.co.uk, hosted on Hostinger.

On every push to `main`, GitHub Actions (`.github/workflows/ci.yml`) runs format, analyze and tests. It then builds `build/web` and publishes only that output to the `hostinger-deploy` branch. Hostinger's Git integration deploys that branch to `public_html`. `web/.htaccess` ships with the build and handles path URLs, wasm MIME types, caching and the `www` redirect.

Never point Hostinger at `main`: it contains source code, not a website.

Setup, smoke tests, troubleshooting and rollback: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md).

## Trademark notice

Flutter Birmingham is an independent community group. Flutter and the related logo are trademarks of Google LLC. We are not endorsed by or affiliated with Google LLC.
