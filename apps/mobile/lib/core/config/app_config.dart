import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static const flavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'development',
  );

  static const useFakeApi = bool.fromEnvironment(
    'USE_FAKE_API',
    defaultValue: false,
  );

  static const googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID');
  static const googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
  );

  static const _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

  static const isDevelopmentDebug = kDebugMode && flavor == 'development';

  static final apiBaseUrl = _resolveApiBaseUrl();

  static String _resolveApiBaseUrl() {
    if (_apiBaseUrlOverride.isNotEmpty) {
      final uri = Uri.parse(_apiBaseUrlOverride);
      if (!const <String>{'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty) {
        throw StateError('API_BASE_URL must be an absolute HTTP(S) URL.');
      }
      if (!isDevelopmentDebug && uri.scheme != 'https') {
        throw StateError(
          'Only development debug builds may use an HTTP API_BASE_URL.',
        );
      }
      return _apiBaseUrlOverride;
    }

    if (!isDevelopmentDebug) {
      throw StateError(
        'Set API_BASE_URL to the HTTPS API endpoint for this build flavor.',
      );
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'http://10.0.2.2:3000/api/v1',
      _ => 'http://localhost:3000/api/v1',
    };
  }

  static const mapTileUrl = String.fromEnvironment('MAP_TILE_URL');
  static const mapDarkTileUrl = String.fromEnvironment('MAP_DARK_TILE_URL');
  static const mapTileKey = String.fromEnvironment('MAP_TILE_KEY');
  static const mapTileAttribution = String.fromEnvironment(
    'MAP_TILE_ATTRIBUTION',
  );
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');
}
