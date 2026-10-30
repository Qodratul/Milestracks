import 'package:dio/dio.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/storage/local_data_cache.dart';

abstract class RemoteRepositoryBase {
  const RemoteRepositoryBase(this.dio, {this.cache});

  final Dio dio;
  final LocalDataCache? cache;

  Future<T> cachedRead<T>({
    required String key,
    required Duration maxAge,
    required Future<T> Function() fetch,
    required Object? Function(T value) encode,
    required T Function(Object? value) decode,
  }) {
    final localCache = cache;
    if (localCache == null) return fetch();
    return localCache.getOrFetch<T>(
      key: key,
      maxAge: maxAge,
      fetch: fetch,
      encode: encode,
      decode: decode,
    );
  }

  Future<void> invalidateCache(String key) async => cache?.invalidate(key);

  Future<void> invalidateCachePrefix(String prefix) async =>
      cache?.invalidatePrefix(prefix);

  Map<String, dynamic> objectData(Object? responseBody) {
    if (responseBody is Map<String, dynamic> &&
        responseBody['data'] is Map<String, dynamic>) {
      return responseBody['data'] as Map<String, dynamic>;
    }
    throw const FormatException(
      'API response did not contain an object data envelope.',
    );
  }

  List<dynamic> listData(Object? responseBody) {
    if (responseBody is Map<String, dynamic> &&
        responseBody['data'] is List<dynamic>) {
      return responseBody['data'] as List<dynamic>;
    }
    throw const FormatException(
      'API response did not contain a list data envelope.',
    );
  }

  Future<T> guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      throw AppException.fromDio(error);
    }
  }

  Future<T> retryIdempotent<T>(Future<T> Function() request) async {
    for (var attempt = 0; ; attempt++) {
      try {
        return await request();
      } on DioException catch (error) {
        final transient = switch (error.type) {
          DioExceptionType.connectionTimeout ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.connectionError => true,
          _ => false,
        };
        if (attempt > 0 || !transient) rethrow;
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }
  }
}
