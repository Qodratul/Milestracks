import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/features/profile/domain/badge_repository.dart';
import 'package:milestracks/features/profile/domain/profile_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteProfileRepository extends RemoteRepositoryBase
    implements ProfileRepository {
  const RemoteProfileRepository(super.dio, {super.cache});

  @override
  Future<UserDto> getProfile() => cachedRead<UserDto>(
    key: 'profile',
    maxAge: const Duration(minutes: 2),
    fetch: () => guard(() async {
      final response = await dio.get<Map<String, dynamic>>('/me');
      final data = objectData(response.data);
      return UserDto(
        id: data['id'] as String,
        email: data['email'] as String,
        displayName: data['displayName'] as String,
        level: _levelNumber(data['levelCode'] as String?),
        exp: data['totalExp'] as int? ?? 0,
        coins: data['coins'] as int? ?? 0,
        streakDays: data['streakDays'] as int? ?? 0,
        mascotForm: data['mascotForm'] as String? ?? 'scout',
        onboardingComplete: data['onboardingComplete'] as bool? ?? false,
      );
    }),
    encode: (value) => value.toJson(),
    decode: (value) =>
        UserDto.fromJson(Map<String, dynamic>.from(value as Map)),
  );

  int _levelNumber(String? levelCode) => switch (levelCode) {
    'beginner' => 1,
    'intermediate' => 2,
    'advanced' => 3,
    'professional' => 4,
    'master' => 5,
    _ => 1,
  };
}

class RemoteBadgeRepository extends RemoteRepositoryBase
    implements BadgeRepository {
  const RemoteBadgeRepository(super.dio, {super.cache});

  @override
  Future<List<BadgeDto>> getBadges() => cachedRead<List<BadgeDto>>(
    key: 'badges',
    maxAge: const Duration(minutes: 10),
    fetch: () => guard(() async {
      final response = await dio.get<Map<String, dynamic>>('/badges');
      return listData(response.data)
          .map(
            (item) => BadgeDto.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false);
    }),
    encode: (value) => value.map((item) => item.toJson()).toList(),
    decode: (value) => (value as List)
        .map(
          (item) => BadgeDto.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false),
  );
}
