import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/storage/app_database.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/run_engine/gps_point_source.dart';
import 'package:milestracks/run_engine/gps_processing.dart';
import 'package:milestracks/run_engine/run_engine_state.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:turf/turf.dart' as turf;
import 'package:wakelock_plus/wakelock_plus.dart';

part 'run_engine_controller.g.dart';

@Riverpod(keepAlive: true)
class RunEngineController extends _$RunEngineController {
  final GpsFixFilter _filter = GpsFixFilter();
  final MilestoneProgressDetector _milestoneDetector =
      MilestoneProgressDetector();
  final List<RunPointDto> _acceptedPoints = <RunPointDto>[];
  StreamSubscription<RunPointDto>? _gpsSubscription;
  Timer? _ticker;
  Timer? _syncRetryTimer;
  TrackDto? _track;
  List<TrackMilestoneDto> _allMilestones = const <TrackMilestoneDto>[];
  final Set<String> _serverReachedMilestones = <String>{};
  RunDto? _run;
  RunNotificationCopy? _notificationCopy;
  int _elapsedSeconds = 0;
  int _reachedMilestones = 0;
  int _lastSampleSequence = 0;
  int _pointsSinceUpload = 0;
  bool _syncingPoints = false;
  double _distanceMeters = 0;
  Future<void> _pointProcessing = Future<void>.value();
  Future<void> _remoteRunControls = Future<void>.value();

  @override
  RunEngineState build() {
    ref.onDispose(() {
      unawaited(_gpsSubscription?.cancel());
      _ticker?.cancel();
      _syncRetryTimer?.cancel();
      unawaited(WakelockPlus.disable());
    });
    unawaited(retryPendingSync().catchError((Object _) {}));
    return const RunEngineState.idle();
  }

  void prepare(TrackDto track) {
    if (_phaseFor(state) != RunPhase.idle) {
      state = const RunEngineState.idle();
    }
    _move(const RunEngineState.generating(), RunPhase.generating);
    _track = track;
    _run = null;
    _notificationCopy = null;
    _allMilestones = track.milestones;
    _serverReachedMilestones.clear();
    _lastSampleSequence = 0;
    _filter.reset();
    _milestoneDetector.reset();
    _acceptedPoints.clear();
    _elapsedSeconds = 0;
    _reachedMilestones = 0;
    _pointsSinceUpload = 0;
    _distanceMeters = 0;
    _pointProcessing = Future<void>.value();
    _move(RunEngineState.ready(track), RunPhase.ready);
    unawaited(retryPendingSync().catchError((Object _) {}));
  }

  Future<void> restoreActiveRun({
    required TrackDto track,
    required ActiveRunRecovery activeRun,
    required RunNotificationCopy notificationCopy,
  }) async {
    final permissionGranted = await ensureBackgroundLocationPermission();
    if (!permissionGranted) {
      throw StateError('Background location permission is required.');
    }
    final detail = await ref
        .read(runRepositoryProvider)
        .getRunDetail(activeRun.id);
    final reached = activeRun.reachedMilestoneIds;
    _allMilestones = track.milestones
        .map(
          (milestone) =>
              milestone.copyWith(reached: reached.contains(milestone.id)),
        )
        .toList(growable: false);
    _serverReachedMilestones
      ..clear()
      ..addAll(reached);
    _run = detail.run.copyWith(milestones: _allMilestones);
    _track = track;
    _notificationCopy = notificationCopy;
    _acceptedPoints
      ..clear()
      ..addAll(detail.trace);
    _filter.reset();
    _milestoneDetector.reset();
    _lastSampleSequence = activeRun.lastSampleSequence;
    _pointsSinceUpload = 0;
    _distanceMeters = activeRun.distanceMeters;
    _elapsedSeconds = activeRun.elapsedSeconds;
    _reachedMilestones = reached.length;
    _pointProcessing = Future<void>.value();
    await WakelockPlus.enable();
    _moveToRunning();
    await _refreshRevealedTrack();
    _copyTrackIntoRunState();
    _listenForPoints();
    if (activeRun.status == RunStatus.paused) {
      _moveToPaused();
    } else {
      _startTicker();
    }
    _startOutboxRetry();
  }

