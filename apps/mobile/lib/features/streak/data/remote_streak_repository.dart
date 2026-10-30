import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/features/streak/domain/streak_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteStreakRepository extends RemoteRepositoryBase
    implements StreakRepository {
  const RemoteStreakRepository(super.dio, {super.cache});

  @override
  Future<StreakDto> getStreak() => cachedRead<StreakDto>(
    key: 'streak',
    maxAge: const Duration(minutes: 5),
    fetch: () => guard(() async {
      final response = await dio.get<Map<String, dynamic>>('/streak');
      return StreakDto.fromJson(objectData(response.data));
    }),
    encode: (value) => value.toJson(),
    decode: (value) =>
        StreakDto.fromJson(Map<String, dynamic>.from(value as Map)),
  );
}
