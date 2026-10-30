import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/features/run/data/remote_run_repository.dart';
import 'package:milestracks/features/track/data/remote_track_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

void main() {
  test(
    'route generation follows the real route API envelope and polyline',
    () async {
      final adapter = _ApiFixtureInterceptor(_routeResponses);
      final repository = RemoteTrackRepository(_dio(adapter));

      final track = await repository.createTrack(
        const CreateTrackRequestDto(
          location: TrackStartLocationDto(
            latitude: -6.2185,
            longitude: 106.8021,
            accuracyMeters: 12,
          ),
        ),
      );

      final create = adapter.requests.first;
      expect(create.path, '/routes/mystery/generate');
      expect(create.data, <String, dynamic>{
        'location': <String, dynamic>{
          'lat': -6.2185,
          'lng': 106.8021,
          'accuracyMeters': 12,
        },
      });
      expect(
        create.headers['Idempotency-Key'],
        matches(RegExp(r'^[0-9a-f-]{36}$')),
      );
      expect(track.id, 'route_456');
      expect(track.distanceMeters, 1500);
      expect(track.revealMode, RevealMode.full);
      expect(track.revealedPolyline, hasLength(3));
      expect(track.milestones.single.position, isNull);
    },
  );

  test('generating route is polled until the server marks it ready', () async {
    final adapter = _ApiFixtureInterceptor((request) {
      if (request.path.endsWith('/generate')) {
        return _envelope(<String, Object?>{
          'routeId': 'route_456',
          'status': 'generating',
          'pollAfterMs': 500,
        });
      }
      if (request.path.endsWith('/today')) {
        return _envelope(<String, Object?>{
          'routeId': 'route_456',
          'status': 'ready',
        });
      }
      return _routeResponses(request);
    });
    final repository = RemoteTrackRepository(_dio(adapter));

    final track = await repository.createTrack(
      const CreateTrackRequestDto(
        location: TrackStartLocationDto(
          latitude: -6.2185,
          longitude: 106.8021,
          accuracyMeters: 12,
        ),
      ),
    );

    expect(track.status, TrackStatus.ready);
    expect(
      adapter.requests.any((request) => request.path.endsWith('/today')),
      isTrue,
    );
  });

  test(
    'next-milestone geometry only returns the visible route prefix',
    () async {
      final adapter = _ApiFixtureInterceptor(
        (request) => <String, Object?>{
          'data': <String, Object?>{
            'routeId': 'route_456',
            'revealed': true,
            'encoding': 'polyline',
            'precision': 5,
            'segments': <Object?>[
              <String, Object?>{
                'ordinal': 0,
                'coordinates': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
              },
            ],
          },
          'meta': <String, Object?>{
            'requestId': 'req_test',
            'timestamp': '2026-10-25T09:30:00Z',
            'nextCursor': null,
            'limit': 500,
          },
        },
      );
      final repository = RemoteTrackRepository(_dio(adapter));

      final visible = await repository.getRevealedGeometry(
        'route_456',
        throughDistanceMeters: 1000,
      );

      expect(visible, hasLength(2));
      expect(visible.first.latitude, 38.5);
      expect(visible.first.longitude, -120.2);
    },
  );

  test(
    'run requests use location samples and summary/claim endpoints',
    () async {
      final adapter = _ApiFixtureInterceptor(_runResponses);
      final repository = RemoteRunRepository(_dio(adapter));
      final run = await repository.startRun(
        const StartRunRequestDto(
          trackId: 'route_456',
          boostItemCode: null,
          modifierItemCode: 'less_compensation',
          startLocation: TrackStartLocationDto(
            latitude: -6.2185,
            longitude: 106.8021,
            accuracyMeters: 8,
          ),
          clientCapabilities: <String, dynamic>{
            'platform': 'android',
            'appVersion': '1.0.0',
            'backgroundLocation': true,
            'mockLocationEnabled': false,
          },
        ),
        idempotencyKey: '9fc8f478-5b3d-4ed3-b537-2b28ac8055c5',
      );
      expect(run.id, 'run_123');
      expect(run.milestones, hasLength(3));
      final start = adapter.requests.first;
      final startBody = _requestData(start);
      expect(start.path, '/runs');
      expect(startBody['routeId'], 'route_456');
      expect(_requestDataValue(startBody, 'startLocation')['lat'], -6.2185);
      expect(
        start.headers['Idempotency-Key'],
        '9fc8f478-5b3d-4ed3-b537-2b28ac8055c5',
      );

      await repository.uploadPoints(
        run.id,
        RunPointsRequestDto(
          firstSequence: 17,
          points: <RunPointDto>[
            RunPointDto(
              latitude: -6.2184,
              longitude: 106.8022,
              recordedAt: DateTime.utc(2026, 10, 25, 9, 31),
              accuracyMeters: 6,
              speedMetersPerSecond: 2.7,
              mocked: true,
            ),
          ],
        ),
      );
      final locationsRequest = adapter.requests.last;
      final locationSamples = _requestData(locationsRequest)['samples'] as List;
      final locations = Map<String, dynamic>.from(
        locationSamples.single as Map,
      );
      expect(locationsRequest.path, '/runs/run_123/locations');
      expect(locations['sequence'], 17);
      expect(
        locations['t'],
        DateTime.utc(2026, 10, 25, 9, 31).millisecondsSinceEpoch,
      );
      expect(locations['lat'], -6.2184);
      expect(locations['mocked'], isTrue);

      final reached = await repository.checkMilestone(
        run.id,
        MilestoneCheckRequestDto(
          milestoneId: 'ms_1',
          currentPoint: RunPointDto(
            latitude: -6.2171,
            longitude: 106.8034,
            recordedAt: DateTime.utc(2026, 10, 25, 9, 34, 5),
            accuracyMeters: 7,
          ),
          lastSampleSequence: 245,
        ),
      );
      expect(reached.reached, isTrue);
      expect(reached.nextMilestoneId, 'ms_2');
      final milestone = adapter.requests.last;
      final milestoneBody = _requestData(milestone);
      expect(milestone.path, '/runs/run_123/milestones/ms_1/reach');
      expect(milestoneBody['lastSampleSequence'], 245);
      expect(_requestDataValue(milestoneBody, 'location')['lng'], 106.8034);

      final completed = await repository.finishRun(
        run.id,
        FinishRunRequestDto(
          endedAt: DateTime.utc(2026, 10, 25, 9, 39, 30),
          lastSampleSequence: 642,
          distanceMeters: 1162,
          durationSeconds: 570,
        ),
        idempotencyKey: '56598ea1-4f33-4f6a-90a9-f67b851885f0',
      );
      expect(completed.status, RunStatus.completed);
      expect(completed.netExp, 675);
      expect(completed.coinsEarned, 1);
      final finish = adapter.requests.firstWhere(
        (request) => request.path.endsWith('/finish'),
      );
      final finishBody = _requestData(finish);
      expect(finishBody['lastSampleSequence'], 642);
      expect(
        _requestDataValue(finishBody, 'clientSummary')['durationSec'],
        570,
      );
      expect(
        adapter.requests.any((request) => request.path.endsWith('/summary')),
        isTrue,
      );

      await repository.claimRewards(
        run.id,
        'claim_123',
        idempotencyKey: '9d0de8c9-7a89-42af-94d0-eec9a78e8c0b',
      );
      final claim = adapter.requests.last;
      expect(claim.path, '/runs/run_123/claim');
      expect(claim.data, <String, String>{'claimId': 'claim_123'});
      expect(
        claim.headers['Idempotency-Key'],
        '9d0de8c9-7a89-42af-94d0-eec9a78e8c0b',
      );
    },
  );
}

