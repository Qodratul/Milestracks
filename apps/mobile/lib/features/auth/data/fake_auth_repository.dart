import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/auth/domain/auth_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeAuthRepository implements AuthRepository {
  const FakeAuthRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<AuthTokensDto> register(CredentialsRequestDto request) =>
      behavior.execute('auth.register', () => _tokens());

  @override
  Future<AuthTokensDto> login(CredentialsRequestDto request) =>
      behavior.execute('auth.login', () => _tokens());

  @override
  Future<AuthTokensDto> loginWithGoogle(GoogleAuthRequestDto request) =>
      behavior.execute('auth.google', () => _tokens());

  @override
  Future<RefreshedTokensDto> refreshSession(RefreshRequestDto request) =>
      behavior.execute(
        'auth.refresh',
        () => const RefreshedTokensDto(
          accessToken: 'fake-access-refreshed',
          refreshToken: 'fake-refresh-refreshed',
        ),
      );

  @override
  Future<void> logout(RefreshRequestDto request) =>
      behavior.execute('auth.logout', () {});

  AuthTokensDto _tokens() => AuthTokensDto(
    accessToken: 'fake-access-token',
    refreshToken: 'fake-refresh-token',
    user: AuthUserDto(
      id: store.user.id,
      email: store.user.email,
      displayName: store.user.displayName,
      emailVerified: true,
      locale: 'en',
    ),
  );
}
