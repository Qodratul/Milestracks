import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/run_engine/gps_point_source.dart';
import 'package:milestracks/run_engine/gps_processing.dart';
import 'package:milestracks/run_engine/run_engine_state.dart';
import 'package:milestracks/shared/models/api_models.dart';

RunPointDto point(
  double latitude,
  double longitude,
  int seconds, {
  double accuracy = 5,
  double? speed,
}) => RunPointDto(
  latitude: latitude,
  longitude: longitude,
  recordedAt: DateTime.utc(2026, 10, 26).add(Duration(seconds: seconds)),
  accuracyMeters: accuracy,
  speedMetersPerSecond: speed,
);

void main() {
  group('GPS filter', () {
    test('rejects low quality fixes and implausible jumps', () {
      final filter = GpsFixFilter();
      expect(filter.add(point(-6.2, 106.8, 0, accuracy: 90)), isNull);
      expect(filter.add(point(-6.2, 106.8, 1)), isNotNull);
      expect(filter.add(point(-6.2, 106.81, 2)), isNull);
    });

    test('smooths accepted fixes and simplifies the trace', () {
      final filter = GpsFixFilter();
      final first = point(-6.2, 106.8, 0);
      final second = point(-6.2, 106.8001, 5);
      expect(filter.add(first), first);
      final smoothed = filter.add(second);
      expect(smoothed!.longitude, lessThan(second.longitude));
      expect(
        simplifyRunTrace(<RunPointDto>[
          first,
          point(-6.2, 106.80001, 2),
          second,
        ]),
        hasLength(2),
      );
    });
  });

  test('milestones require forward progress on the revealed route', () {
    final detector = MilestoneProgressDetector();
    const route = <GeoPointDto>[
      GeoPointDto(latitude: -6.2, longitude: 106.8),
      GeoPointDto(latitude: -6.2, longitude: 106.802),
    ];
    const milestone = TrackMilestoneDto(
      id: 'middle',
      order: 1,
      position: GeoPointDto(latitude: -6.2, longitude: 106.801),
      reached: false,
      expReward: 10,
    );
    expect(
      detector.update(
        point: point(-6.2, 106.801, 1),
        revealedPolyline: route,
        milestones: const <TrackMilestoneDto>[milestone],
      ),
      milestone,
    );
    expect(
      detector.update(
        point: point(-6.2, 106.8005, 2),
        revealedPolyline: route,
        milestones: const <TrackMilestoneDto>[milestone],
      ),
      isNull,
    );
  });

  test('run state machine enforces run and safe stop transitions', () {
    expect(
      RunStateMachine.canTransition(RunPhase.idle, RunPhase.ready),
      isTrue,
    );
    expect(
      RunStateMachine.canTransition(RunPhase.idle, RunPhase.running),
      isFalse,
    );
    expect(
      RunStateMachine.canTransition(RunPhase.ready, RunPhase.running),
      isTrue,
    );
    expect(
      RunStateMachine.canTransition(RunPhase.running, RunPhase.safeStopped),
      isTrue,
    );
    expect(
      RunStateMachine.canTransition(RunPhase.safeStopped, RunPhase.running),
      isFalse,
    );
  });

  test('mock GPX parser provides a time-ordered route stream', () {
    final points = MockGpxStream.parse('''
      <gpx><trk><trkseg>
        <trkpt lat="-6.2" lon="106.8"><time>2026-10-26T01:00:00Z</time></trkpt>
        <trkpt lat="-6.2" lon="106.8001"><time>2026-10-26T01:00:05Z</time></trkpt>
      </trkseg></trk></gpx>
    ''');
    expect(points, hasLength(2));
    expect(points.last.recordedAt.isAfter(points.first.recordedAt), isTrue);
  });
}