Dio _dio(_ApiFixtureInterceptor interceptor) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test/api/v1'));
  dio.interceptors.add(interceptor);
  return dio;
}

Map<String, dynamic> _requestData(RequestOptions request) =>
    Map<String, dynamic>.from(request.data as Map);

Map<String, dynamic> _requestDataValue(Map<String, dynamic> data, String key) =>
    Map<String, dynamic>.from(data[key] as Map);

class _ApiFixtureInterceptor extends Interceptor {
  _ApiFixtureInterceptor(this.fixtures);

  final Map<String, Object?> Function(RequestOptions request) fixtures;
  final requests = <RequestOptions>[];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    requests.add(options);
    final data = fixtures(options);
    handler.resolve(
      Response<Object?>(
        requestOptions: options,
        data: data,
        statusCode: options.path == '/runs' ? 201 : 200,
      ),
    );
  }
}

Map<String, Object?> _envelope(Object? data, {Object? nextCursor}) {
  final meta = <String, Object?>{
    'requestId': 'req_test',
    'timestamp': '2026-10-25T09:30:00Z',
  };
  if (nextCursor != null) {
    meta.addAll(<String, Object?>{'nextCursor': nextCursor, 'limit': 500});
  }
  return <String, Object?>{'data': data, 'meta': meta};
}

