import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

class PendingRunPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get runId => text()();
  IntColumn get sequence => integer()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real().nullable()();
  RealColumn get speedMetersPerSecond => real().nullable()();
  BoolColumn get mocked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get uploadBatchKey => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{runId, sequence},
  ];
}

class PendingRunActions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get runId => text()();
  TextColumn get action => text()();
  TextColumn get payloadJson => text()();
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class LocalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{key};
}

@DriftDatabase(
  tables: <Type>[PendingRunPoints, LocalSettings, PendingRunActions],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(
          pendingRunPoints,
          pendingRunPoints.speedMetersPerSecond,
        );
        await m.addColumn(pendingRunPoints, pendingRunPoints.uploadBatchKey);
      }
      if (from < 3) await m.createTable(pendingRunActions);
      if (from < 4) {
        await m.addColumn(pendingRunPoints, pendingRunPoints.mocked);
      }
    },
  );

  Future<void> appendRunPoints(String runId, List<RunPointDto> points) async {
    if (points.isEmpty) return;
    await transaction(() async {
      final existing =
          await (select(pendingRunPoints)
                ..where((row) => row.runId.equals(runId))
                ..orderBy([(row) => OrderingTerm.desc(row.sequence)])
                ..limit(1))
              .getSingleOrNull();
      var sequence = (existing?.sequence ?? 0) + 1;
      await batch((batch) {
        batch.insertAll(
          pendingRunPoints,
          points.map(
            (point) => PendingRunPointsCompanion.insert(
              runId: runId,
              sequence: sequence++,
              latitude: point.latitude,
              longitude: point.longitude,
              accuracyMeters: Value(point.accuracyMeters),
              speedMetersPerSecond: Value(point.speedMetersPerSecond),
              mocked: Value(point.mocked),
              recordedAt: point.recordedAt,
            ),
          ),
        );
      });
    });
  }

  Future<List<PendingRunPoint>> pendingRunPointsFor(String runId) =>
      (select(pendingRunPoints)
            ..where((row) => row.runId.equals(runId) & row.synced.equals(false))
            ..orderBy([(row) => OrderingTerm.asc(row.sequence)]))
          .get();

  Future<List<String>> pendingRunIds() async {
    final rows = await (select(
      pendingRunPoints,
    )..where((row) => row.synced.equals(false))).get();
    return rows.map((row) => row.runId).toSet().toList(growable: false);
  }

  Future<List<PendingRunPoint>> claimNextRunPointBatch(
    String runId, {
    required String idempotencyKey,
    int limit = 50,
  }) => transaction(() async {
    final pending = await pendingRunPointsFor(runId);
    if (pending.isEmpty) return <PendingRunPoint>[];
    final existingKey = pending.first.uploadBatchKey;
    final selected = existingKey == null
        ? pending.take(limit).toList(growable: false)
        : pending.where((row) => row.uploadBatchKey == existingKey).toList();
    if (existingKey == null) {
      await (update(
        pendingRunPoints,
      )..where((row) => row.id.isIn(selected.map((item) => item.id)))).write(
        PendingRunPointsCompanion(uploadBatchKey: Value(idempotencyKey)),
      );
      return (select(pendingRunPoints)
            ..where((row) => row.id.isIn(selected.map((item) => item.id)))
            ..orderBy([(row) => OrderingTerm.asc(row.sequence)]))
          .get();
    }
    return selected;
  });

  Future<void> markRunPointBatchSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await (update(pendingRunPoints)..where((row) => row.id.isIn(ids))).write(
      const PendingRunPointsCompanion(
        synced: Value(true),
        uploadBatchKey: Value(null),
      ),
    );
  }

  Future<void> enqueueRunAction({
    required String runId,
    required String action,
    required String idempotencyKey,
    required Map<String, Object?> payload,
  }) async {
    await into(pendingRunActions).insert(
      PendingRunActionsCompanion.insert(
        runId: runId,
        action: action,
        payloadJson: jsonEncode(payload),
        idempotencyKey: idempotencyKey,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<PendingRunAction>> getPendingRunActions() => (select(
    pendingRunActions,
  )..orderBy([(row) => OrderingTerm.asc(row.createdAt)])).get();

  Future<void> removePendingRunAction(int id) async =>
      (delete(pendingRunActions)..where((row) => row.id.equals(id))).go();

  Future<Map<String, dynamic>?> readCachedJson(String cacheKey) async {
    final entry =
        await (select(localSettings)
              ..where((row) => row.key.equals('data-cache:$cacheKey')))
            .getSingleOrNull();
    if (entry == null) return null;
    try {
      final value = jsonDecode(entry.value);
      return value is Map ? Map<String, dynamic>.from(value) : null;
    } on FormatException {
      await (delete(
        localSettings,
      )..where((row) => row.key.equals('data-cache:$cacheKey'))).go();
      return null;
    }
  }

  Future<void> writeCachedJson(String cacheKey, Object? value) async {
    await into(localSettings).insertOnConflictUpdate(
      LocalSettingsCompanion.insert(
        key: 'data-cache:$cacheKey',
        value: jsonEncode(value),
      ),
    );
  }

  Future<void> removeCachedJson(String cacheKey) async {
    await (delete(
      localSettings,
    )..where((row) => row.key.equals('data-cache:$cacheKey'))).go();
  }

  Future<void> removeCachedJsonPrefix(String prefix) async {
    await (delete(
      localSettings,
    )..where((row) => row.key.like('data-cache:$prefix%'))).go();
  }

  Future<void> clearCachedJson() async {
    await (delete(
      localSettings,
    )..where((row) => row.key.like('data-cache:%'))).go();
  }

  static const _channel = MethodChannel('com.milestracks/storage');

  static Future<AppDatabase> open() async {
    final directoryPath = await _channel.invokeMethod<String>(
      'getApplicationSupportDirectory',
    );
    if (directoryPath == null || directoryPath.isEmpty) {
      throw const FileSystemException('App storage directory is unavailable.');
    }
    final directory = Directory(directoryPath);
    await directory.create(recursive: true);
    final file = File(
      '${directory.path}${Platform.pathSeparator}milestracks.db',
    );
    return AppDatabase(NativeDatabase.createInBackground(file));
  }
}

@Riverpod(keepAlive: true)
Future<AppDatabase> appDatabase(Ref ref) async {
  final database = await AppDatabase.open();
  ref.onDispose(() => database.close());
  return database;
}
