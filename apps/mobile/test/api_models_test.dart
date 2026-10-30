import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/shared/models/api_models.dart';

void main() {
  test('onboarding request serializes selected locale and IANA timezone', () {
    const request = OnboardingRequestDto(
      healthDisclaimerAccepted: true,
      timezone: 'Asia/Jakarta',
      locale: 'id',
    );

    expect(request.toJson(), <String, Object?>{
      'healthDisclaimerAccepted': true,
      'timezone': 'Asia/Jakarta',
      'locale': 'id',
    });
  });

  test('auth response DTO reads the token names specified by the PRD', () {
    final response = AuthTokensDto.fromJson(<String, dynamic>{
      'accessToken': 'access',
      'refreshToken': 'refresh',
      'user': <String, Object?>{
        'id': 'user-1',
        'email': 'runner@example.test',
        'displayName': 'Runner',
        'emailVerified': true,
        'locale': 'id',
      },
      'accessTokenExpiresAt': '2026-10-28T10:15:00Z',
      'emailVerificationRequired': false,
    });

    expect(response.accessToken, 'access');
    expect(response.refreshToken, 'refresh');
    expect(response.user.locale, 'id');
    expect(response.accessTokenExpiresAt, '2026-10-28T10:15:00Z');
  });
}
