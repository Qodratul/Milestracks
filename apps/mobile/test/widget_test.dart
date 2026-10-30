// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/main.dart';

void main() {
  testWidgets('router guards welcome, onboarding, and home routes', (
    tester,
  ) async {
    final storage = MemorySecureStorageService();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MilestracksApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Every step has a story.'), findsOneWidget);

    await container
        .read(sessionControllerProvider.notifier)
        .establishSession(accessToken: 'access', refreshToken: 'refresh');
    await tester.pumpAndSettle();
    expect(find.text('Ready to run?'), findsOneWidget);

    await container.read(onboardingControllerProvider.notifier).markComplete();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('email sign-up establishes session and opens safety onboarding', (
    tester,
  ) async {
    const deviceChannel = MethodChannel('com.milestracks/device');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(deviceChannel, (call) async => 'UTC');
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(deviceChannel, null),
    );
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final storage = MemorySecureStorageService();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MilestracksApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign up with Email'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'runner@example.test',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'strong-pass-123');
    await tester.enterText(find.byType(TextFormField).at(2), 'Taylor Runner');
    await tester.ensureVisible(find.text('Create Account'));
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(container.read(sessionControllerProvider), isTrue);
    expect(find.text('Ready to run?'), findsOneWidget);
    expect(
      await storage.read(SecureStorageKeys.accessToken),
      'fake-access-token',
    );
  });

  testWidgets('welcome screen follows selected Indonesian locale', (
    tester,
  ) async {
    final storage = MemorySecureStorageService();
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        fakeRepositoryBehaviorProvider.overrideWith(
          (ref) => FakeRepositoryBehavior(networkDelay: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);
    await container.read(languageControllerProvider.notifier).setLanguage('id');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MilestracksApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Setiap langkah punya cerita.'), findsOneWidget);
    expect(find.text('Daftar dengan Email'), findsOneWidget);
  });

  test('language starts in English and persists the selected locale', () async {
    final storage = MemorySecureStorageService();
    final container = ProviderContainer(
      overrides: [secureStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    expect(container.read(languageControllerProvider).languageCode, 'en');
    await container.read(languageControllerProvider.notifier).setLanguage('id');
    expect(container.read(languageControllerProvider).languageCode, 'id');
    expect(await storage.read(SecureStorageKeys.appLanguage), 'id');
  });
}
