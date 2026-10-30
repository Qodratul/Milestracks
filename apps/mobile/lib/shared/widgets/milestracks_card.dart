import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';

class MilestracksCard extends StatelessWidget {
  const MilestracksCard({
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final card = Container(
      padding: padding ?? EdgeInsets.all(tokens.space16),
      decoration: BoxDecoration(
        color: color ?? tokens.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? tokens.radiusCard),
        border: Border.all(color: tokens.hairline),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.shadow,
            blurRadius: tokens.shadowBlur,
            offset: Offset(0, tokens.shadowOffsetY),
          ),
        ],
      ),
      child: child,
    );

    return semanticLabel == null
        ? card
        : Semantics(label: semanticLabel, child: card);
  }
}
