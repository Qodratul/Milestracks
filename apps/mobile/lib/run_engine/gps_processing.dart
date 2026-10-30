import 'dart:math' as math;

import 'package:milestracks/shared/models/api_models.dart';
import 'package:turf/turf.dart' as turf;

class GpsFilterPolicy {
  const GpsFilterPolicy({
    this.maximumAccuracyMeters = 25,
    this.maximumSpeedMetersPerSecond = 8,
    this.minimumPointSpacingMeters = 1,
    this.minimumMovementSpeedMetersPerSecond = .6,
    this.lowPassWeight = .35,
  });

  final double maximumAccuracyMeters;
  final double maximumSpeedMetersPerSecond;
  final double minimumPointSpacingMeters;
  final double minimumMovementSpeedMetersPerSecond;
  final double lowPassWeight;
}

class GpsFixFilter {
  GpsFixFilter({this.policy = const GpsFilterPolicy()});

  final GpsFilterPolicy policy;
  RunPointDto? _previous;
  RunPointDto? _lastAccepted;
  bool _stationary = true;

  RunPointDto? add(RunPointDto point) {
    final accuracy = point.accuracyMeters;
    if (accuracy == null ||
        !accuracy.isFinite ||
        accuracy < 0 ||
        accuracy > policy.maximumAccuracyMeters) {
      return null;
    }
    if (!point.latitude.isFinite ||
        !point.longitude.isFinite ||
        point.latitude.abs() > 90 ||
        point.longitude.abs() > 180) {
      return null;
    }

    final previous = _previous;
    if (previous != null) {
      final seconds =
          point.recordedAt.difference(previous.recordedAt).inMilliseconds /
          1000;
      if (seconds <= 0) return null;
      final distance = _distanceMeters(previous, point);
      final estimatedSpeed = distance / seconds;
      final reportedSpeed = point.speedMetersPerSecond;
      if (reportedSpeed != null &&
          reportedSpeed < policy.minimumMovementSpeedMetersPerSecond) {
        // Keep the filter anchored to recent stationary fixes so GPS drift
        // does not accumulate into fake distance while the runner is stopped.
        return _holdPosition(point);
      }
      if (estimatedSpeed > policy.maximumSpeedMetersPerSecond ||
          (reportedSpeed != null &&
              reportedSpeed > policy.maximumSpeedMetersPerSecond)) {
        return null;
      }
      if (reportedSpeed == null &&
          estimatedSpeed < policy.minimumMovementSpeedMetersPerSecond) {
        return _holdPosition(point);
      }
      if (_stationary) {
        // Require another moving fix after a stationary period before
        // allowing GPS drift at the transition to add distance.
        _stationary = false;
        _previous = point;
        return null;
      }
      if (distance < policy.minimumPointSpacingMeters) return null;

      final weight = policy.lowPassWeight;
      final filtered = point.copyWith(
        latitude:
            previous.latitude + (point.latitude - previous.latitude) * weight,
        longitude:
            previous.longitude +
            (point.longitude - previous.longitude) * weight,
      );
      _previous = filtered;
      _lastAccepted = filtered;
      return filtered;
    }

    _previous = point;
    _lastAccepted = point;
    return point;
  }

  RunPointDto _holdPosition(RunPointDto point) {
    _previous = point;
    _stationary = true;
    final anchor = _lastAccepted;
    if (anchor == null) {
      _lastAccepted = point;
      return point;
    }
    final held = anchor.copyWith(
      recordedAt: point.recordedAt,
      accuracyMeters: point.accuracyMeters,
      speedMetersPerSecond: point.speedMetersPerSecond,
      mocked: point.mocked,
    );
    _lastAccepted = held;
    return held;
  }

  void reset() {
    _previous = null;
    _lastAccepted = null;
    _stationary = true;
  }
}

class MilestoneProgressDetector {
  MilestoneProgressDetector({
    this.minimumRadiusMeters = 25,
    this.maximumRadiusMeters = 80,
    this.accuracyRadiusMultiplier = 2.5,
  });

  final double minimumRadiusMeters;
  final double maximumRadiusMeters;
  final double accuracyRadiusMultiplier;
  double _furthestProgressMeters = 0;
  final Set<String> _reached = <String>{};

  double get furthestProgressMeters => _furthestProgressMeters;

