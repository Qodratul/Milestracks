import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';

enum ComingSoonKind { league, friends }

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    required this.kind,
    required this.title,
    required this.description,
    required this.semanticsLabel,
    super.key,
  });

  final ComingSoonKind kind;
  final String title;
  final String description;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return ColoredBox(
      color: tokens.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : tokens.pageMaxWidth * 2;
            final availableWidth = constraints.maxWidth.isFinite
                ? math.min(tokens.pageMaxWidth, constraints.maxWidth)
                : tokens.pageMaxWidth;
            final skeleton = _SkeletonList(kind: kind);
            final animatedSkeleton = reduceMotion
                ? skeleton
                : skeleton
                      .animate(
                        onPlay: (controller) {
                          controller.repeat(reverse: true);
                        },
                      )
                      .shimmer(
                        duration: 1800.ms,
                        color: tokens.skeletonHighlight,
                      );

            return SizedBox(
              width: availableWidth,
              height: availableHeight,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: IgnorePointer(child: animatedSkeleton),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(tokens.pagePadding),
                      child: Semantics(
                        container: true,
                        liveRegion: true,
                        label: semanticsLabel,
                        child: ExcludeSemantics(
                          child: MilestracksCard(
                            padding: EdgeInsets.all(tokens.space24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: tokens.buttonHeight,
                                  height: tokens.buttonHeight,
                                  decoration: BoxDecoration(
                                    color: tokens.sand.withValues(alpha: .14),
                                    borderRadius: BorderRadius.circular(
                                      tokens.radiusMedium,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    kind == ComingSoonKind.league
                                        ? Icons.emoji_events_outlined
                                        : Icons.people_outline_rounded,
                                    size: tokens.space24,
                                    color: tokens.isDark
                                        ? tokens.sand
                                        : tokens.umber,
                                  ),
                                ),
                                SizedBox(height: tokens.space16),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                SizedBox(height: tokens.space8),
                                Text(
                                  description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({required this.kind});

  final ComingSoonKind kind;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final isLeague = kind == ComingSoonKind.league;

    return Padding(
      padding: EdgeInsets.all(tokens.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _SkeletonBar(
            width: tokens.pageMaxWidth * .42,
            height: tokens.space10,
          ),
          SizedBox(height: tokens.space10),
          _SkeletonBar(
            width: tokens.pageMaxWidth * .66,
            height: tokens.space20,
          ),
          SizedBox(height: tokens.space24),
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (context, index) =>
                  SizedBox(height: tokens.space10),
              itemBuilder: (context, index) =>
                  _SkeletonRow(index: index, showScore: isLeague),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.index, required this.showScore});

  final int index;
  final bool showScore;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final avatarSize = tokens.space32 + tokens.space8;
    final rowHeight = tokens.space32 * 2 + tokens.space8;

    return Container(
      constraints: BoxConstraints(minHeight: rowHeight),
      padding: EdgeInsets.all(tokens.space12),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusMedium),
        border: Border.all(color: tokens.hairline),
      ),
      child: Row(
        children: <Widget>[
          _SkeletonBar(
            width: avatarSize,
            height: avatarSize,
            radius: tokens.radiusPill,
          ),
          SizedBox(width: tokens.space12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SkeletonBar(
                  width: tokens.pageMaxWidth * (index.isEven ? .36 : .46),
                  height: tokens.space10,
                ),
                SizedBox(height: tokens.space8),
                _SkeletonBar(
                  width: tokens.pageMaxWidth * (index.isEven ? .24 : .3),
                  height: tokens.space8,
                ),
              ],
            ),
          ),
          if (showScore) ...<Widget>[
            SizedBox(width: tokens.space12),
            _SkeletonBar(width: tokens.space32, height: tokens.space12),
          ],
        ],
      ),
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, required this.height, this.radius});

  final double width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tokens.skeleton,
        borderRadius: BorderRadius.circular(radius ?? tokens.radiusPill),
      ),
    );
  }
}
