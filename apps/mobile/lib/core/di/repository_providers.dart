import 'package:milestracks/core/config/app_config.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/di/repository_registry.dart';
import 'package:milestracks/core/network/api_client.dart';
import 'package:milestracks/core/storage/app_database.dart';
import 'package:milestracks/core/storage/local_data_cache.dart';
import 'package:milestracks/features/auth/domain/auth_repository.dart';
import 'package:milestracks/features/onboarding/domain/onboarding_repository.dart';
import 'package:milestracks/features/profile/domain/badge_repository.dart';
import 'package:milestracks/features/profile/domain/profile_repository.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/features/shop/domain/shop_repository.dart';
import 'package:milestracks/features/streak/domain/streak_repository.dart';
import 'package:milestracks/features/track/domain/track_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
RepositoryRegistry repositoryRegistry(Ref ref) {
  if (AppConfig.useFakeApi) {
    return RepositoryRegistry.fake(
      behavior: ref.watch(fakeRepositoryBehaviorProvider),
      languageCode: () => ref.read(languageControllerProvider).languageCode,
    );
  }
  return RepositoryRegistry.remote(
    ref.watch(apiClientProvider),
    cache: LocalDataCache(() => ref.read(appDatabaseProvider.future)),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).auth;

@Riverpod(keepAlive: true)
OnboardingRepository onboardingRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).onboarding;

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).profile;

@Riverpod(keepAlive: true)
BadgeRepository badgeRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).badges;

@Riverpod(keepAlive: true)
TrackRepository trackRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).track;

@Riverpod(keepAlive: true)
RunRepository runRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).run;

@Riverpod(keepAlive: true)
ShopRepository shopRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).shop;

@Riverpod(keepAlive: true)
StreakRepository streakRepository(Ref ref) =>
    ref.watch(repositoryRegistryProvider).streak;
