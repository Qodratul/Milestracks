import 'package:milestracks/shared/models/api_models.dart';

abstract interface class StravaRepository {
  Future<StravaConnectResponseDto> connect(StravaConnectRequestDto request);
  Future<void> disconnect();
}
