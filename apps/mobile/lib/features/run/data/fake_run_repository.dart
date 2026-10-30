import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeRunRepository implements RunRepository {
  FakeRunRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;
  int _nextRunNumber = 1;

  @override
  Future<ActiveRunRecovery?> getActiveRun() =>
      behavior.execute('run.active', () {
        final run = store.runs.values
            .where(
              (run) =>
                  run.status == RunStatus.running ||
                  run.status == RunStatus.paused,
            )
            .firstOrNull;
        if (run == null) return null;
        return ActiveRunRecovery(
          id: run.id,
          trackId: run.trackId,
          status: run.status,
          startedAt: run.startedAt,
          elapsedSeconds: run.durationSeconds ?? 0,
          distanceMeters: run.distanceMeters ?? 0,
          lastSampleSequence: 0,
          reachedMilestoneIds: const <String>[],
        );
      });

  @override
  Future<void> pauseRun(String runId) => behavior.execute('run.pause', () {});

  @override
  Future<void> resumeRun(String runId) => behavior.execute('run.resume', () {});

  @override
  Future<List<MilestoneDialogueDto>> getMilestoneDialogues(String runId) =>
      behavior.execute(
        'run.guidance',
        () => store.track(failed: false).narrative.milestoneDialogues,
      );

  @override
  Future<RunDto> startRun(
    StartRunRequestDto request, {
    String? idempotencyKey,
  }) => behavior.execute('run.start', () {
    final run = RunDto(
      id: 'run-active-${_nextRunNumber++}',
      trackId: request.trackId,
      status: RunStatus.running,
      startedAt: DateTime.now().toUtc(),
    );
    store.runs[run.id] = run;
    return run;
  });

  @override
  Future<void> uploadPoints(
    String runId,
    RunPointsRequestDto request, {
    String? idempotencyKey,
  }) => behavior.execute('run.uploadPoints', () {});

  @override
  Future<MilestoneCheckResponseDto> checkMilestone(
    String runId,
    MilestoneCheckRequestDto request,
  ) => behavior.execute(
    'run.milestoneCheck',
    () => const MilestoneCheckResponseDto(reached: true, expAwarded: 500),
  );

  @override
  Future<RunDto> finishRun(
    String runId,
    FinishRunRequestDto request, {
    String? idempotencyKey,
  }) => behavior.execute('run.finish', () {
    final existing = store.runs[runId] ?? _fallbackRun(runId);
    final rejected = behavior.runFinishOutcome == FakeRunOutcome.rejected;
    final result = existing.copyWith(
      status: rejected ? RunStatus.rejected : RunStatus.completed,
      finishedAt: DateTime.now().toUtc(),
      distanceMeters: 1150,
      durationSeconds: 570,
      paceSecondsPerKm: 496,
      netExp: rejected ? 0 : 1000,
      coinsEarned: rejected ? 0 : 1,
      milestoneExp: rejected ? 0 : 1500,
      expMultiplier: 1.5,
      runPenaltyExp: rejected ? 0 : 500,
      roleLeaguePoints: rejected ? 0 : 500,
      estimatedCalories: 69,
      streakDays: 6,
      reachedMilestones: 2,
      loadoutLabel: 'EXP Boost 1.5x',
      rejectionCode: rejected ? 'route_validation_failed' : null,
    );
    store.runs[runId] = result;
    if (!rejected) {
      store.coins += result.coinsEarned ?? 0;
      store.user = store.user.copyWith(
        coins: store.coins,
        exp: store.user.exp + (result.netExp ?? 0),
        streakDays: result.streakDays ?? store.user.streakDays,
      );
    }
    return result;
  });

  @override
  Future<RunDto> safeStopRun(
    String runId,
    SafeStopRequestDto request, {
    String? idempotencyKey,
  }) => behavior.execute('run.safeStop', () {
    final existing = store.runs[runId] ?? _fallbackRun(runId);
    final result = existing.copyWith(
      status: RunStatus.safeStopped,
      finishedAt: DateTime.now().toUtc(),
      netExp: 210,
      coinsEarned: 0,
      milestoneExp: 500,
      expMultiplier: 1,
      runPenaltyExp: 0,
      roleLeaguePoints: 250,
      estimatedCalories: 38,
      streakDays: 6,
      reachedMilestones: 1,
      loadoutLabel: 'EXP Boost 1.5x',
    );
    store.runs[runId] = result;
    store.user = store.user.copyWith(
      exp: store.user.exp + (result.netExp ?? 0),
      streakDays: result.streakDays ?? store.user.streakDays,
    );
    return result;
  });

  @override
  Future<void> claimRewards(
    String runId,
    String claimId, {
    required String idempotencyKey,
  }) => behavior.execute('run.claim', () {});

  @override
  Future<RunHistoryPageDto> getRunHistory({String? cursor}) =>
      behavior.execute('run.history', () {
        final entries = store.runs.values.toList()
          ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
        final start = cursor == null ? 0 : int.tryParse(cursor) ?? 0;
        final safeStart = start.clamp(0, entries.length);
        final end = (start + 5).clamp(0, entries.length);
        return RunHistoryPageDto(
          runs: entries.sublist(safeStart, end),
          nextCursor: end < entries.length ? '$end' : null,
        );
      });

  @override
  Future<RunDetailDto> getRunDetail(String runId) =>
      behavior.execute('run.detail', () {
        final run = store.runs[runId] ?? _fallbackRun(runId);
        return RunDetailDto(
          run: run,
          trace: <RunPointDto>[
            RunPointDto(
              latitude: -6.2010,
              longitude: 106.8170,
              recordedAt: DateTime.utc(2026, 10, 22, 7),
              accuracyMeters: 6,
            ),
            RunPointDto(
              latitude: -6.2014,
              longitude: 106.8176,
              recordedAt: DateTime.utc(2026, 10, 22, 7, 5),
              accuracyMeters: 5,
            ),
          ],
        );
      });

  RunDto _fallbackRun(String id) => RunDto(
    id: id,
    trackId: 'track-fog-001',
    status: RunStatus.running,
    startedAt: DateTime.now().toUtc(),
  );
}
