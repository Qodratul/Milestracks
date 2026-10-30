import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/config/app_config.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/features/history/presentation/history_providers.dart';
import 'package:milestracks/features/home/domain/home_dashboard_preview.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';
import 'package:milestracks/shared/widgets/milestracks_map.dart';

part 'home_sponsored_card.part.dart';
part 'home_route_widgets.part.dart';
part 'home_streak_panel.part.dart';
part 'home_league_card.part.dart';
part 'home_kila_bubble.part.dart';
part 'home_intro_block.part.dart';
part 'home_daily_status.part.dart';
part 'home_fixed_header.part.dart';
part 'home_weekly_exp_card.part.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: MilestracksTheme.light,
      child: Builder(
        builder: (context) {
          final tokens = context.milestracksTokens;
          final user = ref.watch(currentUserProvider);
          final streak = ref.watch(currentStreakProvider);
          final track = ref.watch(todayMysteryTrackProvider);
          return Scaffold(
            backgroundColor: MilestracksTokens.homeBackgroundBottom,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    MilestracksTokens.homeBackgroundTop,
                    MilestracksTokens.homeBackgroundBottom,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: <Widget>[
                    _FixedHomeHeader(
                      displayName: user.value?.displayName ?? 'Rani',
                      coins: user.value?.coins ?? 0,
                      onProfile: () => context.go('/profile'),
                      onNotifications: () => context.go('/notifications'),
                      onWallet: () => context.go('/shop'),
                    ),
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: tokens.pageMaxWidth,
                              ),
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  SliverPadding(
                                    padding: EdgeInsets.fromLTRB(
                                      tokens.pagePadding,
                                      15,
                                      tokens.pagePadding,
                                      120,
                                    ),
                                    sliver: SliverList.list(
                                      children: <Widget>[
                                        const _IntroBlock(),
                                        const SizedBox(height: 16),
                                        _RouteHeading(),
                                        const SizedBox(height: 10),
                                        _RouteCard(
                                          track: track,
                                          isDemo: AppConfig.useFakeApi,
                                          onOpen: (id) =>
                                              context.go('/prepare/$id'),
                                        ),
                                        const SizedBox(height: 20),
                                        if (AppConfig.useFakeApi)
                                          const _DailyStatusCard(),
                                        const SizedBox(height: 20),
                                        streak.when(
                                          data: (value) => _StreakPanel(
                                            days: value.currentDays,
                                            bestDays: value.bestDays,
                                            freezes: value.freezesRemaining,
                                            showDemoPrice: AppConfig.useFakeApi,
                                          ),
                                          error: (_, _) =>
                                              const SizedBox.shrink(),
                                          loading: () =>
                                              const _HomeLoadingCard(),
                                        ),
                                        const SizedBox(height: 18),
                                        if (AppConfig.useFakeApi)
                                          const _WeeklyExpCard(),
                                        const SizedBox(height: 12),
                                        if (AppConfig.useFakeApi)
                                          const _LeagueCard(),
                                        const SizedBox(height: 20),
                                        _SponsoredCard(
                                          onExplore: () =>
                                              context.go('/generating'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.sizeOf(context).width <= 360
                                ? 8
                                : 12,
                            right: MediaQuery.sizeOf(context).width <= 360
                                ? 8
                                : 12,
                            bottom: 8,
                            child: Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 402,
                                ),
                                child: track.when(
                                  data: (value) => _KilaBubble(
                                    note: value.narrative.preRunTip,
                                    safetyScore:
                                        HomeDashboardPreview.safetyScore,
                                    showDemoScore: AppConfig.useFakeApi,
                                  ),
                                  error: (_, _) => const SizedBox.shrink(),
                                  loading: () => const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: showBottomNavigation
                ? const MilestracksBottomNavigation(
                    selected: MainDestination.home,
                    homeStyle: true,
                  )
                : null,
          );
        },
      ),
    );
  }
}
