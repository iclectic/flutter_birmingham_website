#!/usr/bin/env bash
# Smoke-test a deployed (or locally served) Flutter Birmingham build.
#
#   scripts/smoke_test.sh [BASE_URL] [EXPECTED_REVISION]
#
# EXPECTED_REVISION is the git SHA stamped into index.html at build time.
# When set, the script waits (up to WAIT_SECONDS, default 600) for the site
# to serve that revision before running the checks.
set -euo pipefail

BASE_URL="${1:-https://www.flutterbirmingham.co.uk}"
BASE_URL="${BASE_URL%/}"
EXPECTED_REVISION="${2:-}"
WAIT_SECONDS="${WAIT_SECONDS:-600}"

failures=0
pass() { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

status_of() { curl -sS -o /dev/null -w '%{http_code}' -m 30 "$1" || echo 000; }

if [[ -n "$EXPECTED_REVISION" ]]; then
  echo "Waiting for $BASE_URL to serve revision $EXPECTED_REVISION ..."
  deadline=$((SECONDS + WAIT_SECONDS))
  until curl -sS -m 30 "$BASE_URL/" 2>/dev/null |
    grep -q "name=\"build-revision\" content=\"$EXPECTED_REVISION\""; do
    if ((SECONDS >= deadline)); then
      echo "Timed out: $BASE_URL is not serving $EXPECTED_REVISION."
      echo "Check the Hostinger Git deployment (branch hostinger-deploy, webhook)."
      exit 1
    fi
    sleep 15
  done
  echo "Revision is live."
fi

echo "App routes (expect 200 + Flutter index.html):"
for path in / /events /team /code-of-conduct /events/launch-meetup; do
  body="$(curl -sS -m 30 -w '\n%{http_code}' "$BASE_URL$path" || printf '\n000')"
  code="${body##*$'\n'}"
  if [[ "$code" == 200 ]] && grep -q 'flutter_bootstrap.js' <<<"$body"; then
    pass "$path"
  else
    fail "$path (HTTP $code)"
  fi
done

echo "Build assets (expect 200):"
for path in /flutter_bootstrap.js /main.dart.js /manifest.json /favicon.png \
  /og-image.png /assets/AssetManifest.bin.json \
  /assets/assets/logos/flutter_birmingham_logo_256.webp \
  /assets/assets/fonts/GoogleSans-Regular.ttf \
  /assets/assets/images/team/ibim_braide.jpg; do
  code="$(status_of "$BASE_URL$path")"
  [[ "$code" == 200 ]] && pass "$path" || fail "$path (HTTP $code)"
done

# Chrome runs the wasm build and rejects these files if served as text/plain.
for pair in "/main.dart.wasm application/wasm" "/main.dart.mjs text/javascript" \
  "/canvaskit/skwasm.wasm application/wasm"; do
  read -r path want <<<"$pair"
  type="$(curl -sS -o /dev/null -I -w '%{content_type}' -m 30 "$BASE_URL$path" || true)"
  [[ "$type" == "$want"* ]] && pass "$path is $want" || fail "$path content-type is '$type'"
done

echo "Source files must not be public (expect 404/403):"
for path in /pubspec.yaml /README.md /lib/main.dart /web/index.html; do
  code="$(status_of "$BASE_URL$path")"
  [[ "$code" == 404 || "$code" == 403 ]] && pass "$path ($code)" || fail "$path (HTTP $code)"
done

if ((failures)); then
  echo "$failures check(s) failed."
  exit 1
fi
echo "All checks passed."
