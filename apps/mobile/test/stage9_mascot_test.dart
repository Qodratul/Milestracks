import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';

void main() {
  testWidgets('Kila renders every mascot state with reduced motion', (
    tester,
  ) async {
    for (final mood in KilaMood.values) {
      await tester.pumpWidget(
        MaterialApp(
          theme: MilestracksTheme.light,
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(body: KilaMascot(mood: mood)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(CustomPaint),
        findsAtLeastNWidgets(1),
        reason: '$mood',
      );
      expect(
        find.byType(ExcludeSemantics),
        findsAtLeastNWidgets(1),
        reason: '$mood',
      );
    }
  });
}
