import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/error/app_exception.dart';

void main() {
  test('maps backend validation, conflict, rate limit, and auth errors', () {
    expect(_fromStatus(422).kind, AppExceptionKind.validation);
    expect(_fromStatus(409).kind, AppExceptionKind.conflict);
    expect(_fromStatus(429).kind, AppExceptionKind.rateLimit);
    expect(
      _fromStatus(401, code: 'INVALID_CREDENTIALS').message,
      'authInvalidCredentials',
    );
  });
}

AppException _fromStatus(int status, {String? code}) {
  final request = RequestOptions(path: '/test');
  return AppException.fromDio(
    DioException(
      requestOptions: request,
      response: Response<Object?>(
        requestOptions: request,
        statusCode: status,
        data: <String, Object?>{
          'error': <String, Object?>{
            'code': ?code,
            'message': 'do not show this raw server text',
          },
        },
      ),
    ),
  );
}
