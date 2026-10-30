import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';

enum MilestracksButtonVariant { primary, secondary, text }

class MilestracksButton extends StatelessWidget {
  const MilestracksButton({
    required this.child,
    required this.onPressed,
    this.variant = MilestracksButtonVariant.primary,
    this.semanticLabel,
    this.primaryBackground,
    this.primaryForeground,
    this.primaryRadius,
    this.secondaryBackground,
    this.secondaryForeground,
    this.secondaryBorder,
    this.secondaryRadius,
    this.minimumHeight,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final MilestracksButtonVariant variant;
  final String? semanticLabel;
  final Color? primaryBackground;
  final Color? primaryForeground;
  final double? primaryRadius;
  final Color? secondaryBackground;
  final Color? secondaryForeground;
  final Color? secondaryBorder;
  final double? secondaryRadius;
  final double? minimumHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tokens.radiusPill),
    );
    final Widget button = switch (variant) {
      MilestracksButtonVariant.primary => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: primaryBackground ?? tokens.primary,
          foregroundColor: primaryForeground ?? tokens.surface,
          disabledBackgroundColor: tokens.disabledBackground,
          disabledForegroundColor: tokens.disabledForeground,
          minimumSize: Size(0, tokens.buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: tokens.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              primaryRadius ?? tokens.radiusPill,
            ),
          ),
          textStyle: theme.textTheme.labelLarge,
        ),
        child: child,
      ),
      MilestracksButtonVariant.secondary => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: secondaryBackground,
          foregroundColor:
              secondaryForeground ??
              (tokens.isDark ? tokens.mist : tokens.slate),
          disabledForegroundColor: tokens.disabledForeground,
          minimumSize: Size(0, minimumHeight ?? tokens.buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: tokens.space16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              secondaryRadius ?? tokens.radiusPill,
            ),
          ),
          side: BorderSide(
            color: secondaryBorder ?? tokens.secondaryButtonBorder,
            width: secondaryBorder == Colors.transparent ? 0 : 1,
          ),
          textStyle: theme.textTheme.labelLarge,
        ),
        child: child,
      ),
      MilestracksButtonVariant.text => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: tokens.muted,
          disabledForegroundColor: tokens.disabledForeground,
          minimumSize: Size(0, tokens.textButtonHeight),
          padding: EdgeInsets.symmetric(horizontal: tokens.space12),
          shape: shape,
          textStyle: theme.textTheme.labelMedium,
        ),
        child: child,
      ),
    };
    final minHeight = variant == MilestracksButtonVariant.text
        ? tokens.minimumTapTarget
        : minimumHeight ?? tokens.buttonHeight;

    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: MergeSemantics(
          child: Semantics(
            button: true,
            enabled: onPressed != null,
            label: semanticLabel,
            child: button,
          ),
        ),
      ),
    );
  }
}
