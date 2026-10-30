import 'package:milestracks/shared/models/api_models.dart';

abstract interface class TrackRepository {
  Future<TrackDto> createTrack(CreateTrackRequestDto request);
  Future<TrackDto?> getTodaysTrack();
  Future<TrackDto> getTrack(String trackId);
  Future<List<GeoPointDto>> getRevealedGeometry(
    String routeId, {
    double? throughDistanceMeters,
  });
}
