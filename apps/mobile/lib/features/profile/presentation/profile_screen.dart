import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/features/history/presentation/history_providers.dart';
import 'package:milestracks/features/profile/presentation/profile_providers.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);
    final badges = ref.watch(userBadgesProvider);
    final history = ref.watch(runHistoryControllerProvider);
    final summary = ref.watch(profileRunSummaryProvider);
    final tokens = context.milestracksTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(strings.profileTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton.filledTonal(
              tooltip: strings.profileSettings,
              onPressed: () => context.go('/settings'),
              icon: const Icon(Icons.settings_outlined),
              style: IconButton.styleFrom(
                backgroundColor: tokens.surface,
                foregroundColor: tokens.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                  side: BorderSide(color: tokens.border),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: user.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(strings.profileError)),
              data: (value) => ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                children: <Widget>[
                  _ProfileHeading(strings: strings),
                  const SizedBox(height: 14),
                  _RunnerCard(user: value, strings: strings),
                  const SizedBox(height: 14),
                  _EmailRow(email: value.email, strings: strings),
                  const SizedBox(height: 14),
                  _WalletCard(coins: value.coins, strings: strings),
                  const SizedBox(height: 25),
                  _SectionHeading(
                    eyebrow: strings.profileSummaryEyebrow,
                    title: strings.profileActivityTitle,
                  ),
                  const SizedBox(height: 10),
                  summary.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(22),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => Text(strings.profileHistoryError),
                    data: (runs) => _RunSummary(runs: runs, strings: strings),
                  ),
                  const SizedBox(height: 14),
                  history.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (page) =>
                        _RecentRuns(runs: page.runs, strings: strings),
                  ),
                  const SizedBox(height: 14),
                  _PaymentHistory(strings: strings),
                  const SizedBox(height: 14),
                  badges.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(22),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => Text(strings.profileError),
                    data: (items) =>
                        _Achievements(items: items, strings: strings),
                  ),
                  const SizedBox(height: 14),
                  _KilaCard(strings: strings),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: showBottomNavigation
          ? const MilestracksBottomNavigation(
              selected: MainDestination.profile,
              homeStyle: true,
            )
          : null,
    );
  }
}

class _ProfileHeading extends StatelessWidget {
  const _ProfileHeading({required this.strings});
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _Eyebrow(strings.profileEyebrow),
      const SizedBox(height: 5),
      Text(
        strings.profileJourney,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    ],
  );
}

