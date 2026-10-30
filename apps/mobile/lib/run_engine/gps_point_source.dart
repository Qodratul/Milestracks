import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_point_source.g.dart';

class RunNotificationCopy {
  const RunNotificationCopy({
    required this.title,
    required this.body,
    required this.channelName,
  });

  final String title;
  final String body;
  final String channelName;
}

abstract interface class GpsPointSource {
  Stream<RunPointDto> points(RunNotificationCopy notificationCopy);
}

class MockGpxPointSource implements GpsPointSource {
  const MockGpxPointSource({this.gpxStream = const MockGpxStream()});

  final MockGpxStream gpxStream;

  @override
  Stream<RunPointDto> points(RunNotificationCopy notificationCopy) =>
      gpxStream.stream();
}

class GeolocatorGpsPointSource implements GpsPointSource {
  const GeolocatorGpsPointSource();

  @override
  Stream<RunPointDto> points(RunNotificationCopy notificationCopy) {
    final settings = Platform.isAndroid
        ? AndroidSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 2,
            intervalDuration: const Duration(seconds: 1),
            foregroundNotificationConfig: ForegroundNotificationConfig(
              notificationTitle: notificationCopy.title,
              notificationText: notificationCopy.body,
              notificationChannelName: notificationCopy.channelName,
              setOngoing: true,
            ),
          )
        : Platform.isIOS
        ? AppleSettings(
            accuracy: LocationAccuracy.bestForNavigation,
            distanceFilter: 2,
            activityType: ActivityType.fitness,
            allowBackgroundLocationUpdates: true,
            pauseLocationUpdatesAutomatically: false,
            showBackgroundLocationIndicator: true,
          )
        : const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 2,
          );

    return Geolocator.getPositionStream(locationSettings: settings).map(
      (position) => RunPointDto(
        latitude: position.latitude,
        longitude: position.longitude,
        recordedAt: position.timestamp.toUtc(),
        accuracyMeters: position.accuracy,
        speedMetersPerSecond: position.speed >= 0 ? position.speed : null,
        mocked: position.isMocked,
      ),
    );
  }
}

@Riverpod(keepAlive: true)
GpsPointSource gpsPointSource(Ref ref) => const GeolocatorGpsPointSource();

class MockGpxStream {
  const MockGpxStream();

  Future<List<RunPointDto>> readSample() async =>
      parse(await rootBundle.loadString('assets/sample_gpx/morning_loop.gpx'));

  Stream<RunPointDto> stream({
    Duration interval = const Duration(seconds: 1),
  }) async* {
    final sample = await readSample();
    final sourceStart = sample.firstOrNull?.recordedAt;
    final replayStart = DateTime.now().toUtc();
    for (final point in sample) {
      final recordedAt = sourceStart == null
          ? replayStart
          : replayStart.add(point.recordedAt.difference(sourceStart));
      yield point.copyWith(recordedAt: recordedAt);
      await Future<void>.delayed(interval);
    }
  }

  static List<RunPointDto> parse(String gpx) {
    final pointPattern = RegExp(
      r'<trkpt\s+lat="([^"]+)"\s+lon="([^"]+)"[^>]*>.*?<time>([^<]+)</time>.*?</trkpt>',
      dotAll: true,
    );
    return List<RunPointDto>.unmodifiable(
      pointPattern
          .allMatches(gpx)
          .map(
            (match) => RunPointDto(
              latitude: double.parse(match.group(1)!),
              longitude: double.parse(match.group(2)!),
              recordedAt: DateTime.parse(match.group(3)!).toUtc(),
              accuracyMeters: 5,
            ),
          ),
    );
  }
}

Future<bool> ensureBackgroundLocationPermission() async {
  final foreground = await Permission.locationWhenInUse.status;
  if (!foreground.isGranted) {
    final requestedForeground = await Permission.locationWhenInUse.request();
    if (!requestedForeground.isGranted) return false;
  }
  final current = await Permission.locationAlways.status;
  if (current.isGranted) return true;
  final requested = await Permission.locationAlways.request();
  if (requested.isPermanentlyDenied) await openAppSettings();
  return requested.isGranted;
}
