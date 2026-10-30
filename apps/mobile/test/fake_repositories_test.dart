import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/features/auth/data/fake_auth_repository.dart';
import 'package:milestracks/features/profile/data/fake_profile_repository.dart';
import 'package:milestracks/features/run/data/fake_run_repository.dart';
import 'package:milestracks/features/track/data/fake_track_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

void main() {
  late FakeRepositoryBehavior behavior;
  late FakeDataStore store;
  var languageCode = 'en';

  setUp(() {
    behavior = FakeRepositoryBehavior(networkDelay: Duration.zero);
    languageCode = 'en';
    store = FakeDataStore(languageCode: () => languageCode);
  });

  test('fake data provides English and Indonesian mascot narratives', () async {
    final tracks = FakeTrackRepository(behavior, store);
    final english = await tracks.createTrack(
      const CreateTrackRequestDto(
        location: TrackStartLocationDto(latitude: 0, longitude: 0),
      ),
    );
    expect(english.narrative.trackTitle, 'Morning Trail Beyond the Old Trees');

    languageCode = 'id';
    final indonesian = await tracks.getTrack(english.id);
    expect(
      indonesian.narrative.trackTitle,
      'Jalur Pagi di Balik Pepohonan Tua',
    );
    expect(
      indonesian.narrative.milestoneDialogues.single.restPrompt,
      contains('Beristirahat'),
    );
  });

  test(
    'fake repositories produce Track Failed and Rejected/SafeStopped runs',
    () async {
      final tracks = FakeTrackRepository(behavior, store);
      behavior.trackGenerationFails = true;
      expect(
        (await tracks.createTrack(
          const CreateTrackRequestDto(
            location: TrackStartLocationDto(latitude: 0, longitude: 0),
          ),
        )).status,
        TrackStatus.failed,
      );

      final runs = FakeRunRepository(behavior, store);
      final run = await runs.startRun(
        const StartRunRequestDto(trackId: 'track-fog-001'),
      );
      behavior.runFinishOutcome = FakeRunOutcome.rejected;
      final rejected = await runs.finishRun(
        run.id,
        const FinishRunRequestDto(remainingPoints: <RunPointDto>[]),
      );
      expect(rejected.status, RunStatus.rejected);

      final safeStopped = await runs.safeStopRun(
        run.id,
        const SafeStopRequestDto(reasonCode: 'user_request'),
      );
      expect(safeStopped.status, RunStatus.safeStopped);
    },
  );

  test('fake behavior can simulate 401, 500, and timeout failures', () async {
    final auth = FakeAuthRepository(behavior, store);
    behavior.failNext('auth.login', FakeFailure.unauthorized);
    await expectLater(
      auth.login(
        const CredentialsRequestDto(
          email: 'runner@example.test',
          password: 'secret',
        ),
      ),
      throwsA(
        isA<AppException>().having(
          (error) => error.statusCode,
          'statusCode',
          401,
        ),
      ),
    );

    final profile = FakeProfileRepository(behavior, store);
    behavior.failNext('profile.get', FakeFailure.serverError);
    await expectLater(
      profile.getProfile(),
      throwsA(
        isA<AppException>().having(
          (error) => error.statusCode,
          'statusCode',
          500,
        ),
      ),
    );
    behavior.failNext('profile.get', FakeFailure.timeout);
    await expectLater(
      profile.getProfile(),
      throwsA(
        isA<AppException>().having(
          (error) => error.kind,
          'kind',
          AppExceptionKind.timeout,
        ),
      ),
    );
  });
}
