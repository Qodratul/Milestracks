import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/track/domain/track_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteTrackRepository extends RemoteRepositoryBase
    implements TrackRepository {
  const RemoteTrackRepository(super.dio);

  @override
  Future<TrackDto> createTrack(CreateTrackRequestDto request) =>
      guard(() async {
        final key = IdempotencyKey.create();
        final body = <String, Object?>{
          'location': <String, Object?>{
            'lat': request.location.latitude,
            'lng': request.location.longitude,
            if (request.location.accuracyMeters != null)
              'accuracyMeters': request.location.accuracyMeters,
          },
        };
        final response = await retryIdempotent(
          () => dio.post<Map<String, dynamic>>(
            '/routes/mystery/generate',
            data: body,
            options: Options(headers: <String, Object>{'Idempotency-Key': key}),
          ),
        );
        final route = objectData(response.data);
        final routeId = _string(route['routeId']);
        if (route['status'] == 'ready') return _loadReadyTrack(routeId);
        if (route['status'] == 'failed') {
          throw _generationFailed(route);
        }
        if (route['status'] != 'generating') {
          throw const FormatException('Unknown route generation status.');
        }
        return _waitForReadyRoute(routeId, route);
      });

  @override
  Future<TrackDto?> getTodaysTrack() => guard(() async {
    final response = await dio.get<Map<String, dynamic>>(
      '/routes/mystery/today',
    );
    final data = response.data?['data'];
    if (data == null) return null;
    final route = Map<String, dynamic>.from(data as Map);
    if (route['status'] == 'generating') {
      return _waitForReadyRoute(_string(route['routeId']), route);
    }
    if (route['status'] == 'failed') {
      throw _generationFailed(route);
    }
    if (route['status'] != 'ready') {
      throw const FormatException('Unknown route status.');
    }
    return _loadReadyTrack(_string(route['routeId']));
  });

  @override
  Future<TrackDto> getTrack(String trackId) =>
      guard(() => _loadReadyTrack(trackId));

  Future<TrackDto> _waitForReadyRoute(
    String routeId,
    Map<String, dynamic> initial,
  ) async {
    var route = initial;
    var delay = _pollDelay(route['pollAfterMs']);
    final stopwatch = Stopwatch()..start();
    const timeout = Duration(minutes: 2);
    while (stopwatch.elapsed < timeout) {
      final remaining = timeout - stopwatch.elapsed;
      await Future<void>.delayed(delay > remaining ? remaining : delay);
      final response = await dio.get<Map<String, dynamic>>(
        '/routes/mystery/today',
      );
      final data = objectData(response.data);
      if (data.isEmpty || data['routeId'] != routeId) {
        throw const FormatException('The active generated route changed.');
      }
      route = data;
      if (route['status'] == 'ready') return _loadReadyTrack(routeId);
      if (route['status'] == 'failed') {
        throw _generationFailed(route);
      }
      if (route['status'] != 'generating') {
        throw const FormatException('Unknown route status.');
      }
      delay = _pollDelay(route['pollAfterMs']);
    }
    throw const AppException(
      kind: AppExceptionKind.timeout,
      message: 'trackGenerationTimedOut',
    );
  }

  Future<TrackDto> _loadReadyTrack(String routeId) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/routes/$routeId/preview',
    );
    final preview = objectData(response.data);
    final geometryResponse = await dio.get<Map<String, dynamic>>(
      '/routes/$routeId/geometry',
      queryParameters: const <String, Object>{'detail': 'preview'},
    );
    final geometry = objectData(geometryResponse.data);
    final revealed = geometry['revealed'] == true;
    final polyline = revealed && geometry['coordinates'] is String
        ? decodeEncodedPolyline(
            geometry['coordinates'] as String,
            _int(geometry['precision'], fallback: 5),
          )
        : const <GeoPointDto>[];
    final startPoint = Map<String, dynamic>.from(preview['startPoint'] as Map);
    final start = _location(startPoint['location']);
    final milestones = (preview['milestones'] as List? ?? const <Object>[])
        .map((item) => Map<String, dynamic>.from(item as Map))
        .map(
          (item) => TrackMilestoneDto(
            id: _string(item['id']),
            order: _int(item['ordinal']),
            // Preview geometry is only returned when the server allows this
            // route to be revealed. Project milestone distances onto that
            // geometry so route markers use server-authored milestone order
            // and distance without exposing unrevealed coordinates.
            position: revealed
                ? _positionAtRouteDistance(
                    polyline,
                    _double(item['distanceMeters']),
                    _double(preview['distanceMeters']),
                  )
                : null,
            reached: false,
            expReward: _int(item['exp']),
            distanceMeters: _double(item['distanceMeters']),
          ),
        )
        .toList(growable: false);
    final durationSeconds = _int(preview['estimatedDurationSec']);
    return TrackDto(
      id: routeId,
      status: TrackStatus.ready,
      revealMode: _revealMode(preview['revealMode']),
      narrative: TrackNarrativeDto(
        trackTitle: _string(preview['title']),
        mysteryBrief: _string(preview['mysteryBrief']),
        preRunTip: _string(preview['preRunTip'], fallback: ''),
        milestoneDialogues: const <MilestoneDialogueDto>[],
      ),
      revealedPolyline: polyline,
      milestones: milestones,
      serverStartPosition: start,
      distanceMeters: _double(preview['distanceMeters']),
      estimatedDurationMinutes: (durationSeconds / 60).round(),
      estimatedCalories: _int(preview['estimatedCalories']),
      safetyScore: (_double(preview['safetyScore']) * 100).round(),
      safetyConfidence: (_double(preview['dataConfidence']) * 100).round(),
      distanceToStartMeters: _int(startPoint['distanceMeters']),
      routeNote: preview['warning'] as String?,
      beforeStartTip: _string(preview['preRunTip'], fallback: ''),
    );
  }

  @override
  Future<List<GeoPointDto>> getRevealedGeometry(
    String routeId, {
    double? throughDistanceMeters,
  }) => guard(() async {
    final points = <GeoPointDto>[];
    var cursor = '';
    var distance = 0.0;
    while (true) {
      final query = <String, Object>{'limit': 500};
      if (cursor.isNotEmpty) query['cursor'] = cursor;
      final response = await dio.get<Map<String, dynamic>>(
        '/routes/$routeId/geometry',
        queryParameters: query,
      );
      final data = objectData(response.data);
      if (data['revealed'] != true) return const <GeoPointDto>[];
      final precision = _int(data['precision'], fallback: 5);
      for (final segment in (data['segments'] as List? ?? const <Object>[])) {
        final coordinates = Map<String, dynamic>.from(
          segment as Map,
        )['coordinates'];
        if (coordinates is! String) continue;
        for (final point in decodeEncodedPolyline(coordinates, precision)) {
          if (points.isEmpty) {
            points.add(point);
            continue;
          }
          final segmentDistance = _distanceMeters(points.last, point);
          if (throughDistanceMeters != null &&
              distance + segmentDistance > throughDistanceMeters) {
            final remaining = (throughDistanceMeters - distance).clamp(
              0,
              segmentDistance,
            );
            final fraction = segmentDistance == 0
                ? 0.0
                : remaining / segmentDistance;
            if (fraction > 0) {
              points.add(
                GeoPointDto(
                  latitude:
                      points.last.latitude +
                      (point.latitude - points.last.latitude) * fraction,
                  longitude:
                      points.last.longitude +
                      (point.longitude - points.last.longitude) * fraction,
                ),
              );
            }
            return List<GeoPointDto>.unmodifiable(points);
          }
          distance += segmentDistance;
          points.add(point);
        }
      }
      final meta = response.data?['meta'];
      final nextCursor = (meta as Map?)?['nextCursor'];
      if (nextCursor is! String || nextCursor.isEmpty) break;
      cursor = nextCursor;
    }
    return List<GeoPointDto>.unmodifiable(points);
  });
}

