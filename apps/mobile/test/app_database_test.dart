import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/storage/app_database.dart';
import 'package:milestracks/shared/models/api_models.dart';

void main() {
  test('local database stores pending run points for offline sync', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);

    await database
        .into(database.pendingRunPoints)
        .insert(
          PendingRunPointsCompanion.insert(
            runId: 'run-1',
            sequence: 1,
            latitude: -6.2,
            longitude: 106.8,
            recordedAt: DateTime.utc(2026, 10, 25),
          ),
        );

    final points = await database.select(database.pendingRunPoints).get();
    expect(points, hasLength(1));
    expect(points.single.runId, 'run-1');
    expect(points.single.synced, isFalse);
  });

  test(
    'offline batches retain their idempotency key until acknowledged',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await database.appendRunPoints('run-offline', <RunPointDto>[
        RunPointDto(
          latitude: -6.2,
          longitude: 106.8,
          recordedAt: DateTime.utc(2026, 10, 26),
          accuracyMeters: 5,
        ),
      ]);

      final claimed = await database.claimNextRunPointBatch(
        'run-offline',
        idempotencyKey: 'batch-key',
      );
      final retried = await database.claimNextRunPointBatch(
        'run-offline',
        idempotencyKey: 'new-key-must-not-replace-retry-key',
      );
      expect(claimed.single.uploadBatchKey, 'batch-key');
      expect(retried.single.uploadBatchKey, 'batch-key');

      await database.markRunPointBatchSynced(<int>[claimed.single.id]);
      expect(await database.pendingRunPointsFor('run-offline'), isEmpty);
      expect(await database.pendingRunIds(), isEmpty);
    },
  );

  test('terminal actions persist an idempotent offline outbox entry', () async {
    final database = AppDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.enqueueRunAction(
      runId: 'run-offline',
      action: 'safe_stop',
      idempotencyKey: 'safe-stop-key',
      payload: <String, Object?>{'reasonCode': 'user_requested'},
    );

    final actions = await database.getPendingRunActions();
    expect(actions.single.runId, 'run-offline');
    expect(actions.single.idempotencyKey, 'safe-stop-key');
    expect(actions.single.payloadJson, contains('user_requested'));
  });
}
