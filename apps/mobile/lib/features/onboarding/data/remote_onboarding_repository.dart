import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/features/onboarding/domain/onboarding_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteOnboardingRepository extends RemoteRepositoryBase
    implements OnboardingRepository {
  const RemoteOnboardingRepository(super.dio, {super.cache});

  @override
  Future<OnboardingResponseDto> saveOnboarding(OnboardingRequestDto request) =>
      guard(() async {
        final response = await dio.patch<Map<String, dynamic>>(
          '/me/onboarding',
          data: request.toJson(),
        );
        await invalidateCache('profile');
        return OnboardingResponseDto.fromJson(objectData(response.data));
      });

  @override
  Future<void> updateLanguage(String languageCode) => guard(() async {
    await dio.patch<Map<String, dynamic>>(
      '/me/onboarding',
      data: <String, String>{'locale': languageCode},
    );
    await invalidateCache('profile');
  });
}
