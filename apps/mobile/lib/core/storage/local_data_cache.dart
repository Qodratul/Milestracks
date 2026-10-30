import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/storage/app_database.dart';

class LocalDataCache {
  const LocalDataCache(this._database);

  final Future<AppDatabase> Function() _database;

  Future<T> getOrFetch<T>({
    required String key,
    required Duration maxAge,
    required Future<T> Function() fetch,
    required Object? Function(T value) encode,
    required T Function(Object? value) decode,
  }) async {
    AppDatabase? database;
    Map<String, dynamic>? cached;
    try {
      database = await _database();
      cached = await database.readCachedJson(key);
    } on Object {
      // The API remains usable if local storage cannot be opened.
    }

    final cachedAt = cached?['cachedAt'];
    final payload = cached?['payload'];
    if (cachedAt is int && cached != null) {
      final age = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(cachedAt, isUtc: true),
      );
      if (!age.isNegative && age <= maxAge) {
        try {
          return decode(payload);
        } on Object {
          try {
            await database?.removeCachedJson(key);
          } on Object {
            // Invalid cached data must not prevent a network refresh.
          }
        }
      }
    }

    try {
      final value = await fetch();
      try {
        await database?.writeCachedJson(key, <String, Object?>{
          'cachedAt': DateTime.now().toUtc().millisecondsSinceEpoch,
          'payload': encode(value),
        });
      } on Object {
        // A cache write failure does not invalidate a successful API response.
      }
      return value;
    } on Object catch (error) {
      if (cached != null && _canUseStale(error)) {
        try {
          return decode(payload);
        } on Object {
          try {
            await database?.removeCachedJson(key);
          } on Object {
            // Preserve the original request error below.
          }
        }
      }
      rethrow;
    }
  }

  Future<void> invalidate(String key) async {
    try {
      await (await _database()).removeCachedJson(key);
    } on Object {
      // Cache invalidation is best effort; the server remains authoritative.
    }
  }

  Future<void> invalidatePrefix(String prefix) async {
    try {
      await (await _database()).removeCachedJsonPrefix(prefix);
    } on Object {
      // Cache invalidation is best effort; the server remains authoritative.
    }
  }

  Future<void> clear() async {
    try {
      await (await _database()).clearCachedJson();
    } on Object {
      // Cache clearing must not block authentication state changes.
    }
  }

  bool _canUseStale(Object error) =>
      error is AppException &&
      (error.kind == AppExceptionKind.network ||
          error.kind == AppExceptionKind.timeout ||
          error.kind == AppExceptionKind.server);
}
