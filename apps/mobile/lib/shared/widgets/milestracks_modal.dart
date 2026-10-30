import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';

class MilestracksModal extends StatelessWidget {
  const MilestracksModal({
    required this.child,
    required this.onClose,
    required this.barrierSemanticsLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback onClose;
  final String barrierSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final media = MediaQuery.of(context);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Semantics(
              button: true,
              label: barrierSemanticsLabel,
              child: GestureDetector(
                onTap: onClose,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ColoredBox(color: tokens.scrim),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: tokens.pageMaxWidth,
                  maxHeight: media.size.height * .88,
                ),
                child: SizedBox(
                  width: math.min(tokens.pageMaxWidth, media.size.width),
                  child: Semantics(
                    container: true,
                    scopesRoute: true,
                    explicitChildNodes: true,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: tokens.slate,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(tokens.radiusSheet),
                        ),
                        border: Border.all(color: tokens.hairline),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: tokens.voidColor.withValues(alpha: .5),
                            blurRadius: tokens.shadowBlur * 2,
                            offset: Offset(0, -tokens.space16),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          tokens.pagePadding,
                          tokens.space10,
                          tokens.pagePadding,
                          media.padding.bottom > tokens.space24
                              ? media.padding.bottom
                              : tokens.space24,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ExcludeSemantics(
                              child: Container(
                                width: tokens.modalGrabberWidth,
                                height: tokens.space4,
                                margin: EdgeInsets.only(bottom: tokens.space20),
                                decoration: BoxDecoration(
                                  color: tokens.mist.withValues(alpha: .26),
                                  borderRadius: BorderRadius.circular(
                                    tokens.radiusSmall,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: SingleChildScrollView(child: child),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
