import 'package:dio/dio.dart';

enum AppExceptionKind {
  validation,
  unauthorized,
  conflict,
  rateLimit,
  server,
  timeout,
  network,
  unknown,
}

class AppException implements Exception {
  const AppException({
    required this.kind,
    required this.message,
    this.statusCode,
    this.backendCode,
    this.retryAfterSeconds,
    this.details,
  });

  final AppExceptionKind kind;
  final String message;
  final int? statusCode;
  final String? backendCode;
  final int? retryAfterSeconds;
  final Map<String, dynamic>? details;

  factory AppException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final body = error.response?.data;
    final errorBody = body is Map<String, dynamic> ? body['error'] : null;
    final errorObject = errorBody is Map<String, dynamic> ? errorBody : null;
    final backendCode = errorObject?['code'] as String?;
    final details = errorObject?['details'];
    final retryAfterSeconds = details is Map<String, dynamic>
        ? details['retryAfterSec'] as int?
        : null;
    final kind = switch (statusCode) {
      400 || 422 => AppExceptionKind.validation,
      401 || 403 => AppExceptionKind.unauthorized,
      409 => AppExceptionKind.conflict,
      429 => AppExceptionKind.rateLimit,
      final int code when code >= 500 => AppExceptionKind.server,
      _
          when error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout =>
        AppExceptionKind.timeout,
      _ when error.type == DioExceptionType.connectionError =>
        AppExceptionKind.network,
      _ => AppExceptionKind.unknown,
    };
    return AppException(
      kind: kind,
      statusCode: statusCode,
      backendCode: backendCode,
      retryAfterSeconds: retryAfterSeconds,
      details: details is Map
          ? Map<String, dynamic>.from(details)
          : null,
      message: _messageFor(kind, backendCode),
    );
  }

  static String _messageFor(AppExceptionKind kind, String? code) {
    if (code == 'INVALID_CREDENTIALS') return 'authInvalidCredentials';
    if (code == 'EMAIL_TAKEN') return 'authEmailTaken';
    if (code == 'GOOGLE_AUTH_UNAVAILABLE') return 'googleSignInNotConfigured';
    if (code == 'INVALID_GOOGLE_TOKEN') return 'googleSignInFailed';
    if (code == 'INSUFFICIENT_COINS') return 'insufficientCoins';
    return switch (kind) {
      AppExceptionKind.validation => 'validationError',
      AppExceptionKind.unauthorized => 'sessionExpired',
      AppExceptionKind.conflict => 'conflictError',
      AppExceptionKind.rateLimit => 'rateLimitError',
      AppExceptionKind.server => 'serverError',
      AppExceptionKind.timeout => 'requestTimedOut',
      AppExceptionKind.network => 'networkError',
      AppExceptionKind.unknown => 'unknownError',
    };
  }

  @override
  String toString() => 'AppException(${kind.name}, statusCode: $statusCode)';
}
