import 'package:geolocator/geolocator.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'track_providers.g.dart';

@riverpod
Future<UserDto> currentUser(Ref ref) =>
    ref.watch(profileRepositoryProvider).getProfile();

@riverpod
Future<StreakDto> currentStreak(Ref ref) =>
    ref.watch(streakRepositoryProvider).getStreak();

@riverpod
Future<ActiveRunRecovery?> activeRunRecovery(Ref ref) =>
    ref.watch(runRepositoryProvider).getActiveRun();

@riverpod
Future<TrackDto> trackById(Ref ref, String trackId) =>
    ref.watch(trackRepositoryProvider).getTrack(trackId);

@riverpod
Future<TrackDto> todayMysteryTrack(Ref ref) async {
  final existing = await ref.watch(trackRepositoryProvider).getTodaysTrack();
  if (existing != null) return existing;
  return _generateTrack(ref);
}

@riverpod
Future<TrackDto> generateTrack(Ref ref) => _generateTrack(ref);

Future<TrackDto> _generateTrack(Ref ref) async {
  // Avoid spending route-generation quota when a run from this account is
  // still active. The server performs the same guard to cover race conditions.
  final activeRun = await ref.read(runRepositoryProvider).getActiveRun();
  if (activeRun != null) throw const TrackActiveRunExists();

  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (!serviceEnabled ||
      permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    throw const TrackLocationUnavailable();
  }

  final position = await Geolocator.getCurrentPosition();
  return ref
      .watch(trackRepositoryProvider)
      .createTrack(
        CreateTrackRequestDto(
          location: TrackStartLocationDto(
            latitude: position.latitude,
            longitude: position.longitude,
            accuracyMeters: position.accuracy,
          ),
        ),
      );
}

class TrackLocationUnavailable implements Exception {
  const TrackLocationUnavailable();
}

class TrackActiveRunExists implements Exception {
  const TrackActiveRunExists();
}