Map<String, Object?> _routeResponses(RequestOptions request) {
  if (request.path.endsWith('/generate')) {
    return _envelope(<String, Object?>{
      'routeId': 'route_456',
      'status': 'ready',
      'level': 'beginner',
      'title': 'Morning route',
      'mysteryBrief': 'Follow the old trees.',
      'distanceMeters': 1500,
      'estimatedDurationSec': 780,
      'estimatedCalories': 90,
      'milestoneCount': 1,
      'expPerMilestone': 500,
      'startPoint': <String, Object?>{
        'label': 'Nearby mapped start',
        'distanceMeters': 120,
        'location': <String, double>{'lat': -6.2183, 'lng': 106.8019},
      },
      'safetyScore': .86,
      'dataConfidence': .9,
      'warning': null,
      'preRunTip': 'Warm up.',
      'revealMode': 'full',
    });
  }
  if (request.path.endsWith('/preview')) {
    return _envelope(<String, Object?>{
      'routeId': 'route_456',
      'status': 'ready',
      'title': 'Morning route',
      'mysteryBrief': 'Follow the old trees.',
      'distanceMeters': 1500,
      'estimatedDurationSec': 780,
      'estimatedCalories': 90,
      'milestoneCount': 1,
      'expPerMilestone': 500,
      'milestones': <Object?>[
        <String, Object?>{
          'id': 'ms_1',
          'ordinal': 1,
          'distanceMeters': 1500,
          'exp': 500,
        },
      ],
      'startPoint': <String, Object?>{
        'label': 'Nearby mapped start',
        'distanceMeters': 120,
        'location': <String, double>{'lat': -6.2183, 'lng': 106.8019},
      },
      'safetyScore': .86,
      'dataConfidence': .9,
      'warning': null,
      'preRunTip': 'Warm up.',
      'revealMode': 'full',
    });
  }
  if (request.path.endsWith('/geometry')) {
    return _envelope(<String, Object?>{
      'routeId': 'route_456',
      'revealed': true,
      'encoding': 'polyline',
      'precision': 5,
      'coordinates': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
      'bounds': <String, num>{
        'north': 43,
        'south': 38,
        'east': -120,
        'west': -126,
      },
    });
  }
  throw StateError('Unexpected route request ${request.path}');
}

