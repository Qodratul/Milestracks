# Milestracks Mobile

Flutter client for the Milestracks running-adventure app on Android and iOS. The client supports account onboarding/sign-in, route preparation, live run tracking, milestone feedback, Safe Stop, results/recovery, run history, profile, inventory/shop, and English/Indonesian localization. Some secondary destinations remain previews or placeholders; see **Current scope** below.

## Requirements

- Flutter SDK compatible with `pubspec.yaml` (Dart `^3.13.5`).
- Android Studio/Android SDK for Android, or Xcode on macOS for iOS.
- A running Milestracks API for remote mode. Start it using the [API README](../api/README.md).

## Run locally

From `apps/mobile`:

```powershell
Copy-Item env/development.json.example env/development.local.json
flutter pub get
flutter run --dart-define-from-file=env/development.local.json
```

The example targets `http://10.0.2.2:3000/api/v1` for the Android emulator. For iOS Simulator, set `API_BASE_URL` to `http://localhost:3000/api/v1`. For a physical phone, use the development computer's LAN IP and ensure both devices can reach it. Local HTTP is accepted only in development debug builds; other builds require HTTPS.

To use fake repositories for UI development, set `USE_FAKE_API` to `true` in the local dart-define JSON. Fake mode does not call the API and is not a substitute for testing remote integration.

## Configuration

`env/development.json.example` documents compile-time settings:

- `APP_FLAVOR`: `development`, `staging`, or `production`.
- `USE_FAKE_API`: switch between fake and remote repositories.
- `API_BASE_URL`: API root, including `/api/v1`.
- `GOOGLE_CLIENT_ID`, `GOOGLE_SERVER_CLIENT_ID`: platform OAuth client IDs for Google Sign-In. Configure matching Android SHA-1/iOS URL scheme and API audience.
- `MAP_TILE_URL`, `MAP_DARK_TILE_URL`, `MAP_TILE_KEY`, `MAP_TILE_ATTRIBUTION`: optional map tile source. Use a provider you are authorized to use and preserve required attribution. Do not ship the development OpenStreetMap raster tile endpoint as a production tile service.
- `SENTRY_DSN`: optional crash reporting endpoint.

Keep `development.local.json`, credentials, and provider keys out of version control. Client IDs are not secrets, but configure them for the intended environment. Never put server credentials in the app.

## Run engine notes

The app collects location updates on-device and renders route/run progress locally while synchronizing run state with the API. Location quality depends on device permissions, GPS reception, operating-system background behavior, and movement. Test GPS behavior outdoors and on a physical device before relying on pace or distance. Safe Stop is a user-controlled early stop; route safety scores and map data cannot guarantee that an area is safe.

## Checks

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test --dart-define=USE_FAKE_API=true
```

## Current scope

League and Friends are placeholders. Notifications, readiness/deletion, payment/top-up, password reset/email verification, and other preview screens do not represent complete backend workflows. Item/economy and run outcomes shown in remote mode depend on the API; fake mode uses fixtures.

## License

Project source code is licensed under Apache-2.0; see the repository [LICENSE](../../LICENSE). Third-party packages and bundled assets retain their own licenses and attribution requirements. Google sign-in imagery, fonts, map tiles/data, and Flutter dependencies are not relicensed by the project license.
