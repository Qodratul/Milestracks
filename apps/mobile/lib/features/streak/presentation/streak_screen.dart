import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/feature_page_scaffold.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final streak = ref.watch(currentStreakProvider);
    return FeaturePageScaffold(
      title: strings.streakTitle,
      destination: MainDestination.profile,
      body: streak.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(strings.streakError)),
        data: (value) => ListView(
          padding: EdgeInsets.all(context.milestracksTokens.pagePadding),
          children: <Widget>[
            MilestracksCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.local_fire_department,
                    color: context.milestracksTokens.accent,
                    size: 34,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.streakCurrent,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    NumberFormat.decimalPattern(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(value.currentDays),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            MilestracksCard(
              child: Column(
                children: <Widget>[
                  _StreakMetric(
                    icon: Icons.emoji_events_outlined,
                    label: strings.streakBest,
                    value: value.bestDays,
                  ),
                  const Divider(),
                  _StreakMetric(
                    icon: Icons.ac_unit,
                    label: strings.streakFreezes,
                    value: value.freezesRemaining,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            MilestracksCard(
              child: Row(
                children: <Widget>[
                  Icon(
                    value.restShieldActive
                        ? Icons.shield
                        : Icons.shield_outlined,
                    color: value.restShieldActive
                        ? context.milestracksTokens.success
                        : context.milestracksTokens.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value.restShieldActive
                          ? strings.streakShieldActive
                          : strings.streakShieldInactive,
                    ),
                  ),
                ],
              ),
            ),
            if (value.lastQualifiedAt != null) ...<Widget>[
              const SizedBox(height: 12),
              MilestracksCard(
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                    Expanded(child: Text(strings.streakLastQualified)),
                    Text(
                      DateFormat.yMMMd(
                        Localizations.localeOf(context).toLanguageTag(),
                      ).format(value.lastQualifiedAt!.toLocal()),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => context.go('/shop'),
              icon: const Icon(Icons.storefront_outlined),
              label: Text(strings.streakShop),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakMetric extends StatelessWidget {
  const _StreakMetric({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: <Widget>[
        Icon(icon, color: context.milestracksTokens.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          NumberFormat.decimalPattern(
            Localizations.localeOf(context).toLanguageTag(),
          ).format(value),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}