Map<String, Object?> _runResponses(RequestOptions request) {
  if (request.path == '/runs') {
    return _envelope(<String, Object?>{
      'runId': 'run_123',
      'routeId': 'route_456',
      'status': 'active',
      'startedAt': '2026-10-25T09:30:00Z',
      'minimumDistanceMeters': 250,
      'revealMode': 'full',
      'loadout': <String, Object?>{
        'boostItemCode': null,
        'modifierItemCode': 'less_compensation',
      },
      'quota': <String, Object?>{'safeStopsRemaining': 2},
      'penaltyFreeRun': false,
      'milestones': <Object?>[
        for (var index = 1; index <= 3; index++)
          <String, Object?>{
            'id': 'ms_$index',
            'ordinal': index,
            'status': 'pending',
            'distanceMeters': index * 500,
            'exp': 500,
            'location': <String, double>{
              'lat': -6.21,
              'lng': 106.8 + index / 10000,
            },
            'radiusMeters': 25,
          },
      ],
    });
  }
  if (request.path.endsWith('/locations')) {
    return _envelope(<String, Object?>{
      'acceptedCount': 1,
      'duplicateCount': 0,
      'lastSequence': 17,
      'gpsQuality': 'strong',
      'distanceMeters': 12,
    });
  }
  if (request.path.endsWith('/reach')) {
    return _envelope(<String, Object?>{
      'milestoneId': 'ms_1',
      'status': 'reached',
      'verification': 'provisional',
      'reachedAt': '2026-10-25T09:34:05Z',
      'earnedExp': 500,
      'protected': true,
      'progress': <String, Object?>{
        'reached': 1,
        'total': 3,
        'nextMilestoneId': 'ms_2',
      },
      'expRemaining': null,
    });
  }
  if (request.path.endsWith('/finish')) {
    return _envelope(<String, Object?>{
      'runId': 'run_123',
      'status': 'completed',
      'integrity': 'clean',
      'reasonCodes': <String>[],
      'claimId': 'claim_123',
      'rewardPreview': <String, int>{'coins': 1, 'rp': 500, 'exp': 675},
      'claimed': false,
    });
  }
  if (request.path.endsWith('/summary')) {
    return _envelope(<String, Object?>{
      'runId': 'run_123',
      'status': 'completed',
      'integrity': 'clean',
      'reasonCodes': <String>[],
      'startedAt': '2026-10-25T09:30:00Z',
      'endedAt': '2026-10-25T09:39:30Z',
      'distanceMeters': 1150,
      'durationSec': 570,
      'avgPaceSecPerKm': 496,
      'estimatedCalories': 69,
      'milestones': <String, Object?>{
        'reached': 2,
        'total': 3,
        'items': <Object?>[],
      },
      'expEarnedBase': 1000,
      'expMultiplier': 1,
      'expPenalty': 325,
      'levelExpGained': 675,
      'coinsGained': 1,
      'rpGained': 500,
      'streakAfter': null,
      'itemsUsed': <String>['less_compensation'],
      'claim': <String, Object?>{'claimId': 'claim_123', 'claimed': false},
    });
  }
  if (request.path == '/runs/run_123') {
    return _envelope(<String, Object?>{
      'runId': 'run_123',
      'routeId': 'route_456',
      'status': 'completed',
      'startedAt': '2026-10-25T09:30:00Z',
      'elapsedSec': 570,
      'activeSec': 570,
      'distanceMeters': 1150,
      'gpsQuality': 'strong',
      'milestones': <String, Object?>{
        'reached': 2,
        'total': 3,
        'nextMilestoneId': null,
      },
      'lastSampleSequence': 642,
      'loadout': <String, Object?>{
        'boostItemCode': null,
        'modifierItemCode': 'less_compensation',
      },
      'claim': <String, Object?>{'claimId': 'claim_123', 'claimed': false},
    });
  }
  if (request.path.endsWith('/claim')) {
    return _envelope(<String, Object?>{
      'claimId': 'claim_123',
      'runId': 'run_123',
      'claimed': true,
      'awarded': <String, int>{'exp': 675, 'coins': 1, 'rp': 500},
    });
  }
  throw StateError('Unexpected run request ${request.path}');
}