  void unmark(String milestoneId) => _reached.remove(milestoneId);

  TrackMilestoneDto? update({
    required RunPointDto point,
    required List<GeoPointDto> revealedPolyline,
    required List<TrackMilestoneDto> milestones,
  }) {
    final visibleMilestones = milestones
        .where((milestone) => milestone.position != null)
        .toList(growable: false);
    if (revealedPolyline.length < 2) {
      for (final milestone in visibleMilestones) {
        if (milestone.reached || _reached.contains(milestone.id)) continue;
        final position = turf.Point(
          coordinates: turf.Position(
            milestone.position!.longitude,
            milestone.position!.latitude,
          ),
        );
        final current = turf.Point(
          coordinates: turf.Position(point.longitude, point.latitude),
        );
        final distance = turf.distance(current, position, turf.Unit.meters);
        final radius = (milestone.radiusMeters ?? minimumRadiusMeters).clamp(
          minimumRadiusMeters,
          maximumRadiusMeters,
        );
        if (distance <= radius) {
          _reached.add(milestone.id);
          return milestone;
        }
      }
      return null;
    }
    final line = turf.LineString(
      coordinates: revealedPolyline
          .map((item) => turf.Position(item.longitude, item.latitude))
          .toList(growable: false),
    );
    final current = turf.Point(
      coordinates: turf.Position(point.longitude, point.latitude),
    );
    final projection = turf.nearestPointOnLine(line, current, turf.Unit.meters);
    final routeProgress =
        (projection.properties?['location'] as num?)?.toDouble() ?? 0;
    final lateralDistance =
        (projection.properties?['dist'] as num?)?.toDouble() ?? double.infinity;
    if (routeProgress + 1 < _furthestProgressMeters) return null;
    _furthestProgressMeters = math.max(_furthestProgressMeters, routeProgress);

    final adaptiveRadius =
        (point.accuracyMeters ?? 0) * accuracyRadiusMultiplier;
    final radius = adaptiveRadius.clamp(
      minimumRadiusMeters,
      maximumRadiusMeters,
    );
    if (lateralDistance > radius) return null;

    for (final milestone in visibleMilestones) {
      if (milestone.reached || _reached.contains(milestone.id)) continue;
      final milestonePosition = milestone.position!;
      final position = turf.Point(
        coordinates: turf.Position(
          milestonePosition.longitude,
          milestonePosition.latitude,
        ),
      );
      final milestoneProjection = turf.nearestPointOnLine(
        line,
        position,
        turf.Unit.meters,
      );
      final milestoneProgress =
          (milestoneProjection.properties?['location'] as num?)?.toDouble() ??
          0;
      final distanceToMilestone = turf.distance(
        current,
        position,
        turf.Unit.meters,
      );
      final milestoneRadius = (milestone.radiusMeters ?? radius).clamp(
        minimumRadiusMeters,
        maximumRadiusMeters,
      );
      if (distanceToMilestone <= milestoneRadius &&
          routeProgress >= milestoneProgress - radius) {
        _reached.add(milestone.id);
        return milestone;
      }
    }
    return null;
  }

  void reset() {
    _furthestProgressMeters = 0;
    _reached.clear();
  }
}

List<RunPointDto> simplifyRunTrace(
  List<RunPointDto> points, {
  double toleranceDegrees = .00001,
}) {
  if (points.length < 3) return List<RunPointDto>.unmodifiable(points);
  final feature = turf.Feature<turf.LineString>(
    geometry: turf.LineString(
      coordinates: points
          .map((point) => turf.Position(point.longitude, point.latitude))
          .toList(growable: false),
    ),
  );
  final reduced = turf
      .simplify(feature, tolerance: toleranceDegrees, highestQuality: true)
      .geometry!
      .coordinates;
  final byCoordinate = <String, RunPointDto>{
    for (final point in points) '${point.longitude}:${point.latitude}': point,
  };
  return List<RunPointDto>.unmodifiable(
    reduced.map((position) => byCoordinate['${position.lng}:${position.lat}']!),
  );
}

double _distanceMeters(RunPointDto a, RunPointDto b) => turf
    .distance(
      turf.Point(coordinates: turf.Position(a.longitude, a.latitude)),
      turf.Point(coordinates: turf.Position(b.longitude, b.latitude)),
      turf.Unit.meters,
    )
    .toDouble();
