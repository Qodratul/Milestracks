import 'package:milestracks/shared/models/api_models.dart';

abstract interface class ProfileRepository {
  Future<UserDto> getProfile();
}