AppException _generationFailed(Map<String, dynamic> route) => AppException(
  kind: AppExceptionKind.server,
  message: 'trackGenerationFailed',
  backendCode: _string((route['failure'] as Map?)?['code']),
);

List<GeoPointDto> decodeEncodedPolyline(String encoded, int precision) {
  final factor = math.pow(10, precision).toDouble();
  final points = <GeoPointDto>[];
  var index = 0;
  var latitude = 0;
  var longitude = 0;
  while (index < encoded.length) {
    final lat = _decodePolylineValue(encoded, index);
    latitude += lat.$1;
    index = lat.$2;
    final lng = _decodePolylineValue(encoded, index);
    longitude += lng.$1;
    index = lng.$2;
    points.add(
      GeoPointDto(latitude: latitude / factor, longitude: longitude / factor),
    );
  }
  return List<GeoPointDto>.unmodifiable(points);
}

(int, int) _decodePolylineValue(String encoded, int start) {
  var result = 0;
  var shift = 0;
  var index = start;
  while (true) {
    if (index >= encoded.length) {
      throw const FormatException('Encoded route geometry is truncated.');
    }
    final value = encoded.codeUnitAt(index++) - 63;
    result |= (value & 0x1f) << shift;
    shift += 5;
    if (value < 0x20) break;
  }
  final delta = (result & 1) == 1 ? ~(result >> 1) : result >> 1;
  return (delta, index);
}

