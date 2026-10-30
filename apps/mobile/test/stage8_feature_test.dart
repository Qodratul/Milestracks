import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/history/presentation/history_screen.dart';
import 'package:milestracks/features/shop/presentation/shop_screen.dart';
import 'package:milestracks/l10n/app_localizations.dart';

Widget _harness(Widget screen) => ProviderScope(
  overrides: [
    fakeRepositoryBehaviorProvider.overrideWith(
      (ref) => FakeRepositoryBehavior(networkDelay: Duration.zero),
    ),
  ],
  child: MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: MilestracksTheme.light,
    home: screen,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('run history loads the next cursor page', (tester) async {
    await tester.pumpWidget(_harness(const HistoryScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Oct 5, 2026'), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Load more'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Load more'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('Oct 5, 2026'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Oct 5, 2026'), findsOneWidget);
    expect(find.text('Canal-side Route'), findsAtLeastNWidgets(1));
  });

  testWidgets('shop purchase updates the displayed coin balance', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(const ShopScreen()));
    await tester.pumpAndSettle();
    expect(find.text('128'), findsOneWidget);
    await tester.tap(find.byType(FilledButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buy').last);
    await tester.pumpAndSettle();
    expect(find.text('98'), findsOneWidget);
    expect(find.text('Item added to your inventory.'), findsOneWidget);
    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    expect(find.text('Owned: 2'), findsOneWidget);
    await tester.tap(find.text('Coin history'));
    await tester.pumpAndSettle();
    expect(find.text('Shop purchase'), findsOneWidget);
  });
}
