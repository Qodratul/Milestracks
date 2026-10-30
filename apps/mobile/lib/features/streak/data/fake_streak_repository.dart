import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/streak/domain/streak_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeStreakRepository implements StreakRepository {
  const FakeStreakRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<StreakDto> getStreak() => behavior.execute(
    'streak.get',
    () => StreakDto(
      currentDays: store.user.streakDays,
      bestDays: 9,
      freezesRemaining: 0,
      restShieldActive: false,
      lastQualifiedAt: DateTime.utc(2026, 10, 24),
    ),
  );
}
