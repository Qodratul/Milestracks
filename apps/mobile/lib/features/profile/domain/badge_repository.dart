import 'package:milestracks/shared/models/api_models.dart';

abstract interface class BadgeRepository {
  Future<List<BadgeDto>> getBadges();
}
