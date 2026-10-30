import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/home/presentation/home_screen.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';

Future<void>? _fontLoad;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in <String>['en', 'id']) {
    testWidgets('home layout golden ($locale)', (tester) async {
      await tester.runAsync(() => _fontLoad ??= _loadFont());
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith(
              (ref) async => const UserDto(
                id: 'golden-user',
                email: 'runner@example.test',
                displayName: 'Rani Runner',
                level: 3,
                exp: 1840,
                coins: 128,
                streakDays: 4,
                mascotForm: 'scout',
                onboardingComplete: true,
              ),
            ),
            currentStreakProvider.overrideWith(
              (ref) async => const StreakDto(
                currentDays: 4,
                bestDays: 9,
                freezesRemaining: 1,
                restShieldActive: false,
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: MilestracksTheme.light,
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_$locale.png'),
      );
    });
  }
}

Future<void> _loadFont() async {
  final loader = FontLoader('PlusJakartaSans')
    ..addFont(rootBundle.load('assets/fonts/PlusJakartaSans-variable.ttf'));
  await loader.load();
  var directory = File(Platform.resolvedExecutable).parent;
  while (directory.path != directory.parent.path) {
    final candidate = File(
      '${directory.path}${Platform.pathSeparator}bin${Platform.pathSeparator}'
      'cache${Platform.pathSeparator}artifacts${Platform.pathSeparator}'
      'material_fonts${Platform.pathSeparator}MaterialIcons-Regular.otf',
    );
    if (candidate.existsSync()) {
      final iconLoader = FontLoader('MaterialIcons')
        ..addFont(
          candidate.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
        );
      await iconLoader.load();
      break;
    }
    directory = directory.parent;
  }
}
