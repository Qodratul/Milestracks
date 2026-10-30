import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/track/domain/track_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeTrackRepository implements TrackRepository {
  const FakeTrackRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<TrackDto> createTrack(CreateTrackRequestDto request) =>
      behavior.execute(
        'track.create',
        () => store.track(failed: behavior.trackGenerationFails),
      );

  @override
  Future<TrackDto?> getTodaysTrack() =>
      behavior.execute('track.today', () => store.track(failed: false));

  @override
  Future<TrackDto> getTrack(String trackId) => behavior.execute(
    'track.get',
    () => store.track(failed: false, id: trackId),
  );

  @override
  Future<List<GeoPointDto>> getRevealedGeometry(
    String routeId, {
    double? throughDistanceMeters,
  }) => behavior.execute(
    'track.geometry',
    () => store.track(failed: false, id: routeId).revealedPolyline,
  );
}