  Future<void> start(
    TrackDto track,
    RunNotificationCopy notificationCopy,
  ) async {
    _track = track;
    _notificationCopy = notificationCopy;
    if (state is! RunReady) prepare(track);
    try {
      final permissionGranted = await ensureBackgroundLocationPermission();
      if (!permissionGranted) {
        _move(
          const RunEngineState.failed('backgroundLocationRequired'),
          RunPhase.failed,
        );
        return;
      }

      final startPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );
      final platform = defaultTargetPlatform == TargetPlatform.iOS
          ? 'ios'
          : 'android';

      final run = await ref
          .read(runRepositoryProvider)
          .startRun(
            StartRunRequestDto(
              trackId: track.id,
              boostItemCode: null,
              modifierItemCode: null,
              units: 'metric',
              startLocation: TrackStartLocationDto(
                latitude: startPosition.latitude,
                longitude: startPosition.longitude,
                accuracyMeters: math.max(1, startPosition.accuracy).toDouble(),
              ),
              clientCapabilities: <String, dynamic>{
                'platform': platform,
                'appVersion': const String.fromEnvironment(
                  'APP_VERSION',
                  defaultValue: '1.0.0',
                ),
                'backgroundLocation': true,
                'mockLocationEnabled': startPosition.isMocked,
              },
            ),
            idempotencyKey: IdempotencyKey.create(),
          );
      _allMilestones = _mergeMilestones(track.milestones, run.milestones);
      _run = run.copyWith(milestones: _allMilestones);
      _serverReachedMilestones.clear();
      _reachedMilestones = 0;
      _track = track.copyWith(milestones: _displayMilestones(track));
      if (run.status == RunStatus.rejected) {
        _move(RunEngineState.rejected(run), RunPhase.rejected);
        await WakelockPlus.disable();
        return;
      }
      await WakelockPlus.enable();
      unawaited(_hydrateRunPresentation());
      _moveToRunning();
      _listenForPoints();
      _startTicker();
      _startOutboxRetry();
    } on Object catch (error) {
      await WakelockPlus.disable();
      _move(RunEngineState.failed(_errorKey(error)), RunPhase.failed);
    }
  }

  Future<void> pause() async {
    if (state is! RunRunning) return;
    final run = _run;
    if (run != null) {
      _queueRemoteRunControl(
        () => ref.read(runRepositoryProvider).pauseRun(run.id),
      );
    }
    _ticker?.cancel();
    _moveToPaused();
    // Keep the location stream alive so Android retains its foreground
    // notification. Point processing ignores fixes while the run is paused.
    // Wakelock stays enabled so the runner can use the safety controls.
  }

  Future<void> resume() async {
    if (state is! RunPaused) return;
    final run = _run;
    if (run != null) {
      _queueRemoteRunControl(
        () => ref.read(runRepositoryProvider).resumeRun(run.id),
      );
    }
    _moveToRunning();
    if (_gpsSubscription == null) _listenForPoints();
    _startTicker();
  }

  Future<void> continueAfterMilestone() async {
    _clearMilestoneEvent();
  }

  Future<void> restAfterMilestone() async {
    _clearMilestoneEvent();
    await pause();
  }

  Future<void> finish() async {
    if (state is! RunRunning && state is! RunPaused) return;
    final run = _run;
    if (run == null) return;
    _ticker?.cancel();
    await _gpsSubscription?.cancel();
    _gpsSubscription = null;
    await _pointProcessing;
    _move(const RunEngineState.finishing(), RunPhase.finishing);
    final database = await ref.read(appDatabaseProvider.future);
    try {
      await _syncPointBatches(database, run.id);
    } on Object {
      // Finish still proceeds with the locally buffered trace when offline.
    }
    final request = FinishRunRequestDto(
      endedAt: DateTime.now().toUtc(),
      lastSampleSequence: _lastSampleSequence,
      distanceMeters: _distanceMeters,
      durationSeconds: _elapsedSeconds,
    );
    final idempotencyKey = IdempotencyKey.create();
    final localResult = _localTerminalRun(run, RunStatus.completed);
    await database.enqueueRunAction(
      runId: run.id,
      action: 'finish',
      idempotencyKey: idempotencyKey,
      payload: <String, Object?>{'request': request.toJson()},
    );
    try {
      final result = await ref
          .read(runRepositoryProvider)
          .finishRun(run.id, request, idempotencyKey: idempotencyKey);
      _run = result;
      await _removeOutbox(database, run.id, idempotencyKey);
      await _releaseRunResources();
      _syncRetryTimer?.cancel();
      _syncRetryTimer = null;
      if (result.status == RunStatus.rejected) {
        _move(RunEngineState.rejected(result), RunPhase.rejected);
      } else if (result.status == RunStatus.failed) {
        _move(const RunEngineState.failed('runFailed'), RunPhase.failed);
      } else {
        _move(RunEngineState.completed(result), RunPhase.completed);
      }
    } on Object {
      await _releaseRunResources();
      _startOutboxRetry();
      _move(
        RunEngineState.completed(localResult, syncPending: true),
        RunPhase.completed,
      );
    }
  }

  Future<void> safeStop({String? reasonCode}) async {
    if (state is! RunRunning && state is! RunPaused) return;
    final run = _run;
    if (run == null) return;
    _ticker?.cancel();
    await _gpsSubscription?.cancel();
    _gpsSubscription = null;
    await _pointProcessing;
    _move(const RunEngineState.finishing(), RunPhase.finishing);
    final database = await ref.read(appDatabaseProvider.future);
    try {
      await _syncPointBatches(database, run.id);
    } on Object {
      // Safe Stop must still complete when the network is unavailable.
    }
    final request = SafeStopRequestDto(
      reasonCode: reasonCode,
      lastSampleSequence: _lastSampleSequence,
    );
    final idempotencyKey = IdempotencyKey.create();
    final localResult = _localTerminalRun(run, RunStatus.safeStopped);
    await database.enqueueRunAction(
      runId: run.id,
      action: 'safe_stop',
      idempotencyKey: idempotencyKey,
      payload: <String, Object?>{'request': request.toJson()},
    );
    try {
      final result = await ref
          .read(runRepositoryProvider)
          .safeStopRun(run.id, request, idempotencyKey: idempotencyKey);
      _run = result;
      await _removeOutbox(database, run.id, idempotencyKey);
      await _releaseRunResources();
      _syncRetryTimer?.cancel();
      _syncRetryTimer = null;
      if (result.status == RunStatus.rejected) {
        _move(RunEngineState.rejected(result), RunPhase.rejected);
      } else if (result.status == RunStatus.failed) {
        _move(const RunEngineState.failed('runFailed'), RunPhase.failed);
      } else {
        _move(RunEngineState.safeStopped(result), RunPhase.safeStopped);
      }
    } on Object {
      await _releaseRunResources();
      _startOutboxRetry();
      _move(
        RunEngineState.safeStopped(localResult, syncPending: true),
        RunPhase.safeStopped,
      );
    }
  }

  Future<void> retryPendingSync() async {
    final database = await ref.read(appDatabaseProvider.future);
    final run = _run;
    if (run != null) {
      try {
        await _syncPointBatches(database, run.id);
      } on Object {
        return;
      }
    } else {
      try {
        for (final runId in await database.pendingRunIds()) {
          await _syncPointBatches(database, runId);
        }
      } on Object {
        return;
      }
    }
    try {
      await _syncPendingActions(database);
    } on Object {
      return;
    }
    if ((await database.getPendingRunActions()).isEmpty) {
      _syncRetryTimer?.cancel();
      _syncRetryTimer = null;
    }
  }

  Future<bool> claimResultRewards() async {
    var result = switch (state) {
      RunCompleted(:final run) => run,
      RunSafeStopped(:final run) => run,
      RunRejected(:final run) => run,
      _ => null,
    };
    final pending = switch (state) {
      RunCompleted(:final syncPending) ||
      RunSafeStopped(:final syncPending) => syncPending,
      _ => false,
    };
    if (result == null) return false;
    if (pending) {
      await retryPendingSync();
      result = switch (state) {
        RunCompleted(:final run) => run,
        RunSafeStopped(:final run) => run,
        RunRejected(:final run) => run,
        _ => null,
      };
      final stillPending = switch (state) {
        RunCompleted(:final syncPending) ||
        RunSafeStopped(:final syncPending) => syncPending,
        _ => false,
      };
      if (stillPending) return false;
    }
    if (result == null) return false;
    if (result.status == RunStatus.rejected ||
        result.claimed ||
        result.claimId == null) {
      return true;
    }
    final database = await ref.read(appDatabaseProvider.future);
    final queued = (await database.getPendingRunActions())
        .where(
          (action) => action.runId == result!.id && action.action == 'claim',
        )
        .firstOrNull;
    final key = queued?.idempotencyKey ?? IdempotencyKey.create();
    final actionId = queued?.id;
    if (queued == null) {
      await database.enqueueRunAction(
        runId: result.id,
        action: 'claim',
        idempotencyKey: key,
        payload: <String, Object?>{'claimId': result.claimId},
      );
    }
    try {
      await ref
          .read(runRepositoryProvider)
          .claimRewards(result.id, result.claimId!, idempotencyKey: key);
      if (actionId != null) {
        await database.removePendingRunAction(actionId);
      } else {
        await _removeOutbox(database, result.id, key);
      }
      _markCurrentRunClaimed(result.id);
      return true;
    } on Object {
      _startOutboxRetry();
      return false;
    }
  }

  void restoreRecoveredResult(RunDto run) {
    _run = run;
    _track = null;
    state = switch (run.status) {
      RunStatus.safeStopped => RunEngineState.safeStopped(run),
      RunStatus.rejected => RunEngineState.rejected(run),
      _ => RunEngineState.completed(run),
    };
  }

  Future<void> _hydrateRunPresentation() async {
    final run = _run;
    final track = _track;
    if (run == null || track == null) return;
    try {
      final dialogues = await ref
          .read(runRepositoryProvider)
          .getMilestoneDialogues(run.id);
      final currentTrack = _track ?? track;
      _track = currentTrack.copyWith(
        narrative: currentTrack.narrative.copyWith(
          milestoneDialogues: dialogues,
        ),
      );
    } on Object {
      // The route remains runnable if optional guidance is temporarily offline.
    }
    await _refreshRevealedTrack();
    _copyTrackIntoRunState();
  }

  void _queueRemoteRunControl(Future<void> Function() action) {
    _remoteRunControls = _remoteRunControls
        .catchError((Object _) {})
        .then((_) => action())
        .catchError((Object _) {});
  }

  Future<void> _refreshRevealedTrack() async {
    final track = _track;
    final run = _run;
    if (track == null || run == null) return;
    final mode = run.revealMode ?? track.revealMode;
    var revealed = track.revealedPolyline;
    if (mode == RevealMode.blind) {
      revealed = const <GeoPointDto>[];
    } else if (mode == RevealMode.nextMilestone) {
      final target = _allMilestones
          .where(
            (milestone) => !_serverReachedMilestones.contains(milestone.id),
          )
          .firstOrNull;
      final distance = target?.distanceMeters;
      if (distance != null) {
        try {
          revealed = await ref
              .read(trackRepositoryProvider)
              .getRevealedGeometry(
                run.trackId,
                throughDistanceMeters: distance,
              );
        } on Object {
          // Retain only the last route prefix the server confirmed as visible.
        }
      }
    }
    _track = track.copyWith(
      revealedPolyline: revealed,
      milestones: _displayMilestones(track),
    );
  }

  List<TrackMilestoneDto> _displayMilestones(TrackDto track) {
    final mode = _run?.revealMode ?? track.revealMode;
    final visible = switch (mode) {
      RevealMode.blind => const <TrackMilestoneDto>[],
      RevealMode.nextMilestone =>
        _allMilestones
            .take((_reachedMilestones + 1).clamp(0, _allMilestones.length))
            .toList(growable: false),
      _ => _allMilestones,
    };
    return visible
        .map(
          (milestone) => milestone.copyWith(
            reached: _serverReachedMilestones.contains(milestone.id),
          ),
        )
        .toList(growable: false);
  }

  List<TrackMilestoneDto> _mergeMilestones(
    List<TrackMilestoneDto> trackMilestones,
    List<TrackMilestoneDto> runMilestones,
  ) {
    if (trackMilestones.isEmpty) {
      return List<TrackMilestoneDto>.unmodifiable(runMilestones);
    }
    final merged = trackMilestones
        .map((trackMilestone) {
          final runMilestone = runMilestones
              .where(
                (milestone) =>
                    milestone.id == trackMilestone.id ||
                    milestone.order == trackMilestone.order,
              )
              .firstOrNull;
          if (runMilestone == null) return trackMilestone;
          return trackMilestone.copyWith(
            position: trackMilestone.position ?? runMilestone.position,
            reached: runMilestone.reached || trackMilestone.reached,
            expReward: runMilestone.expReward,
            distanceMeters:
                trackMilestone.distanceMeters ?? runMilestone.distanceMeters,
            radiusMeters:
                runMilestone.radiusMeters ?? trackMilestone.radiusMeters,
          );
        })
        .toList(growable: true);
    for (final runMilestone in runMilestones) {
      if (!merged.any((milestone) => milestone.id == runMilestone.id)) {
        merged.add(runMilestone);
      }
    }
    merged.sort((first, second) => first.order.compareTo(second.order));
    return List<TrackMilestoneDto>.unmodifiable(merged);
  }

  List<TrackMilestoneDto> _milestonesForDetection() {
    return _allMilestones
        .where((item) => !_serverReachedMilestones.contains(item.id))
        .take(1)
        .toList(growable: false);
  }

  void _copyTrackIntoRunState() {
    final track = _track;
    if (track == null) return;
    switch (state) {
      case final RunRunning running:
        state = running.copyWith(track: track);
      case final RunPaused paused:
        state = paused.copyWith(track: track);
      default:
        break;
    }
  }

  void _applySyncedTerminalRun(RunDto run, String action) {
    if (_run?.id != run.id) return;
    _run = run;
    if (run.status == RunStatus.rejected) {
      state = RunEngineState.rejected(run);
    } else if (run.status == RunStatus.failed) {
      state = const RunEngineState.failed('runFailed');
    } else if (action == 'safe_stop') {
      state = RunEngineState.safeStopped(run, syncPending: false);
    } else {
      state = RunEngineState.completed(run, syncPending: false);
    }
  }

  void _markCurrentRunClaimed(String runId) {
    final run = _run;
    if (run == null || run.id != runId) return;
    _run = run.copyWith(claimed: true);
    switch (state) {
      case final RunCompleted completed:
        state = completed.copyWith(run: _run!);
      case final RunSafeStopped stopped:
        state = stopped.copyWith(run: _run!);
      default:
        break;
    }
  }

  void _listenForPoints() {
    final copy = _notificationCopy;
    if (copy == null) return;
    _gpsSubscription = ref
        .read(gpsPointSourceProvider)
        .points(copy)
        .listen(
          _queuePoint,
          onError: (Object error, StackTrace stackTrace) {
            if (state is RunRunning) {
              _move(RunEngineState.failed(_errorKey(error)), RunPhase.failed);
              unawaited(_releaseRunResources());
            }
          },
        );
  }

  void _queuePoint(RunPointDto point) {
    _pointProcessing = _pointProcessing
        .then((_) => _handleIncomingPoint(point))
        .catchError((Object error) {
          if (state is RunRunning) {
            _move(RunEngineState.failed(_errorKey(error)), RunPhase.failed);
            unawaited(_releaseRunResources());
          }
        });
  }

  Future<void> _handleIncomingPoint(RunPointDto raw) async {
    final run = _run;
    final track = _track;
    if (run == null || track == null || state is! RunRunning) return;
    final point = _filter.add(raw);
    if (point == null) return;
    if (_acceptedPoints.isNotEmpty) {
      _distanceMeters += _distance(_acceptedPoints.last, point);
    }
    _acceptedPoints.add(point);
    final database = await ref.read(appDatabaseProvider.future);
    await database.appendRunPoints(run.id, <RunPointDto>[point]);
    _lastSampleSequence++;
    _pointsSinceUpload++;
    // Publish live stats and location before the milestone network round trip.
    _moveToRunning();

    final candidate = _milestoneDetector.update(
      point: point,
      revealedPolyline: track.revealedPolyline,
      milestones: _milestonesForDetection(),
    );
    if (candidate != null) {
      await _checkMilestone(run.id, track, candidate, point);
    }
    _moveToRunning();
    if (_pointsSinceUpload >= 20) {
      await _syncPointBatches(database, run.id);
    }
  }

  Future<void> _checkMilestone(
    String runId,
    TrackDto track,
    TrackMilestoneDto milestone,
    RunPointDto point,
  ) async {
    try {
      final database = await ref.read(appDatabaseProvider.future);
      await _syncPointBatches(database, runId);
      final response = await ref
          .read(runRepositoryProvider)
          .checkMilestone(
            runId,
            MilestoneCheckRequestDto(
              milestoneId: milestone.id,
              currentPoint: point,
              lastSampleSequence: _lastSampleSequence,
            ),
          );
      if (!response.reached) {
        _milestoneDetector.unmark(milestone.id);
        return;
      }
      _serverReachedMilestones.add(milestone.id);
      _reachedMilestones++;
      await _refreshRevealedTrack();
      final dialogue = track.narrative.milestoneDialogues
          .where((item) => item.milestoneOrder == milestone.order)
          .firstOrNull;
      _moveToRunning(milestoneEvent: dialogue);
    } on Object {
      _milestoneDetector.unmark(milestone.id);
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state is! RunRunning) return;
      _elapsedSeconds++;
      _moveToRunning();
    });
  }

  void _startOutboxRetry() {
    _syncRetryTimer?.cancel();
    _syncRetryTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => unawaited(retryPendingSync()),
    );
  }

  void _moveToRunning({MilestoneDialogueDto? milestoneEvent}) {
    final run = _run;
    final track = _track;
    if (run == null || track == null) return;
    final previousEvent = switch (state) {
      RunRunning(:final milestoneEvent) => milestoneEvent,
      RunPaused(:final milestoneEvent) => milestoneEvent,
      _ => null,
    };
    final next = RunEngineState.running(
      run: run,
      track: track,
      points: List<RunPointDto>.unmodifiable(_acceptedPoints),
      distanceMeters: _distanceMeters,
      elapsedSeconds: _elapsedSeconds,
      reachedMilestones: _reachedMilestones,
      milestoneEvent: milestoneEvent ?? previousEvent,
    );
    if (state is RunReady || state is RunPaused) {
      _move(next, RunPhase.running);
    } else {
      state = next;
    }
  }

  void _moveToPaused() {
    final run = _run;
    final track = _track;
    if (run == null || track == null) return;
    final milestoneEvent = switch (state) {
      RunRunning(:final milestoneEvent) => milestoneEvent,
      _ => null,
    };
    _move(
      RunEngineState.paused(
        run: run,
        track: track,
        points: List<RunPointDto>.unmodifiable(_acceptedPoints),
        distanceMeters: _distanceMeters,
        elapsedSeconds: _elapsedSeconds,
        reachedMilestones: _reachedMilestones,
        milestoneEvent: milestoneEvent,
      ),
      RunPhase.paused,
    );
  }

  void _clearMilestoneEvent() {
    switch (state) {
      case final RunRunning running:
        state = running.copyWith(milestoneEvent: null);
        break;
      case final RunPaused paused:
        state = paused.copyWith(milestoneEvent: null);
        break;
      default:
        break;
    }
  }

  Future<void> _syncPointBatches(AppDatabase database, String runId) async {
    if (_syncingPoints) return;
    _syncingPoints = true;
    try {
      while (true) {
        final key = IdempotencyKey.create();
        final batch = await database.claimNextRunPointBatch(
          runId,
          idempotencyKey: key,
        );
        if (batch.isEmpty) break;
        final batchKey = batch.first.uploadBatchKey ?? key;
        await ref
            .read(runRepositoryProvider)
            .uploadPoints(
              runId,
              RunPointsRequestDto(
                points: batch.map(_toDto).toList(),
                firstSequence: batch.first.sequence,
              ),
              idempotencyKey: batchKey,
            );
        await database.markRunPointBatchSynced(
          batch.map((item) => item.id).toList(),
        );
        _pointsSinceUpload = 0;
      }
    } finally {
      _syncingPoints = false;
    }
  }

  Future<void> _syncPendingActions(AppDatabase database) async {
    for (final action in await database.getPendingRunActions()) {
      final payload = jsonDecode(action.payloadJson) as Map<String, dynamic>;
      switch (action.action) {
        case 'safe_stop':
          final result = await ref
              .read(runRepositoryProvider)
              .safeStopRun(
                action.runId,
                SafeStopRequestDto.fromJson(
                  Map<String, dynamic>.from(payload['request'] as Map),
                ),
                idempotencyKey: action.idempotencyKey,
              );
          _applySyncedTerminalRun(result, action.action);
        case 'finish':
          final result = await ref
              .read(runRepositoryProvider)
              .finishRun(
                action.runId,
                FinishRunRequestDto.fromJson(
                  Map<String, dynamic>.from(payload['request'] as Map),
                ),
                idempotencyKey: action.idempotencyKey,
              );
          _applySyncedTerminalRun(result, action.action);
        case 'claim':
          final claimId = payload['claimId'] as String?;
          if (claimId == null) continue;
          await ref
              .read(runRepositoryProvider)
              .claimRewards(
                action.runId,
                claimId,
                idempotencyKey: action.idempotencyKey,
              );
          _markCurrentRunClaimed(action.runId);
        default:
          continue;
      }
      await database.removePendingRunAction(action.id);
    }
  }

  Future<void> _removeOutbox(
    AppDatabase database,
    String runId,
    String key,
  ) async {
    final actions = await database.getPendingRunActions();
    for (final action in actions.where(
      (item) => item.runId == runId && item.idempotencyKey == key,
    )) {
      await database.removePendingRunAction(action.id);
    }
  }

  RunDto _localTerminalRun(RunDto run, RunStatus status) => run.copyWith(
    status: status,
    finishedAt: DateTime.now().toUtc(),
    distanceMeters: _distanceMeters,
    durationSeconds: _elapsedSeconds,
  );

  Future<void> _releaseRunResources() async {
    await _gpsSubscription?.cancel();
    _gpsSubscription = null;
    _ticker?.cancel();
    await WakelockPlus.disable();
  }

  RunPointDto _toDto(PendingRunPoint point) => RunPointDto(
    latitude: point.latitude,
    longitude: point.longitude,
    recordedAt: point.recordedAt,
    accuracyMeters: point.accuracyMeters,
    speedMetersPerSecond: point.speedMetersPerSecond,
    mocked: point.mocked,
  );

  void _move(RunEngineState next, RunPhase target) {
    final source = _phaseFor(state);
    if (RunStateMachine.canTransition(source, target)) state = next;
  }

  RunDto? get currentRun => _run;
  TrackDto? get trackForResult => _track;
}

RunPhase _phaseFor(RunEngineState state) => switch (state) {
  RunIdle() => RunPhase.idle,
  RunGenerating() => RunPhase.generating,
  RunReady() => RunPhase.ready,
  RunRunning() => RunPhase.running,
  RunPaused() => RunPhase.paused,
  RunFinishing() => RunPhase.finishing,
  RunCompleted() => RunPhase.completed,
  RunSafeStopped() => RunPhase.safeStopped,
  RunRejected() => RunPhase.rejected,
  RunFailed() => RunPhase.failed,
};

double _distance(RunPointDto first, RunPointDto second) => turf
    .distance(
      turf.Point(coordinates: turf.Position(first.longitude, first.latitude)),
      turf.Point(coordinates: turf.Position(second.longitude, second.latitude)),
      turf.Unit.meters,
    )
    .toDouble();

String _errorKey(Object error) =>
    error is AppException ? error.message : 'unknownError';
