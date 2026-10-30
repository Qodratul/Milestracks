import 'package:milestracks/shared/models/api_models.dart';

class ActiveRunRecovery {
  const ActiveRunRecovery({
    required this.id,
    required this.trackId,
    required this.status,
    required this.startedAt,
    required this.elapsedSeconds,
    required this.distanceMeters,
    required this.lastSampleSequence,
    required this.reachedMilestoneIds,
  });

  final String id;
  final String trackId;
  final RunStatus status;
  final DateTime startedAt;
  final int elapsedSeconds;
  final double distanceMeters;
  final int lastSampleSequence;
  final List<String> reachedMilestoneIds;
}

abstract interface class RunRepository {
  Future<ActiveRunRecovery?> getActiveRun();
  Future<RunDto> startRun(StartRunRequestDto request, {String? idempotencyKey});
  Future<void> pauseRun(String runId);
  Future<void> resumeRun(String runId);
  Future<List<MilestoneDialogueDto>> getMilestoneDialogues(String runId);
  Future<void> uploadPoints(
    String runId,
    RunPointsRequestDto request, {
    String? idempotencyKey,
  });
  Future<MilestoneCheckResponseDto> checkMilestone(
    String runId,
    MilestoneCheckRequestDto request,
  );
  Future<RunDto> finishRun(
    String runId,
    FinishRunRequestDto request, {
    String? idempotencyKey,
  });
  Future<RunDto> safeStopRun(
    String runId,
    SafeStopRequestDto request, {
    String? idempotencyKey,
  });
  Future<void> claimRewards(
    String runId,
    String claimId, {
    required String idempotencyKey,
  });

  // ASSUMPTION UNCONFIRMED: GET /runs and GET /runs/:id are absent from PRD 11.3.
  Future<RunHistoryPageDto> getRunHistory({String? cursor});
  Future<RunDetailDto> getRunDetail(String runId);
}
