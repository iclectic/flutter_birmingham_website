# Flutter Birmingham Website

The official Flutter Birmingham community website — built with Flutter Web.

## About

Flutter Birmingham is a free, independent community meetup for Flutter and Dart developers in Birmingham and the Midlands. This repository contains the full source code for the community website.

---

## Tech stack

| Concern | Package |
|---|---|
| Framework | Flutter 3.x (Web) |
| Routing | `go_router` |
| State management | `flutter_riverpod` |
| Fonts | `google_fonts` (Plus Jakarta Sans) |
| Link launching | `url_launcher` |
| SVG support | `flutter_svg` |
| Scroll animations | `visibility_detector` |
| Markdown rendering | `flutter_markdown` |
| Date formatting | `intl` |

---

## Project structure

```
lib/
├── app/
│   ├── app.dart              # MaterialApp.router root widget
│   ├── providers.dart        # All Riverpod providers
│   ├── router.dart           # go_router configuration
│   └── theme/
│       └── app_theme.dart    # ThemeData, text styles, component themes
├── core/
│   ├── constants/
│   │   ├── app_colors.dart   # Brand colour palette
│   │   ├── app_spacing.dart  # Spacing, radius, and width constants
│   │   └── app_strings.dart  # All static text and external URLs
│   ├── responsive/
│   │   ├── breakpoints.dart  # Screen-size helpers
│   │   └── responsive_layout.dart  # ResponsiveLayout, ContentContainer, ResponsiveGrid
│   └── widgets/
│       ├── app_footer.dart
│       ├── app_nav_bar.dart
│       ├── app_shell.dart
│       ├── fade_in_widget.dart
│       ├── fb_logo.dart
│       ├── not_found_page.dart
│       ├── placeholder_image.dart
│       └── section_heading.dart
├── data/
│   ├── models/               # Dart data models (CommunityEvent, TeamMember, …)
│   ├── repositories/         # Abstract + local repository implementations
│   └── sample_data/          # Placeholder data (replace with real content)
├── features/
│   ├── about/
│   ├── code_of_conduct/
│   ├── contact/
│   ├── events/
│   ├── gallery/
│   ├── home/
│   └── team/
├── services/
│   ├── contact_service.dart  # Contact form service (mock + interface)
│   └── url_service.dart      # URL launcher utilities
└── main.dart
```

---

## Installation

**Prerequisites:** Flutter stable channel (≥ 3.10), Chrome or any modern browser.

```bash
# Clone the repo
git clone https://github.com/flutter-birmingham/flutter-birmingham-website.git
cd flutter-birmingham-website

# Fetch dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run on any available browser
flutter run -d web-server --web-port 8080
```

---

## Running tests

```bash
flutter test
```

The test suite covers:

- `FBLogo` widget rendering
- `SectionHeading` with/without eyebrow and subtitle
- `PlaceholderImage` label rendering
- `AssetImageOrPlaceholder` graceful fallback
- `CommunityStats` data integrity
- Sample events validation (required fields, date correctness, recordings)
- `CommunityEvent` model helper getters (`isUpcoming`, `isPast`, `hasRecording`)
- `MockContactService` submission storage
- `AppTheme` colour scheme and Material 3

---

## Building for production

```bash
flutter build web --release
```

Output is in `build/web/`. This directory is what you deploy.

---

## Deployment

### Firebase Hosting (recommended)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Log in and initialise (one time)
firebase login
firebase init hosting   # point to build/web, enable SPA rewrite

# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

The included `firebase.json` is pre-configured with SPA rewrites and cache headers.

### Netlify / Vercel / GitHub Pages

1. Build: `flutter build web --release`
2. Upload the contents of `build/web/` to your static host.
3. Configure a "catch-all" redirect to `index.html` for SPA routing.

---

## Updating content

### Events

Edit `lib/data/sample_data/sample_events.dart`. Each `CommunityEvent` accepts:

- `id` — unique slug
- `title`, `description`
- `startDateTime`, `endDateTime`
- `venueName`, `venueAddress`
- `imageAsset` — path in `assets/images/events/`
- `registrationUrl` — Meetup / Eventbrite link
- `speakers` — list of `EventSpeaker`
- `agenda` — list of `AgendaItem`
- `videoUrl`, `slidesUrl` — optional, shown after the event
- `topics` — tag list

### Team

Edit `lib/data/sample_data/sample_team.dart`. Photos go in `assets/images/team/`.

### Gallery

Edit `lib/data/sample_data/sample_gallery.dart`. Photos go in `assets/images/gallery/`.

### Sponsors

Edit `lib/data/sample_data/sample_sponsors.dart`. Logos go in `assets/images/sponsors/`.

### External links and copy

All URLs and static text live in `lib/core/constants/app_strings.dart`. Update the Meetup, LinkedIn, YouTube, GitHub, speaker form, and sponsorship URLs before launching.

---

## Accessibility

- All interactive elements have semantic labels or `Semantics` wrappers.
- Keyboard focus states use the theme's default focus indicator.
- Colour contrast ratios respect WCAG AA for all body text.
- `FadeInWidget` respects `MediaQuery.disableAnimations` (reduced motion).
- Navigation uses `go_router` with consistent route paths.

---

## SEO

- `web/index.html` includes Open Graph, Twitter Card, and standard meta tags.
- The PWA manifest (`web/manifest.json`) is configured with brand name and colours.
- Titles and descriptions can be customised per route by updating `AppStrings`.

---

## Package choices

| Package | Reason |
|---|---|
| `go_router` | URL-based routing with deep linking, shell routes, and query parameters |
| `flutter_riverpod` | Compile-safe providers, easy testing, no boilerplate |
| `google_fonts` | Plus Jakarta Sans — clean, modern, free |
| `url_launcher` | Platform-safe external link and `mailto:` launching |
| `visibility_detector` | Scroll-triggered fade-in animations |
| `flutter_markdown` | Render the Code of Conduct from Markdown without hand-coding HTML |
| `intl` | Locale-aware date formatting |

---

## Limitations and known issues

- Sample data uses placeholder images (`PlaceholderImage` widget) and fake content. Replace before launch.
- The contact form uses `MockContactService`. Wire up a real backend (e.g. Firebase Functions, Formspree) in `contact_service.dart`.
- The speaker form URL points to a placeholder Google Form. Replace `AppStrings.speakerFormUrl`.
- The Code of Conduct email (`conduct@flutterbirmingham.dev`) is a placeholder.
- The site domain (`flutterbirmingham.dev`) is a placeholder in `web/index.html` Open Graph tags.

---

## Future improvements

- Connect real event data via a CMS or Firestore.
- Add route-level `<title>` updates using a web-compatible title strategy.
- Implement Firebase Analytics for page views.
- Add a lightbox carousel in the gallery (currently single-image).
- Progressive Web App offline support.
- Dark mode theme.

---

## Contributing

Pull requests are welcome. Please open an issue first for significant changes. All contributors must abide by the [Code of Conduct](/code-of-conduct).

---

## Getting Started with Flutter Web

A few resources if you are new to Flutter Web:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter Web deployment](https://docs.flutter.dev/deployment/web)
- [go_router documentation](https://pub.dev/packages/go_router)
- [Riverpod documentation](https://riverpod.dev)

