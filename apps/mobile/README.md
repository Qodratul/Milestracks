# Milestracks Mobile

Flutter client for Android and iOS. The current app is a scaffold; feature work
is being introduced in approved stages.

## Setup

Requires Flutter 3.47.7 (Dart 3.13.5).

```powershell
Copy-Item env/development.json.example env/development.local.json
flutter pub get
flutter run --dart-define-from-file=env/development.local.json
```

Remote API mode is enabled by default. Android emulator development uses
`http://10.0.2.2:3000/api/v1`; iOS simulator development uses
`http://localhost:3000/api/v1`. For a physical device, set `API_BASE_URL` to
the development machine's LAN address. Use `USE_FAKE_API=true` to switch back
to the Fake repositories. Debug builds allow HTTP locally; release builds
require an explicit HTTPS `API_BASE_URL`.

Copy `env/development.json.example` to a local-only file before running. For an
iOS simulator, replace its API URL with `http://localhost:3000/api/v1`. Add map
tile keys and Sentry DSN only through local dart-define files or CI secrets; do
not commit them.

Supported compile-time settings: `APP_FLAVOR` (`development`, `staging`, or
`production`), `USE_FAKE_API`, `API_BASE_URL`, `MAP_TILE_URL`, `MAP_TILE_KEY`,
`GOOGLE_CLIENT_ID`, `GOOGLE_SERVER_CLIENT_ID`, and `SENTRY_DSN`.

Google sign-in needs an OAuth client for the app platform and a Web/server
OAuth client. Set the iOS client ID in `GOOGLE_CLIENT_ID` and the Web client ID
in `GOOGLE_SERVER_CLIENT_ID`; configure the matching Android SHA-1 and iOS URL
scheme in Google Cloud. The API's `GOOGLE_CLIENT_ID` must equal the Web client
ID used as `GOOGLE_SERVER_CLIENT_ID`. These IDs are public client identifiers,
but keep environment-specific values in local files. No client secret belongs
in the mobile app.

## Checks

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --dart-define=USE_FAKE_API=true
```

The root GitHub Actions workflow runs these checks for mobile changes.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
