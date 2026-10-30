import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/auth/presentation/auth_screen.dart';
import 'package:milestracks/features/auth/presentation/welcome_screen.dart';
import 'package:milestracks/features/onboarding/presentation/onboarding_screens.dart';
import 'package:milestracks/features/onboarding/presentation/permission_controller.dart';
import 'package:milestracks/l10n/app_localizations.dart';

Future<void>? _fontLoad;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in <String>['en', 'id']) {
    testWidgets('welcome and auth layout golden ($locale)', (tester) async {
      await tester.runAsync(() => _fontLoad ??= _loadFont());
      await _setViewport(tester);
      await _pump(tester, locale, const WelcomeScreen());
      await expectLater(
        find.byType(WelcomeScreen),
        matchesGoldenFile('goldens/auth_welcome_$locale.png'),
      );

      await _pump(tester, locale, const AuthScreen(initialSignUp: false));
      await expectLater(
        find.byType(AuthScreen),
        matchesGoldenFile('goldens/auth_sign_in_$locale.png'),
      );

      await _pump(tester, locale, const AuthScreen(initialSignUp: true));
      await expectLater(
        find.byType(AuthScreen),
        matchesGoldenFile('goldens/auth_sign_up_$locale.png'),
      );
    });

    testWidgets('readiness and permissions layout golden ($locale)', (
      tester,
    ) async {
      await tester.runAsync(() => _fontLoad ??= _loadFont());
      await _setViewport(tester);
      await _pump(tester, locale, const ReadinessScreen());
      await expectLater(
        find.byType(ReadinessScreen),
        matchesGoldenFile('goldens/onboarding_readiness_$locale.png'),
      );

      await _pumpPermissions(tester, locale);
      await expectLater(
        find.byType(PermissionsScreen),
        matchesGoldenFile('goldens/onboarding_permissions_$locale.png'),
      );
    });
  }

  testWidgets('Indonesian auth and onboarding fit a compact 360dp screen', (
    tester,
  ) async {
    await tester.runAsync(() => _fontLoad ??= _loadFont());
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await _pump(tester, 'id', const AuthScreen(initialSignUp: true));
    expect(tester.takeException(), isNull);
    await _pump(tester, 'id', const ReadinessScreen());
    expect(tester.takeException(), isNull);
    await _pumpPermissions(tester, 'id');
    expect(tester.takeException(), isNull);
  });
}

Future<void> _loadFont() async {
  final loader = FontLoader('PlusJakartaSans')
    ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-variable.ttf'));
  await loader.load();
  final iconFont = _materialIconsFont();
  if (iconFont != null) {
    final iconLoader = FontLoader('MaterialIcons')
      ..addFont(
        iconFont.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
      );
    await iconLoader.load();
  }
}

File? _materialIconsFont() {
  var directory = File(Platform.resolvedExecutable).parent;
  while (directory.path != directory.parent.path) {
    final candidate = File(
      '${directory.path}${Platform.pathSeparator}bin${Platform.pathSeparator}'
      'cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}'
      'material_fonts${Platform.pathSeparator}MaterialIcons-Regular.otf',
    );
    if (candidate.existsSync()) return candidate;
    directory = directory.parent;
  }
  return null;
}

Future<void> _setViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pump(WidgetTester tester, String language, Widget screen) async {
  final storage = MemorySecureStorageService();
  await storage.write(SecureStorageKeys.appLanguage, language);
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [secureStorageProvider.overrideWithValue(storage)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: MilestracksTheme.light,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpPermissions(WidgetTester tester, String language) async {
  final storage = MemorySecureStorageService();
  await storage.write(SecureStorageKeys.appLanguage, language);
  await tester.pumpWidget(
    ProviderScope(
      key: UniqueKey(),
      overrides: [
        secureStorageProvider.overrideWithValue(storage),
        permissionControllerProvider.overrideWith(
          _FakePermissionController.new,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale(language),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        theme: MilestracksTheme.light,
        home: const PermissionsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FakePermissionController extends PermissionController {
  @override
  Future<OnboardingPermissionState> build() async =>
      (location: false, notifications: false);

  @override
  Future<void> refreshStatus() async {}
}
