import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/config/device_timezone.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

  Future<void> signIn(String email, String password) => _authenticate(
    () => ref
        .read(authRepositoryProvider)
        .login(CredentialsRequestDto(email: email, password: password)),
  );

  Future<void> signUp(String email, String password, String displayName) async {
    final timezone = await _deviceTimezone();
    final locale = ref.read(languageControllerProvider).languageCode;
    await _authenticate(
      () => ref
          .read(authRepositoryProvider)
          .register(
            CredentialsRequestDto(
              email: email,
              password: password,
              displayName: displayName,
              locale: locale,
              timezone: timezone,
            ),
          ),
    );
  }

  Future<void> signInWithGoogle() async {
    final timezone = await _deviceTimezone();
    final locale = ref.read(languageControllerProvider).languageCode;
    return _authenticate(
      () => ref
          .read(authRepositoryProvider)
          .loginWithGoogle(
            GoogleAuthRequestDto(
              idToken: '',
              locale: locale,
              timezone: timezone,
            ),
          ),
    );
  }

  Future<String> _deviceTimezone() async {
    try {
      return await DeviceTimezone.getIanaName();
    } on Object {
      return 'UTC';
    }
  }

  Future<void> _authenticate(Future<AuthTokensDto> Function() request) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      final tokens = await request();
      await ref
          .read(sessionControllerProvider.notifier)
          .establishSession(
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
          );
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      await ref
          .read(onboardingControllerProvider.notifier)
          .syncComplete(profile.onboardingComplete);
    });
  }
}
