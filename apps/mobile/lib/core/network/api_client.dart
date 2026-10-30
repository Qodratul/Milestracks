import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/config/app_config.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

@Riverpod(keepAlive: true)
Dio apiClient(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: const <String, Object>{'Accept': 'application/json'},
    ),
  );
  final refreshDio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: const <String, Object>{'Accept': 'application/json'},
    ),
  );
  final interceptor = AuthAndHeadersInterceptor(
    dio: dio,
    refreshDio: refreshDio,
    storage: storage,
    language: () => ref.read(languageControllerProvider).languageCode,
    onSessionExpired: () =>
        ref.read(sessionControllerProvider.notifier).signOut(
          revokeServerSession: false,
        ),
  );
  dio.interceptors.add(interceptor);
  dio.interceptors.add(TransientGetRetryInterceptor(dio));
  ref.onDispose(() {
    dio.close(force: true);
    refreshDio.close(force: true);
  });
  return dio;
}

class AuthAndHeadersInterceptor extends Interceptor {
  AuthAndHeadersInterceptor({
    required this._dio,
    required this._refreshDio,
    required this._storage,
    required this._language,
    required this._onSessionExpired,
  });

  final Dio _dio;
  final Dio _refreshDio;
  final SecureStorageService _storage;
  final String Function() _language;
  final Future<void> Function() _onSessionExpired;
  Future<_TokenPair?>? _refreshing;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept-Language'] = _language();
    final accessToken = await _storage.read(SecureStorageKeys.accessToken);
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    if (_changesServerState(options.method) &&
        options.headers['Idempotency-Key'] == null) {
      options.headers['Idempotency-Key'] = IdempotencyKey.create();
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final canRefresh =
        err.response?.statusCode == 401 &&
        request.extra['authRetry'] != true &&
        !_isRefreshRequest(request.path) &&
        !_isPublicAuthRequest(request.path);
    if (!canRefresh) {
      handler.next(err);
      return;
    }

    try {
      final pair = await (_refreshing ??= _refreshTokens());
      _refreshing = null;
      if (pair == null) {
        await _clearTokens();
        await _onSessionExpired();
        handler.next(err);
        return;
      }
      request
        ..extra['authRetry'] = true
        ..headers['Authorization'] = 'Bearer ${pair.accessToken}';
      handler.resolve(await _dio.fetch<Object?>(request));
    } on DioException {
      _refreshing = null;
      await _clearTokens();
      await _onSessionExpired();
      handler.next(err);
    } catch (_) {
      _refreshing = null;
      await _clearTokens();
      await _onSessionExpired();
      handler.next(err);
    }
  }

  Future<_TokenPair?> _refreshTokens() async {
    final refreshToken = await _storage.read(SecureStorageKeys.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) return null;
    final response = await _refreshDio.post<Map<String, Object?>>(
      '/auth/refresh',
      data: <String, String>{'refreshToken': refreshToken},
      options: Options(
        headers: <String, Object>{'Accept-Language': _language()},
      ),
    );
    final envelope = response.data;
    final data = envelope is Map<String, dynamic>
        ? envelope['data'] as Map<String, dynamic>?
        : null;
    final accessToken = data?['accessToken'] as String?;
    final nextRefreshToken = data?['refreshToken'] as String?;
    if (accessToken == null || nextRefreshToken == null) return null;
    await _storage.write(SecureStorageKeys.accessToken, accessToken);
    await _storage.write(SecureStorageKeys.refreshToken, nextRefreshToken);
    return _TokenPair(accessToken, nextRefreshToken);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(SecureStorageKeys.accessToken);
    await _storage.delete(SecureStorageKeys.refreshToken);
  }

  bool _isRefreshRequest(String path) => path.endsWith('/auth/refresh');

  bool _isPublicAuthRequest(String path) =>
      path.endsWith('/auth/login') ||
      path.endsWith('/auth/register') ||
      path.endsWith('/auth/google');

  bool _changesServerState(String method) => const <String>{
    'POST',
    'PUT',
    'PATCH',
    'DELETE',
  }.contains(method.toUpperCase());
}

class _TokenPair {
  const _TokenPair(this.accessToken, this.refreshToken);

  final String accessToken;
  final String refreshToken;
}

class TransientGetRetryInterceptor extends Interceptor {
  TransientGetRetryInterceptor(this._dio);

  final Dio _dio;
  static const _maxRetries = 3;
  static const _attemptKey = 'transientGetRetryAttempt';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final attempt = request.extra[_attemptKey] as int? ?? 0;
    if (request.method.toUpperCase() != 'GET' ||
        attempt >= _maxRetries ||
        !_isTransient(err)) {
      handler.next(err);
      return;
    }

    request.extra[_attemptKey] = attempt + 1;
    await Future<void>.delayed(_retryDelay(err, attempt));
    try {
      handler.resolve(await _dio.fetch<Object?>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isTransient(DioException error) {
    final status = error.response?.statusCode;
    if (status == 408 ||
        status == 429 ||
        status == 502 ||
        status == 503 ||
        status == 504) {
      return true;
    }
    if (status != null) return false;
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError;
  }

  Duration _retryDelay(DioException error, int attempt) {
    final retryAfter = _retryAfter(
      error.response?.headers.value('retry-after'),
    );
    if (retryAfter != null) return retryAfter;
    final milliseconds = 500 * (1 << attempt);
    return Duration(milliseconds: milliseconds.clamp(0, 8000).toInt());
  }

  Duration? _retryAfter(String? value) {
    if (value == null) return null;
    final seconds = int.tryParse(value.trim());
    if (seconds != null) {
      return Duration(seconds: seconds < 0 ? 0 : seconds);
    }
    DateTime? date;
    try {
      date = DateFormat(
        "EEE, dd MMM yyyy HH:mm:ss 'GMT'",
        'en_US',
      ).parseUtc(value);
    } on FormatException {
      return null;
    }
    final remaining = date.difference(DateTime.now());
    if (remaining <= Duration.zero) return Duration.zero;
    return remaining;
  }
}
