import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/features/history/domain/history_dashboard_preview.dart';
import 'package:milestracks/features/history/presentation/history_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

part 'history_top_bar.part.dart';
part 'history_content.part.dart';
part 'history_hero.part.dart';
part 'history_run_card.part.dart';
part 'history_components.part.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final history = ref.watch(runHistoryControllerProvider);
    return Theme(
      data: MilestracksTheme.light,
      child: Builder(
        builder: (context) {
          final lightTokens = context.milestracksTokens;
          return Scaffold(
            backgroundColor: MilestracksTokens.homeBackgroundBottom,
            body: DecoratedBox(
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
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: lightTokens.pageMaxWidth,
                    ),
                    child: Column(
                      children: <Widget>[
                        _HistoryTopBar(
                          brand: strings.historyBrand,
                          title: strings.historyTitle,
                        ),
                        Expanded(
                          child: history.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (_, _) => _HistoryError(
                              message: strings.historyError,
                              action: strings.historyRetry,
                              onPressed: () => unawaited(
                                ref
                                    .read(runHistoryControllerProvider.notifier)
                                    .refresh(),
                              ),
                            ),
                            data: (page) => _HistoryContent(
                              runs: page.runs,
                              nextCursor: page.nextCursor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: showBottomNavigation
                ? const MilestracksBottomNavigation(
                    selected: MainDestination.history,
                    homeStyle: true,
                  )
                : null,
          );
        },
      ),
    );
  }
}
