import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/shared/widgets/coming_soon_view.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_badge.dart';
import 'package:milestracks/shared/widgets/milestracks_button.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';
import 'package:milestracks/shared/widgets/milestracks_modal.dart';

const _goldenSize = Size(390, 844);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('shared components match the light design tokens', (
    tester,
  ) async {
    await _setViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: MilestracksTheme.light,
        home: const Scaffold(body: _ComponentShowcase()),
      ),
    );

    await expectLater(
      find.byType(_ComponentShowcase),
      matchesGoldenFile('goldens/shared_components_light.png'),
    );
  });

  testWidgets('shared components match the dark design tokens', (tester) async {
    await _setViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: MilestracksTheme.dark,
        home: const Scaffold(body: _ComponentShowcase()),
      ),
    );

    await expectLater(
      find.byType(_ComponentShowcase),
      matchesGoldenFile('goldens/shared_components_dark.png'),
    );
  });

  testWidgets('League placeholder shows an English coming soon overlay', (
    tester,
  ) async {
    await _setViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: MilestracksTheme.light,
        builder: _reducedMotionBuilder,
        home: const Scaffold(
          body: ComingSoonView(
            kind: ComingSoonKind.league,
            title: 'Coming soon',
            description: 'Weekly running rankings are on their way.',
            semanticsLabel:
                'Coming soon. Weekly running rankings are on their way.',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(ComingSoonView),
      matchesGoldenFile('goldens/coming_soon_league_en.png'),
    );
  });

  testWidgets('Friends placeholder fits longer Indonesian copy', (
    tester,
  ) async {
    await _setViewport(tester, size: const Size(360, 800));
    await tester.pumpWidget(
      MaterialApp(
        theme: MilestracksTheme.light,
        builder: _reducedMotionBuilder,
        home: const Scaffold(
          body: ComingSoonView(
            kind: ComingSoonKind.friends,
            title: 'Segera hadir',
            description: 'Temukan teman lari dan saling memberi semangat dalam perjalanan.',
            semanticsLabel: 'Segera hadir. Temukan teman lari dan saling memberi semangat dalam perjalanan.',
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(ComingSoonView),
      matchesGoldenFile('goldens/coming_soon_friends_id.png'),
    );
  });

  testWidgets('modal sheet matches the React sheet geometry', (tester) async {
    await _setViewport(tester);
    await tester.pumpWidget(
      MaterialApp(
        theme: MilestracksTheme.dark,
        home: Scaffold(
          body: MilestracksModal(
            onClose: () {},
            barrierSemanticsLabel: 'Close dialog',
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('A modal title'),
                SizedBox(height: 12),
                Text('Modal copy supplied by the caller.'),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MilestracksModal),
      matchesGoldenFile('goldens/modal_sheet.png'),
    );
  });
}

Future<void> _setViewport(
  WidgetTester tester, {
  Size size = _goldenSize,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget _reducedMotionBuilder(BuildContext context, Widget? child) => MediaQuery(
  data: MediaQuery.of(context).copyWith(disableAnimations: true),
  child: child!,
);

class _ComponentShowcase extends StatelessWidget {
  const _ComponentShowcase();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Milestracks',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 20),
            const MilestracksButton(
              onPressed: null,
              child: Text('Primary action'),
            ),
            const SizedBox(height: 10),
            const MilestracksButton(
              onPressed: null,
              variant: MilestracksButtonVariant.secondary,
              child: Text('Secondary action'),
            ),
            const SizedBox(height: 4),
            const MilestracksButton(
              onPressed: null,
              variant: MilestracksButtonVariant.text,
              child: Text('Text action'),
            ),
            const SizedBox(height: 16),
            MilestracksCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Progress card',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reusable surface with the extracted card treatment.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const MilestracksBadge(label: 'LEVEL 1'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: KilaMascot(mood: KilaMood.scout)),
          ],
        ),
      ),
    );
  }
}
