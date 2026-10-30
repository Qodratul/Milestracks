import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/network/api_client.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';

void main() {
  test('adds bearer, selected language, and an idempotency UUID', () async {
    final storage = MemorySecureStorageService()
      ..write(SecureStorageKeys.accessToken, 'access-token');
    RequestOptions? receivedRequest;
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
      ..httpClientAdapter = _FakeAdapter((request) async {
        receivedRequest = request;
        return _jsonResponse(200, <String, Object?>{'ok': true});
      });
    dio.interceptors.add(
      AuthAndHeadersInterceptor(
        dio: dio,
        refreshDio: Dio(BaseOptions(baseUrl: 'https://api.example.test')),
        storage: storage,
        language: () => 'id',
        onSessionExpired: () async {},
      ),
    );
    addTearDown(() => dio.close(force: true));

    await dio.post<Object?>('/runs');

    expect(receivedRequest?.headers['Authorization'], 'Bearer access-token');
    expect(receivedRequest?.headers['Accept-Language'], 'id');
    expect(
      receivedRequest?.headers['Idempotency-Key'],
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('concurrent unauthorized requests share one token refresh', () async {
    final storage = MemorySecureStorageService();
    await storage.write(SecureStorageKeys.accessToken, 'expired-access');
    await storage.write(SecureStorageKeys.refreshToken, 'refresh-token');
    var refreshCount = 0;
    var successfulRetryCount = 0;

    final refreshDio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
      ..httpClientAdapter = _FakeAdapter((request) async {
        refreshCount++;
        await Future<void>.delayed(const Duration(milliseconds: 25));
        return _jsonResponse(200, <String, Object?>{
          'data': <String, Object?>{
            'accessToken': 'fresh-access',
            'refreshToken': 'fresh-refresh',
          },
          'meta': <String, Object?>{'requestId': 'req_test'},
        });
      });
    final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
      ..httpClientAdapter = _FakeAdapter((request) async {
        if (request.headers['Authorization'] == 'Bearer fresh-access') {
          successfulRetryCount++;
          return _jsonResponse(200, <String, Object?>{'ok': true});
        }
        return _jsonResponse(401, <String, Object?>{'error': 'unauthorized'});
      });
    dio.interceptors.add(
      AuthAndHeadersInterceptor(
        dio: dio,
        refreshDio: refreshDio,
        storage: storage,
        language: () => 'en',
        onSessionExpired: () async {},
      ),
    );
    addTearDown(() {
      dio.close(force: true);
      refreshDio.close(force: true);
    });

    await Future.wait<Object?>(<Future<Object?>>[
      dio.get<Object?>('/me'),
      dio.get<Object?>('/runs'),
    ]);

    expect(refreshCount, 1);
    expect(successfulRetryCount, 2);
    expect(await storage.read(SecureStorageKeys.accessToken), 'fresh-access');
    expect(await storage.read(SecureStorageKeys.refreshToken), 'fresh-refresh');
  });

  test(
    'retries transient GET responses but does not retry mutations',
    () async {
      var getCount = 0;
      var postCount = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
        ..httpClientAdapter = _FakeAdapter((request) async {
          if (request.method == 'GET') {
            getCount++;
            return getCount < 3
                ? _jsonResponse(503, <String, Object?>{'error': 'unavailable'})
                : _jsonResponse(200, <String, Object?>{'data': 'ok'});
          }
          postCount++;
          return _jsonResponse(503, <String, Object?>{'error': 'unavailable'});
        });
      dio.interceptors.add(TransientGetRetryInterceptor(dio));
      addTearDown(() => dio.close(force: true));

      await dio.get<Object?>('/me');
      await expectLater(
        dio.post<Object?>('/runs'),
        throwsA(isA<DioException>()),
      );

      expect(getCount, 3);
      expect(postCount, 1);
    },
  );
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handleRequest);

  final Future<ResponseBody> Function(RequestOptions request) handleRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handleRequest(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(int statusCode, Map<String, Object?> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
