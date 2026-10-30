import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';

enum MilestracksBadgeStyle { accent, neutral, success }

class MilestracksBadge extends StatelessWidget {
  const MilestracksBadge({
    required this.label,
    this.style = MilestracksBadgeStyle.accent,
    super.key,
  });

  final String label;
  final MilestracksBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final (background, foreground, border) = switch (style) {
      MilestracksBadgeStyle.accent => (
        tokens.sand.withValues(alpha: .12),
        tokens.isDark ? tokens.sand : tokens.umber,
        tokens.sand.withValues(alpha: .38),
      ),
      MilestracksBadgeStyle.neutral => (
        tokens.card,
        tokens.textSecondary,
        tokens.hairline,
      ),
      MilestracksBadgeStyle.success => (
        tokens.success.withValues(alpha: .12),
        tokens.success,
        tokens.success.withValues(alpha: .28),
      ),
    };

    return Container(
      constraints: BoxConstraints(minHeight: tokens.space28),
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space12,
        vertical: tokens.space6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(tokens.radiusPill),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium
            ?.copyWith(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }
}
