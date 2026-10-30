import 'package:dio/dio.dart';
import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteRunRepository extends RemoteRepositoryBase
    implements RunRepository {
  const RemoteRunRepository(super.dio, {super.cache});

  @override
  Future<ActiveRunRecovery?> getActiveRun() => guard(() async {
    final response = await dio.get<Map<String, dynamic>>('/runs/active');
    final data = objectData(response.data);
    final raw = data['run'];
    if (raw == null) return null;
    final run = Map<String, dynamic>.from(raw as Map);
    return ActiveRunRecovery(
      id: _string(run['runId']),
      trackId: _string(run['routeId']),
      status: run['status'] == 'paused' ? RunStatus.paused : RunStatus.running,
      startedAt: DateTime.parse(_string(run['startedAt'])).toUtc(),
      elapsedSeconds: _int(run['elapsedSec']),
      distanceMeters: _double(run['distanceMeters']),
      lastSampleSequence: _int(run['lastSampleSequence']),
      reachedMilestoneIds: (run['reachedMilestoneIds'] as List? ?? const [])
          .whereType<String>()
          .toList(growable: false),
    );
  });

  @override
  Future<RunDto> startRun(
    StartRunRequestDto request, {
    String? idempotencyKey,
  }) => guard(() async {
    final startLocation = request.startLocation;
    final capabilities = request.clientCapabilities;
    if (startLocation == null || capabilities == null) {
      throw const FormatException(
        'Run start requires a fresh device location.',
      );
    }
    final response = await _postIdempotently(
      '/runs',
      data: <String, Object?>{
        'routeId': request.trackId,
        'boostItemCode': request.boostItemCode,
        'modifierItemCode': request.modifierItemCode,
        'units': request.units,
        'startLocation': startLocation.toJson(),
        'clientCapabilities': capabilities,
      },
      idempotencyKey: idempotencyKey,
      required: true,
    );
    return _runFromStart(objectData(response.data));
  });

  @override
  Future<void> pauseRun(String runId) => guard(() async {
    await dio.post<Map<String, dynamic>>('/runs/$runId/pause');
  });

  @override
  Future<void> resumeRun(String runId) => guard(() async {
    await dio.post<Map<String, dynamic>>('/runs/$runId/resume');
  });

  @override
  Future<List<MilestoneDialogueDto>> getMilestoneDialogues(String runId) =>
      guard(() async {
        final response = await dio.get<Map<String, dynamic>>(
          '/runs/$runId/guidance',
        );
        final data = objectData(response.data);
        return (data['dialogues'] as List? ?? const <Object>[])
            .map((item) => Map<String, dynamic>.from(item as Map))
            .map(
              (item) => MilestoneDialogueDto(
                milestoneOrder: _int(item['ordinal']),
                cheerLine: _string(item['cheerLine']),
                continuePrompt: _string(item['continuePrompt']),
                restPrompt: _string(item['restPrompt']),
              ),
            )
            .toList(growable: false);
      });

  @override
  Future<void> uploadPoints(
    String runId,
    RunPointsRequestDto request, {
    String? idempotencyKey,
  }) => guard(() async {
    final response = await retryIdempotent(
      () => dio.post<Map<String, dynamic>>(
        '/runs/$runId/locations',
        data: <String, Object?>{
          'samples': request.points.indexed
              .map(
                (entry) =>
                    _sampleJson(entry.$2, request.firstSequence + entry.$1),
              )
              .toList(growable: false),
        },
      ),
    );
    objectData(response.data);
  });

  @override
  Future<MilestoneCheckResponseDto> checkMilestone(
    String runId,
    MilestoneCheckRequestDto request,
  ) => guard(() async {
    final point = request.currentPoint;
    final response = await _postIdempotently(
      '/runs/$runId/milestones/${request.milestoneId}/reach',
      data: <String, Object?>{
        'reachedAt': point.recordedAt.toUtc().toIso8601String(),
        'location': <String, Object?>{
          'lat': point.latitude,
          'lng': point.longitude,
          'accuracyMeters': point.accuracyMeters ?? 5,
        },
        'lastSampleSequence': request.lastSampleSequence,
      },
      idempotencyKey: IdempotencyKey.create(),
    );
    final data = objectData(response.data);
    final progress = data['progress'] is Map
        ? Map<String, dynamic>.from(data['progress'] as Map)
        : const <String, dynamic>{};
    return MilestoneCheckResponseDto(
      reached: data['status'] == 'reached',
      expAwarded: _intOrNull(data['earnedExp']),
      safetyMessage: _stringOrNull(data['message']),
      nextMilestoneId: _stringOrNull(progress['nextMilestoneId']),
    );
  });

  @override
  Future<RunDto> finishRun(
    String runId,
    FinishRunRequestDto request, {
    String? idempotencyKey,
  }) => guard(() async {
    final body = <String, Object?>{
      'endedAt': (request.endedAt ?? DateTime.now().toUtc())
          .toUtc()
          .toIso8601String(),
      'lastSampleSequence': request.lastSampleSequence,
      if (request.distanceMeters != null && request.durationSeconds != null)
        'clientSummary': <String, Object?>{
          'distanceMeters': request.distanceMeters,
          'durationSec': request.durationSeconds,
        },
    };
    await _postIdempotently(
      '/runs/$runId/finish',
      data: body,
      idempotencyKey: idempotencyKey,
    );
    final (summary, routeId) = await _loadSummary(runId);
    final result = _runFromSummary(objectData(summary.data), routeId: routeId);
    await _invalidateRunRelatedCaches();
    return result;
  });

  @override
  Future<RunDto> safeStopRun(
    String runId,
    SafeStopRequestDto request, {
    String? idempotencyKey,
  }) => guard(() async {
    final reason = switch (request.reasonCode) {
      'tired' || 'unsafe' || 'injury' || 'other' => request.reasonCode!,
      _ => 'other',
    };
    await _postIdempotently(
      '/runs/$runId/safe-stop',
      data: <String, Object?>{
        'reason': reason,
        'lastSampleSequence': request.lastSampleSequence,
      },
      idempotencyKey: idempotencyKey,
    );
    final (summary, routeId) = await _loadSummary(runId);
    final result = _runFromSummary(objectData(summary.data), routeId: routeId);
    await _invalidateRunRelatedCaches();
    return result;
  });

  Future<(Response<Map<String, dynamic>>, String)> _loadSummary(
    String runId,
  ) async {
    final responses = await Future.wait(
      <Future<Response<Map<String, dynamic>>>>[
        dio.get<Map<String, dynamic>>('/runs/$runId/summary'),
        dio.get<Map<String, dynamic>>('/runs/$runId'),
      ],
    );
    final status = objectData(responses[1].data);
    return (responses[0], _string(status['routeId']));
  }

  Future<void> _invalidateRunRelatedCaches() => Future.wait(<Future<void>>[
    invalidateCache('profile'),
    invalidateCache('streak'),
    invalidateCache('badges'),
    invalidateCachePrefix('run-history:'),
    invalidateCachePrefix('shop:ledger:'),
  ]);

  @override
  Future<void> claimRewards(
    String runId,
    String claimId, {
    required String idempotencyKey,
  }) => guard(() async {
    final response = await _postIdempotently(
      '/runs/$runId/claim',
      data: <String, String>{'claimId': claimId},
      idempotencyKey: idempotencyKey,
      required: true,
    );
    objectData(response.data);
    await _invalidateRunRelatedCaches();
  });

  @override
  Future<RunHistoryPageDto> getRunHistory({String? cursor}) =>
      cachedRead<RunHistoryPageDto>(
        key: 'run-history:${cursor ?? 'first'}',
        maxAge: const Duration(minutes: 2),
        fetch: () => guard(() async {
          final response = await dio.get<Map<String, dynamic>>(
            '/runs',
            queryParameters: <String, Object?>{'cursor': ?cursor},
          );
          final rows = listData(response.data)
              .map((value) => Map<String, dynamic>.from(value as Map))
              .toList(growable: false);
          final meta = response.data?['meta'];
          final nextCursor = (meta as Map?)?['nextCursor'];
          return RunHistoryPageDto(
            runs: rows
                .map((row) => _runFromHistory(row))
                .toList(growable: false),
            nextCursor: nextCursor is String ? nextCursor : null,
          );
        }),
        encode: (value) => <String, Object?>{
          'runs': value.runs.map((run) => run.toJson()).toList(),
          'nextCursor': value.nextCursor,
        },
        decode: (value) =>
            RunHistoryPageDto.fromJson(Map<String, dynamic>.from(value as Map)),
      );

  @override
  Future<RunDetailDto> getRunDetail(String runId) => guard(() async {
    final responses = await Future.wait(
      <Future<Response<Map<String, dynamic>>>>[
        dio.get<Map<String, dynamic>>('/runs/$runId'),
        dio.get<Map<String, dynamic>>('/runs/$runId/trace'),
      ],
    );
    final record = objectData(responses[0].data);
    final active = record['status'] == 'active' || record['status'] == 'paused';
    final summary = active
        ? null
        : objectData(
            (await dio.get<Map<String, dynamic>>('/runs/$runId/summary')).data,
          );
    final trace = listData(responses[1].data)
        .map((value) => Map<String, dynamic>.from(value as Map))
        .map(
          (sample) => RunPointDto(
            latitude: _double(sample['lat']),
            longitude: _double(sample['lng']),
            recordedAt: DateTime.fromMillisecondsSinceEpoch(
              _int(sample['t']),
              isUtc: true,
            ),
            accuracyMeters: _doubleOrNull(sample['accuracyMeters']),
            speedMetersPerSecond: _doubleOrNull(sample['speedMps']),
            mocked: sample['mocked'] == true,
          ),
        )
        .toList(growable: false);
    return RunDetailDto(
      run: active
          ? _runFromActiveRecord(record)
          : _runFromSummary(summary!, routeId: _string(record['routeId'])),
      trace: trace,
    );
  });

  RunDto _runFromActiveRecord(Map<String, dynamic> data) => RunDto(
    id: _string(data['runId']),
    trackId: _string(data['routeId']),
    status: data['status'] == 'paused' ? RunStatus.paused : RunStatus.running,
    startedAt: DateTime.parse(_string(data['startedAt'])).toUtc(),
    distanceMeters: _doubleOrNull(data['distanceMeters']),
    durationSeconds: _intOrNull(data['activeSec']),
  );

  Map<String, Object?> _sampleJson(RunPointDto point, int sequence) =>
      <String, Object?>{
        'sequence': sequence,
        't': point.recordedAt.toUtc().millisecondsSinceEpoch,
        'lat': point.latitude,
        'lng': point.longitude,
        'accuracyMeters': point.accuracyMeters ?? 5,
        if (point.speedMetersPerSecond != null)
          'speedMps': point.speedMetersPerSecond,
        'mocked': point.mocked,
      };

  RunDto _runFromStart(Map<String, dynamic> data) {
    final milestones = (data['milestones'] as List? ?? const <Object>[])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .map(
          (item) => TrackMilestoneDto(
            id: _string(item['id']),
            order: _int(item['ordinal']),
            position: _location(item['location']),
            reached: item['status'] == 'reached',
            expReward: _int(item['exp']),
            distanceMeters: _doubleOrNull(item['distanceMeters']),
            radiusMeters: _doubleOrNull(item['radiusMeters']),
          ),
        )
        .toList(growable: false);
    return RunDto(
      id: _string(data['runId']),
      trackId: _string(data['routeId']),
      status: RunStatus.running,
      startedAt: DateTime.parse(_string(data['startedAt'])).toUtc(),
      milestones: milestones,
      revealMode: _revealMode(data['revealMode']),
      minimumDistanceMeters: _intOrNull(data['minimumDistanceMeters']),
    );
  }

  RunDto _runFromSummary(Map<String, dynamic> data, {required String routeId}) {
    final milestones = data['milestones'] is Map
        ? Map<String, dynamic>.from(data['milestones'] as Map)
        : const <String, dynamic>{};
    final claim = data['claim'] is Map
        ? Map<String, dynamic>.from(data['claim'] as Map)
        : const <String, dynamic>{};
    final streak = data['streakAfter'] is Map
        ? Map<String, dynamic>.from(data['streakAfter'] as Map)
        : const <String, dynamic>{};
    final itemsUsed = data['itemsUsed'] as List? ?? const <Object>[];
    final reasonCodes = data['reasonCodes'] as List? ?? const <Object>[];
    final status = switch (data['status']) {
      'safe_stopped' => RunStatus.safeStopped,
      'rejected' => RunStatus.rejected,
      'completed' => RunStatus.completed,
      _ => RunStatus.failed,
    };
    return RunDto(
      id: _string(data['runId']),
      trackId: routeId,
      trackTitle: _stringOrNull(data['trackTitle']),
      status: status,
      startedAt: DateTime.parse(_string(data['startedAt'])).toUtc(),
      finishedAt: _dateOrNull(data['endedAt']),
      distanceMeters: _doubleOrNull(data['distanceMeters']),
      durationSeconds: _intOrNull(data['durationSec']),
      paceSecondsPerKm: _doubleOrNull(data['avgPaceSecPerKm']),
      netExp: _intOrNull(data['levelExpGained']),
      coinsEarned: _intOrNull(data['coinsGained']),
      milestoneExp: _intOrNull(data['expEarnedBase']),
      expMultiplier: _doubleOrNull(data['expMultiplier']),
      runPenaltyExp: _intOrNull(data['expPenalty']),
      roleLeaguePoints: _intOrNull(data['rpGained']),
      estimatedCalories: _intOrNull(data['estimatedCalories']),
      streakDays: _intOrNull(streak['currentDays']),
      reachedMilestones: _intOrNull(milestones['reached']),
      loadoutLabel: itemsUsed.map((item) => item.toString()).join(', '),
      rejectionCode: reasonCodes.isEmpty ? null : reasonCodes.first.toString(),
      claimId: _stringOrNull(claim['claimId']),
      claimed: claim['claimed'] == true,
    );
  }

  RunDto _runFromHistory(Map<String, dynamic> data) {
    return _runFromSummary(<String, dynamic>{
      ...data,
      'claim': <String, Object?>{
        'claimId': data['claimId'],
        'claimed': data['claimed'] == true,
      },
      'milestones': <String, Object?>{'reached': data['reachedMilestones']},
      'streakAfter': data['streakDays'] == null
          ? null
          : <String, Object?>{'currentDays': data['streakDays']},
      'itemsUsed':
          data['loadoutLabel'] is String &&
              (data['loadoutLabel'] as String).isNotEmpty
          ? (data['loadoutLabel'] as String).split(', ')
          : const <String>[],
    }, routeId: _string(data['routeId']));
  }

  Future<Response<Map<String, dynamic>>> _postIdempotently(
    String path, {
    Object? data,
    String? idempotencyKey,
    bool required = false,
  }) {
    final options = _idempotencyOptions(idempotencyKey, required: required);
    return retryIdempotent(
      () => dio.post<Map<String, dynamic>>(path, data: data, options: options),
    );
  }

  Options _idempotencyOptions(String? key, {bool required = false}) {
    final header = key ?? (required ? IdempotencyKey.create() : null);
    return Options(
      headers: header == null
          ? null
          : <String, Object>{'Idempotency-Key': header},
    );
  }
}

GeoPointDto _location(Object? value) {
  final map = Map<String, dynamic>.from(value as Map);
  return GeoPointDto(
    latitude: _double(map['lat']),
    longitude: _double(map['lng']),
  );
}

RevealMode? _revealMode(Object? value) => switch (value) {
  'full' => RevealMode.full,
  'next_milestone' => RevealMode.nextMilestone,
  _ => RevealMode.blind,
};

String _string(Object? value) => value is String ? value : '';
String? _stringOrNull(Object? value) => value is String ? value : null;
int _int(Object? value) => value is num ? value.toInt() : 0;
int? _intOrNull(Object? value) => value is num ? value.toInt() : null;
double _double(Object? value) => value is num ? value.toDouble() : 0;
double? _doubleOrNull(Object? value) => value is num ? value.toDouble() : null;
DateTime? _dateOrNull(Object? value) =>
    value is String ? DateTime.tryParse(value)?.toUtc() : null;
