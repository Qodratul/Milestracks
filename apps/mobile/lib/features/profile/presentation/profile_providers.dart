import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_providers.g.dart';

@riverpod
Future<List<BadgeDto>> userBadges(Ref ref) =>
    ref.watch(badgeRepositoryProvider).getBadges();
