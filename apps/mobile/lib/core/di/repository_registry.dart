import 'package:dio/dio.dart';
import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/storage/local_data_cache.dart';
import 'package:milestracks/features/auth/data/fake_auth_repository.dart';
import 'package:milestracks/features/auth/data/remote_auth_repository.dart';
import 'package:milestracks/features/auth/domain/auth_repository.dart';
import 'package:milestracks/features/onboarding/data/fake_onboarding_repository.dart';
import 'package:milestracks/features/onboarding/data/remote_onboarding_repository.dart';
import 'package:milestracks/features/onboarding/domain/onboarding_repository.dart';
import 'package:milestracks/features/profile/data/fake_profile_repository.dart';
import 'package:milestracks/features/profile/data/remote_profile_repository.dart';
import 'package:milestracks/features/profile/domain/badge_repository.dart';
import 'package:milestracks/features/profile/domain/profile_repository.dart';
import 'package:milestracks/features/run/data/fake_run_repository.dart';
import 'package:milestracks/features/run/data/remote_run_repository.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/features/shop/data/fake_shop_repository.dart';
import 'package:milestracks/features/shop/data/remote_shop_repository.dart';
import 'package:milestracks/features/shop/domain/shop_repository.dart';
import 'package:milestracks/features/streak/data/fake_streak_repository.dart';
import 'package:milestracks/features/streak/data/remote_streak_repository.dart';
import 'package:milestracks/features/streak/domain/streak_repository.dart';
import 'package:milestracks/features/track/data/fake_track_repository.dart';
import 'package:milestracks/features/track/data/remote_track_repository.dart';
import 'package:milestracks/features/track/domain/track_repository.dart';

class RepositoryRegistry {
  const RepositoryRegistry({
    required this.auth,
    required this.onboarding,
    required this.profile,
    required this.badges,
    required this.track,
    required this.run,
    required this.shop,
    required this.streak,
  });

  final AuthRepository auth;
  final OnboardingRepository onboarding;
  final ProfileRepository profile;
  final BadgeRepository badges;
  final TrackRepository track;
  final RunRepository run;
  final ShopRepository shop;
  final StreakRepository streak;

  factory RepositoryRegistry.fake({
    required FakeRepositoryBehavior behavior,
    required String Function() languageCode,
  }) {
    final store = FakeDataStore(languageCode: languageCode);
    return RepositoryRegistry(
      auth: FakeAuthRepository(behavior, store),
      onboarding: FakeOnboardingRepository(behavior, store),
      profile: FakeProfileRepository(behavior, store),
      badges: FakeBadgeRepository(behavior, store),
      track: FakeTrackRepository(behavior, store),
      run: FakeRunRepository(behavior, store),
      shop: FakeShopRepository(behavior, store),
      streak: FakeStreakRepository(behavior, store),
    );
  }

  factory RepositoryRegistry.remote(Dio dio, {required LocalDataCache cache}) =>
      RepositoryRegistry(
        auth: RemoteAuthRepository(dio),
        onboarding: RemoteOnboardingRepository(dio, cache: cache),
        profile: RemoteProfileRepository(dio, cache: cache),
        badges: RemoteBadgeRepository(dio, cache: cache),
        track: RemoteTrackRepository(dio),
        run: RemoteRunRepository(dio, cache: cache),
        shop: RemoteShopRepository(dio, cache: cache),
        streak: RemoteStreakRepository(dio, cache: cache),
      );
}