class _RunnerCard extends StatelessWidget {
  const _RunnerCard({required this.user, required this.strings});
  final UserDto user;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return MilestracksCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 27,
                backgroundColor: MilestracksTokens.homeMapBackground,
                foregroundColor: tokens.success,
                child: Text(
                  user.displayName.characters.first.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _Eyebrow(strings.profileRunnerEyebrow),
                    const SizedBox(height: 4),
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      strings.profileBeginnerRunner,
                      style: Theme.of(context).textTheme.labelMedium
                          ?.copyWith(color: tokens.success),
                    ),
                  ],
                ),
              ),
              _Pill(
                label: strings.profileLevelBadge(number.format(user.level)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  strings.profileExperienceLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                strings.profileExperience(number.format(user.exp)),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          // The API currently exposes the EXP balance but not its level
          // threshold, so show the progress track without inventing a ratio.
          Container(
            height: 7,
            decoration: BoxDecoration(
              color: MilestracksTokens.homeMapBackground,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailRow extends StatelessWidget {
  const _EmailRow({required this.email, required this.strings});
  final String email;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) => MilestracksCard(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    child: Row(
      children: <Widget>[
        const Icon(Icons.person_outline, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(email, style: Theme.of(context).textTheme.labelMedium),
        ),
        Text(
          strings.profileNotVerified,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    ),
  );
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.coins, required this.strings});
  final int coins;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final number = NumberFormat.decimalPattern(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return MilestracksCard(
      padding: const EdgeInsets.all(13),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tokens.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconTheme(
              data: IconThemeData(color: tokens.surface),
              child: const MilestracksIcon('coin', size: 23),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: number.format(coins),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextSpan(
                    text: ' ${strings.profileCoins}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => context.go('/shop'),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.chevron_right, size: 18),
            label: Text(strings.profileTopUp),
          ),
        ],
      ),
    );
  }
}

class _RunSummary extends StatelessWidget {
  const _RunSummary({required this.runs, required this.strings});
  final List<RunDto> runs;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final finished = runs
        .where(
          (run) =>
              run.status == RunStatus.completed ||
              run.status == RunStatus.safeStopped,
        )
        .toList();
    final distance = finished.fold<double>(
      0,
      (sum, run) => sum + (run.distanceMeters ?? 0),
    );
    final duration = finished.fold<int>(
      0,
      (sum, run) => sum + (run.durationSeconds ?? 0),
    );
    final paces = finished
        .map((run) => run.paceSecondsPerKm)
        .whereType<double>()
        .toList();
    final average = distance > 0 ? duration / (distance / 1000) : null;
    final best = paces.isEmpty ? null : paces.reduce((a, b) => a < b ? a : b);
    final longest = finished
        .map((run) => run.distanceMeters ?? 0)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final stats = <(String, String)>[
      (
        NumberFormat('0.0', locale).format(distance / 1000),
        strings.profileTotalKm,
      ),
      (
        NumberFormat.decimalPattern(
          locale,
        ).format(finished.where((r) => r.status == RunStatus.completed).length),
        strings.profileCompletedRuns,
      ),
      (_duration(duration), strings.profileMovingTime),
      (_pace(average), strings.profileAveragePace),
      (_pace(best), strings.profileBestPace),
      (_distance(longest, locale), strings.profileLongestRun),
    ];
    final tokens = context.milestracksTokens;
    return ClipRRect(
      borderRadius: BorderRadius.circular(19),
      child: Container(
        decoration: BoxDecoration(
          color: tokens.surface,
          border: Border.all(color: tokens.border),
          borderRadius: BorderRadius.circular(19),
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 68,
          ),
          itemBuilder: (context, index) => Container(
            padding: const EdgeInsets.fromLTRB(13, 10, 8, 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: tokens.hairline),
                bottom: BorderSide(color: tokens.hairline),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  stats[index].$1,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  stats[index].$2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecentRuns extends StatelessWidget {
  const _RecentRuns({required this.runs, required this.strings});
  final List<RunDto> runs;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      eyebrow: strings.profileActivityEyebrow,
      title: strings.profileRunHistory,
      action: strings.profileSeeAll,
      onAction: () => context.go('/history'),
      child: runs.isEmpty
          ? Text(strings.profileNoRuns)
          : Column(
              children: runs.take(2).map((run) => _RunRow(run: run)).toList(),
            ),
    );
  }
}

class _RunRow extends StatelessWidget {
  const _RunRow({required this.run});
  final RunDto run;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final tokens = context.milestracksTokens;
    final title = run.trackTitle ?? run.trackId.replaceAll('-', ' ');
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.hairline)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  DateFormat.yMMMd(locale)
                      .add_jm()
                      .format(run.startedAt.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            _distance(run.distanceMeters ?? 0, locale),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(width: 5),
          Icon(Icons.chevron_right, size: 18, color: tokens.textMuted),
        ],
      ),
    );
  }
}

class _PaymentHistory extends StatelessWidget {
  const _PaymentHistory({required this.strings});
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) => _SectionCard(
    eyebrow: strings.profileActivityEyebrow,
    title: strings.profilePaymentHistory,
    action: strings.profileSeeAll,
    onAction: () => context.go('/shop'),
    child: Column(
      children: <Widget>[
        // Fake preview entries follow the React demo fixture; there is no
        // payment-history endpoint in the current API contract.
        _PaymentRow(
          coins: 50,
          cents: 107,
          date: DateTime(2026, 10, 26, 15, 21),
          strings: strings,
        ),
        _PaymentRow(
          coins: 50,
          cents: 107,
          date: DateTime(2026, 10, 24, 13, 7),
          strings: strings,
        ),
        _PaymentRow(
          coins: 100,
          cents: 541,
          date: DateTime(2026, 10, 19, 13, 7),
          strings: strings,
        ),
      ],
    ),
  );
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.coins,
    required this.cents,
    required this.date,
    required this.strings,
  });
  final int coins;
  final int cents;
  final DateTime date;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final tokens = context.milestracksTokens;
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: tokens.hairline)),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundColor: MilestracksTokens.homeMapBackground,
            child: IconTheme(
              data: IconThemeData(color: tokens.success),
              child: const MilestracksIcon('coin', size: 17),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.profileCoinPurchase(
                    NumberFormat.decimalPattern(locale).format(coins),
                  ),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  DateFormat.yMMMd(locale).add_jm().format(date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                NumberFormat.currency(
                  locale: locale,
                  name: 'USD',
                  symbol: '\$',
                ).format(cents / 100),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                strings.profilePaid,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: tokens.success),
              ),
            ],
          ),
          Icon(Icons.chevron_right, size: 18, color: tokens.textMuted),
        ],
      ),
    );
  }
}

