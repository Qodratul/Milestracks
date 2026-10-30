import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

enum MainDestination { home, history, shop, run, league, friends, profile }

/// Seven item dock matching the React nav order and visual treatment.
class MilestracksBottomNavigation extends StatelessWidget {
  const MilestracksBottomNavigation({
    required this.selected,
    super.key,
    this.homeStyle = false,
  });

  final MainDestination selected;
  final bool homeStyle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final strings = AppLocalizations.of(context)!;
    final entries = <(MainDestination, String, String, String)>[
      (MainDestination.home, 'home', strings.navHome, '/home'),
      (MainDestination.history, 'history', strings.navHistory, '/history'),
      (MainDestination.shop, 'shop', strings.navShop, '/shop'),
      (MainDestination.run, 'run', strings.navRun, '/generating'),
      (MainDestination.league, 'league', strings.navLeague, '/league'),
      (MainDestination.friends, 'friends', strings.navFriends, '/friends'),
      (MainDestination.profile, 'profile', strings.navProfile, '/profile'),
    ];
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final background = homeStyle
        ? tokens.surface.withValues(alpha: .92)
        : tokens.primary.withValues(alpha: .96);

    // Scaffold.bottomNavigationBar gives a loose vertical constraint. A plain
    // Center expands to the available height there and can consume the body,
    // placing the dock in the middle of a blank screen. Keep this wrapper
    // content-sized and pinned to the bottom.
    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: homeStyle ? 430 : 398),
        child: Container(
          height: (homeStyle ? 74 : 68) + bottomInset,
          margin: homeStyle
              ? EdgeInsets.zero
              : EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: bottomInset > 14 ? bottomInset : 14,
                ),
          padding: EdgeInsets.fromLTRB(
            homeStyle ? 10 : 6,
            homeStyle ? 7 : 6,
            homeStyle ? 10 : 6,
            homeStyle ? (bottomInset > 7 ? bottomInset : 7) : 6,
          ),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: homeStyle
                  ? tokens.border.withValues(alpha: .88)
                  : tokens.surface.withValues(alpha: .14),
            ),
            borderRadius: BorderRadius.circular(homeStyle ? 20 : 34),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: tokens.shadow,
                blurRadius: homeStyle ? 24 : 32,
                offset: Offset(0, homeStyle ? -7 : 12),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: entries
                .map((entry) {
                  final active = entry.$1 == selected;
                  final isRun = entry.$1 == MainDestination.run;
                  final idleColor = homeStyle
                      ? tokens.textMuted
                      : tokens.surface.withValues(alpha: .62);
                  final activeColor = homeStyle
                      ? tokens.primary
                      : tokens.surface;
                  return Expanded(
                    child: Semantics(
                      button: true,
                      label: entry.$3,
                      selected: active,
                      child: InkWell(
                        onTap: () => context.go(entry.$4),
                        borderRadius: BorderRadius.circular(
                          homeStyle ? 14 : 28,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                curve: Curves.easeOutCubic,
                                width: isRun && !homeStyle
                                    ? 58
                                    : isRun
                                    ? 38
                                    : 25,
                                height: isRun && !homeStyle
                                    ? 58
                                    : isRun
                                    ? 38
                                    : 24,
                                decoration: isRun
                                    ? BoxDecoration(
                                        color: homeStyle
                                            ? tokens.primary
                                            : tokens.secondary,
                                        borderRadius: BorderRadius.circular(
                                          homeStyle ? 13 : 99,
                                        ),
                                        border: homeStyle
                                            ? null
                                            : Border.all(
                                                width: 6,
                                                color: tokens.primary,
                                              ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                            color: tokens.shadow,
                                            blurRadius: 18,
                                            offset: const Offset(0, 7),
                                          ),
                                        ],
                                      )
                                    : BoxDecoration(
                                        color: active
                                            ? (homeStyle
                                                  ? tokens.primary.withValues(
                                                      alpha: .07,
                                                    )
                                                  : tokens.surface.withValues(
                                                      alpha: .12,
                                                    ))
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          homeStyle ? 14 : 28,
                                        ),
                                      ),
                                child: Center(
                                  child: IconTheme(
                                    data: IconThemeData(
                                      color: isRun
                                          ? (homeStyle
                                                ? tokens.surface
                                                : tokens.textPrimary)
                                          : active
                                          ? activeColor
                                          : idleColor,
                                    ),
                                    child: MilestracksIcon(entry.$2, size: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                style: TextStyle(
                                  color: active || isRun
                                      ? activeColor
                                      : idleColor,
                                  fontSize: 9,
                                  height: 1,
                                  fontWeight: active || isRun
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                                child: Text(
                                  entry.$3,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ),
    );
  }
}
