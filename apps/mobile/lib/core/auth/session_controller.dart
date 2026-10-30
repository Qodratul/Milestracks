import 'dart:async';

import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/storage/app_database.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_controller.g.dart';

@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  @override
  bool build() {
    unawaited(_restoreSession());
    return false;
  }

  Future<void> establishSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _clearCachedAccountData();
    final storage = ref.read(secureStorageProvider);
    await storage.write(SecureStorageKeys.accessToken, accessToken);
    await storage.write(SecureStorageKeys.refreshToken, refreshToken);
    state = true;
  }

  Future<void> signOut({bool revokeServerSession = true}) async {
    final storage = ref.read(secureStorageProvider);
    final refreshToken = await storage.read(SecureStorageKeys.refreshToken);
    if (revokeServerSession && refreshToken != null) {
      try {
        await ref
            .read(authRepositoryProvider)
            .logout(RefreshRequestDto(refreshToken: refreshToken));
      } catch (_) {
        // Local sign-out must still complete when the server is unreachable.
      }
    }
    await storage.delete(SecureStorageKeys.accessToken);
    await storage.delete(SecureStorageKeys.refreshToken);
    await storage.delete(SecureStorageKeys.onboardingComplete);
    await _clearCachedAccountData();
    await ref.read(onboardingControllerProvider.notifier).syncComplete(false);
    state = false;
  }

  Future<void> _clearCachedAccountData() async {
    try {
      await (await ref.read(appDatabaseProvider.future)).clearCachedJson();
    } on Object {
      // Auth changes must still complete when local cache storage is unavailable.
    }
  }

  Future<void> _restoreSession() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(SecureStorageKeys.accessToken);
    if (token == null || token.isEmpty) return;
    final onboarding = await storage.read(SecureStorageKeys.onboardingComplete);
    await ref
        .read(onboardingControllerProvider.notifier)
        .syncComplete(onboarding == 'true');
    state = true;
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      await ref
          .read(onboardingControllerProvider.notifier)
          .syncComplete(profile.onboardingComplete);
    } catch (_) {
      // Keep the local session available during transient offline startup.
    }
  }
}

@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  bool build() {
    unawaited(_restoreOnboarding());
    return false;
  }

  Future<void> markComplete() async {
    await syncComplete(true);
  }

  Future<void> syncComplete(bool complete) async {
    final storage = ref.read(secureStorageProvider);
    if (complete) {
      await storage.write(SecureStorageKeys.onboardingComplete, 'true');
    } else {
      await storage.delete(SecureStorageKeys.onboardingComplete);
    }
    state = complete;
  }

  Future<void> _restoreOnboarding() async {
    final value = await ref
        .read(secureStorageProvider)
        .read(SecureStorageKeys.onboardingComplete);
    state = value == 'true';
  }
}
