import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/storage/secure_storage_service.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/friends/presentation/friends_screen.dart';
import 'package:milestracks/features/history/presentation/history_screen.dart';
import 'package:milestracks/features/league/presentation/league_screen.dart';
import 'package:milestracks/features/profile/presentation/profile_screen.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/features/settings/presentation/settings_screen.dart';
import 'package:milestracks/features/shop/presentation/shop_screen.dart';
import 'package:milestracks/features/streak/presentation/streak_screen.dart';
import 'package:milestracks/l10n/app_localizations.dart';

Future<void>? _fonts;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final screens = <(String, Widget Function())>[
    ('history', () => const HistoryScreen()),
    ('shop', () => const ShopScreen()),
    ('profile', () => const ProfileScreen()),
    ('settings', () => const SettingsScreen()),
    ('streak', () => const StreakScreen()),
    ('league', () => const LeagueScreen()),
    ('friends', () => const FriendsScreen()),
  ];
  for (final locale in <String>['en', 'id']) {
    for (final entry in screens) {
      testWidgets('${entry.$1} layout golden ($locale)', (tester) async {
        await tester.runAsync(() => _fonts ??= _loadFonts());
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final storage = MemorySecureStorageService();
        await storage.write(SecureStorageKeys.appLanguage, locale);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              fakeRepositoryBehaviorProvider.overrideWith(
                (ref) => FakeRepositoryBehavior(),
              ),
              secureStorageProvider.overrideWithValue(storage),
            ],
            child: _TestLocalizedApp(screen: entry.$2()),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(entry.$2().runtimeType),
          matchesGoldenFile('goldens/stage8_${entry.$1}_$locale.png'),
        );
      });
    }
  }
}

class _TestLocalizedApp extends ConsumerWidget {
  const _TestLocalizedApp({required this.screen});
  final Widget screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageControllerProvider);
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!,
      ),
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: MilestracksTheme.light,
      home: screen,
    );
  }
}

Future<void> _loadFonts() async {
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
      final icons = FontLoader('MaterialIcons')
        ..addFont(
          candidate.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)),
        );
      await icons.load();
      break;
    }
    directory = directory.parent;
  }
}