class _Achievements extends StatelessWidget {
  const _Achievements({required this.items, required this.strings});
  final List<BadgeDto> items;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    final unlocked = items.where((badge) => badge.unlocked).length;
    return _SectionCard(
      eyebrow: strings.profileMilestonesEyebrow,
      title: strings.profileAchievements,
      trailing: Text(
        strings.profileAchievedCount('$unlocked/${items.length}'),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      child: Column(
        children: <Widget>[
          if (items.isEmpty) Text(strings.profileEmptyBadges),
          for (final badge in items.take(10))
            _BadgeRow(badge: badge, strings: strings),
          const SizedBox(height: 7),
          OutlinedButton(
            onPressed: () => context.go('/history'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
            ),
            child: Text(strings.profileViewBadges),
          ),
        ],
      ),
    );
  }
}

class _BadgeRow extends StatelessWidget {
  const _BadgeRow({required this.badge, required this.strings});
  final BadgeDto badge;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final progress = (badge.progress ?? (badge.unlocked ? 1 : 0))
        .clamp(0, 1)
        .toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 17,
            backgroundColor: MilestracksTokens.homeMapBackground,
            child: Icon(
              Icons.workspace_premium_outlined,
              size: 18,
              color: tokens.success,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        badge.name,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Text(
                      badge.unlocked
                          ? strings.badgeUnlocked
                          : strings.badgeLocked,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                Text(
                  badge.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  color: tokens.success,
                  backgroundColor: MilestracksTokens.homeMapBackground,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KilaCard extends StatelessWidget {
  const _KilaCard({required this.strings});
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) => MilestracksCard(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: <Widget>[
        Container(
          width: 46,
          height: 46,
          decoration: const BoxDecoration(
            color: Color(0xFFEEEFE5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(7),
            ),
          ),
          alignment: Alignment.center,
          child: const KilaMascot(width: 40, height: 40),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Eyebrow(strings.profileCompanion),
              Text(
                strings.profileKilaTitle,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                strings.profileKilaBody,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});
  final String eyebrow;
  final String title;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _Eyebrow(eyebrow),
      const SizedBox(height: 4),
      Text(title, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.eyebrow,
    required this.title,
    required this.child,
    this.action,
    this.onAction,
    this.trailing,
  });
  final String eyebrow;
  final String title;
  final Widget child;
  final String? action;
  final VoidCallback? onAction;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => MilestracksCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Eyebrow(eyebrow),
                  const SizedBox(height: 4),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            if (action case final actionText?)
              TextButton(onPressed: onAction, child: Text(actionText)),
            ?trailing,
          ],
        ),
        const SizedBox(height: 9),
        child,
      ],
    ),
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      letterSpacing: 1.05,
      color: context.milestracksTokens.textMuted,
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: MilestracksTokens.homeMapBackground,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    ),
  );
}

String _duration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainder = seconds % 60;
  return hours > 0
      ? '$hours:${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}'
      : '$minutes:${remainder.toString().padLeft(2, '0')}';
}

String _pace(double? seconds) {
  if (seconds == null || !seconds.isFinite) return '—';
  final value = seconds.round();
  return '${value ~/ 60}:${(value % 60).toString().padLeft(2, '0')}/km';
}

String _distance(double meters, String locale) =>
    '${NumberFormat('0.00', locale).format(meters / 1000)} km';
