import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/features/auth/data/google_sign_in_client.dart';
import 'package:milestracks/features/auth/domain/auth_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteAuthRepository extends RemoteRepositoryBase
    implements AuthRepository {
  RemoteAuthRepository(super.dio, {GoogleSignInClient? googleSignInClient})
    : _googleSignInClient = googleSignInClient ?? PlatformGoogleSignInClient();

  final GoogleSignInClient _googleSignInClient;

  @override
  Future<AuthTokensDto> register(CredentialsRequestDto request) =>
      guard(() async {
        final response = await dio.post<Map<String, dynamic>>(
          '/auth/register',
          data: request.toJson(),
        );
        return AuthTokensDto.fromJson(objectData(response.data));
      });

  @override
  Future<AuthTokensDto> login(CredentialsRequestDto request) => guard(() async {
    final response = await dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    return AuthTokensDto.fromJson(objectData(response.data));
  });

  @override
  Future<AuthTokensDto> loginWithGoogle(GoogleAuthRequestDto request) =>
      guard(() async {
        final idToken = await _googleSignInClient.acquireIdToken();
        if (idToken == null) {
          throw const AppException(
            kind: AppExceptionKind.unknown,
            message: 'googleSignInCanceled',
          );
        }
        final response = await dio.post<Map<String, dynamic>>(
          '/auth/google',
          data: request.copyWith(idToken: idToken).toJson(),
        );
        return AuthTokensDto.fromJson(objectData(response.data));
      });

  @override
  Future<RefreshedTokensDto> refreshSession(RefreshRequestDto request) =>
      guard(() async {
        final response = await dio.post<Map<String, dynamic>>(
          '/auth/refresh',
          data: request.toJson(),
        );
        return RefreshedTokensDto.fromJson(objectData(response.data));
      });

  @override
  Future<void> logout(RefreshRequestDto request) => guard(() async {
    try {
      await dio.post<void>('/auth/logout', data: request.toJson());
    } finally {
      try {
        await _googleSignInClient.signOut();
      } catch (_) {
        // The API session is still revoked even if provider sign-out fails.
      }
    }
  });
}
