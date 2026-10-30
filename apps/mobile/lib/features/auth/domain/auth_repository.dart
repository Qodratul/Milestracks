import 'package:milestracks/shared/models/api_models.dart';

abstract interface class AuthRepository {
  Future<AuthTokensDto> register(CredentialsRequestDto request);
  Future<AuthTokensDto> login(CredentialsRequestDto request);
  Future<AuthTokensDto> loginWithGoogle(GoogleAuthRequestDto request);
  Future<RefreshedTokensDto> refreshSession(RefreshRequestDto request);
  Future<void> logout(RefreshRequestDto request);
}
