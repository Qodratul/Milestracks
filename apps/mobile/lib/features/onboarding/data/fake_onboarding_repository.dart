import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/features/onboarding/domain/onboarding_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  const FakeOnboardingRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<OnboardingResponseDto> saveOnboarding(OnboardingRequestDto request) =>
      behavior.execute('onboarding.save', () {
        store.user = store.user.copyWith(onboardingComplete: true);
        return OnboardingResponseDto(
          onboardingComplete: true,
          locale: request.locale ?? 'en',
          timezone: request.timezone ?? 'UTC',
        );
      });

  @override
  Future<void> updateLanguage(String languageCode) =>
      behavior.execute('onboarding.updateLanguage', () {});
}
