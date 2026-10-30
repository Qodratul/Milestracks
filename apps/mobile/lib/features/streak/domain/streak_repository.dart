import 'package:milestracks/shared/models/api_models.dart';

abstract interface class StreakRepository {
  Future<StreakDto> getStreak();
}
