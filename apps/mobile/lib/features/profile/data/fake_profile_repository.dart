import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/profile/domain/badge_repository.dart';
import 'package:milestracks/features/profile/domain/profile_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeProfileRepository implements ProfileRepository {
  const FakeProfileRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<UserDto> getProfile() =>
      behavior.execute('profile.get', () => store.user);
}

class FakeBadgeRepository implements BadgeRepository {
  const FakeBadgeRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<List<BadgeDto>> getBadges() =>
      behavior.execute('badges.get', store.badges);
}
