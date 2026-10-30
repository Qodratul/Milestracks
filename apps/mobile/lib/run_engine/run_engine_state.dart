import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:milestracks/shared/models/api_models.dart';

part 'run_engine_state.freezed.dart';

@freezed
sealed class RunEngineState with _$RunEngineState {
  const factory RunEngineState.idle() = RunIdle;
  const factory RunEngineState.generating() = RunGenerating;
  const factory RunEngineState.ready(TrackDto track) = RunReady;
  const factory RunEngineState.running({
    required RunDto run,
    required TrackDto track,
    required List<RunPointDto> points,
    required double distanceMeters,
    required int elapsedSeconds,
    required int reachedMilestones,
    MilestoneDialogueDto? milestoneEvent,
  }) = RunRunning;
  const factory RunEngineState.paused({
    required RunDto run,
    required TrackDto track,
    required List<RunPointDto> points,
    required double distanceMeters,
    required int elapsedSeconds,
    required int reachedMilestones,
    MilestoneDialogueDto? milestoneEvent,
  }) = RunPaused;
  const factory RunEngineState.finishing() = RunFinishing;
  const factory RunEngineState.completed(
    RunDto run, {
    @Default(false) bool syncPending,
  }) = RunCompleted;
  const factory RunEngineState.safeStopped(
    RunDto run, {
    @Default(false) bool syncPending,
  }) = RunSafeStopped;
  const factory RunEngineState.rejected(RunDto run) = RunRejected;
  const factory RunEngineState.failed(String messageKey) = RunFailed;
}

enum RunPhase {
  idle,
  generating,
  ready,
  running,
  paused,
  finishing,
  completed,
  safeStopped,
  rejected,
  failed,
}

abstract final class RunStateMachine {
  static bool canTransition(RunPhase from, RunPhase to) => switch (from) {
    RunPhase.idle => to == RunPhase.generating || to == RunPhase.ready,
    RunPhase.generating => to == RunPhase.ready || to == RunPhase.failed,
    RunPhase.ready =>
      to == RunPhase.running ||
          to == RunPhase.rejected ||
          to == RunPhase.failed,
    RunPhase.running =>
      to == RunPhase.paused ||
          to == RunPhase.finishing ||
          to == RunPhase.safeStopped ||
          to == RunPhase.failed,
    RunPhase.paused =>
      to == RunPhase.running ||
          to == RunPhase.safeStopped ||
          to == RunPhase.finishing ||
          to == RunPhase.failed,
    RunPhase.finishing =>
      to == RunPhase.completed ||
          to == RunPhase.rejected ||
          to == RunPhase.failed,
    RunPhase.completed ||
    RunPhase.safeStopped ||
    RunPhase.rejected ||
    RunPhase.failed => false,
  };
}