GeoPointDto _location(Object? value) {
  final map = Map<String, dynamic>.from(value as Map);
  return GeoPointDto(
    latitude: _double(map['lat']),
    longitude: _double(map['lng']),
  );
}

RevealMode _revealMode(Object? value) => switch (value) {
  'next_milestone' => RevealMode.nextMilestone,
  'full' => RevealMode.full,
  _ => RevealMode.blind,
};

Duration _pollDelay(Object? value) {
  final milliseconds = _int(value, fallback: 1500).clamp(500, 5000);
  return Duration(milliseconds: milliseconds);
}

String _string(Object? value, {String fallback = ''}) =>
    value is String ? value : fallback;

int _int(Object? value, {int fallback = 0}) =>
    value is num ? value.toInt() : fallback;

double _double(Object? value) => value is num ? value.toDouble() : 0;

double _distanceMeters(GeoPointDto first, GeoPointDto second) {
  const radius = 6371000.0;
  final dLat = _radians(second.latitude - first.latitude);
  final dLng = _radians(second.longitude - first.longitude);
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_radians(first.latitude)) *
          math.cos(_radians(second.latitude)) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  return radius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}

GeoPointDto? _positionAtRouteDistance(
  List<GeoPointDto> points,
  double milestoneDistanceMeters,
  double routeDistanceMeters,
) {
  if (points.length < 2 ||
      milestoneDistanceMeters <= 0 ||
      routeDistanceMeters <= 0) {
    return null;
  }

  final segmentLengths = <double>[];
  var geometryLength = 0.0;
  for (var index = 1; index < points.length; index++) {
    final length = _distanceMeters(points[index - 1], points[index]);
    segmentLengths.add(length);
    geometryLength += length;
  }
  if (geometryLength == 0) return points.first;

  final target =
      geometryLength *
      (milestoneDistanceMeters / routeDistanceMeters).clamp(0.0, 1.0);
  var traversed = 0.0;
  for (var index = 0; index < segmentLengths.length; index++) {
    final segmentLength = segmentLengths[index];
    if (traversed + segmentLength >= target) {
      final fraction = segmentLength == 0
          ? 0.0
          : (target - traversed) / segmentLength;
      final start = points[index];
      final end = points[index + 1];
      return GeoPointDto(
        latitude: start.latitude + (end.latitude - start.latitude) * fraction,
        longitude:
            start.longitude + (end.longitude - start.longitude) * fraction,
      );
    }
    traversed += segmentLength;
  }
  return points.last;
}

double _radians(double value) => value * math.pi / 180;
