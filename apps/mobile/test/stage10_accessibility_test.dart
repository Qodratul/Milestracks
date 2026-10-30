import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final locale in <String>['en', 'id']) {
    testWidgets('bottom navigation exposes localized 48dp targets ($locale)', (
      tester,
    ) async {
      final semanticsHandle = tester.ensureSemantics();
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final router = GoRouter(
        initialLocation: '/home',
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            builder: (context, state) => const _NavigationTestScreen(),
          ),
          for (final destination in <String>[
            'history',
            'shop',
            'generating',
            'league',
            'friends',
            'profile',
          ])
            GoRoute(
              path: '/$destination',
              builder: (context, state) => const _NavigationTestScreen(),
            ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          locale: Locale(locale),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: MilestracksTheme.light,
        ),
      );
      await tester.pumpAndSettle();

      final strings = lookupAppLocalizations(Locale(locale));
      final labels = <String>[
        strings.navHome,
        strings.navHistory,
        strings.navShop,
        strings.navRun,
        strings.navLeague,
        strings.navFriends,
        strings.navProfile,
      ];
      for (final label in labels) {
        final itemSemantics = find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == label,
        );
        expect(itemSemantics, findsOneWidget, reason: label);
        final node = tester.getSemantics(itemSemantics);
        expect(node.rect.width, greaterThanOrEqualTo(48), reason: label);
        expect(node.rect.height, greaterThanOrEqualTo(48), reason: label);
        expect(
          node.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
          reason: label,
        );
      }
      semanticsHandle.dispose();
    });
  }
}

class _NavigationTestScreen extends StatelessWidget {
  const _NavigationTestScreen();

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SizedBox.expand(),
    bottomNavigationBar: MilestracksBottomNavigation(
      selected: MainDestination.home,
    ),
  );
}
