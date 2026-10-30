import 'package:milestracks/shared/models/api_models.dart';

abstract interface class OnboardingRepository {
  Future<OnboardingResponseDto> saveOnboarding(OnboardingRequestDto request);
  Future<void> updateLanguage(String languageCode);
}
