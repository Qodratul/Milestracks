import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/history/presentation/history_providers.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/run_engine/run_engine_controller.dart';
import 'package:milestracks/run_engine/run_engine_state.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/milestracks_map.dart';

class RunResultScreen extends ConsumerWidget {
  const RunResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final state = ref.watch(runEngineControllerProvider);
    final track = ref.read(runEngineControllerProvider.notifier).trackForResult;
    final (run, safeStopped, rejected, syncPending) = switch (state) {
      RunCompleted(:final run, :final syncPending) => (
        run,
        false,
        false,
        syncPending,
      ),
      RunSafeStopped(:final run, :final syncPending) => (
        run,
        true,
        false,
        syncPending,
      ),
      RunRejected(:final run) => (run, false, true, false),
      _ => (null, false, false, false),
    };
    final tokens = context.milestracksTokens;
    if (run == null) {
      return Scaffold(
        backgroundColor: const Color(0xfff5f7f4),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(tokens.pagePadding),
            child: Text(strings.runNoResult, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    final title = rejected
        ? strings.runRejectedTitle
        : safeStopped
        ? strings.runSafeStoppedTitle
        : strings.runCompletedTitle;
    return _RunCelebration(
      celebrate: !safeStopped && !rejected,
      child: Scaffold(
        backgroundColor: const Color(0xfff5f7f4),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
              child: Column(
                children: <Widget>[
                  _ResultHeader(title: title),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      children: <Widget>[
                        if (track != null) ...<Widget>[
                          _SummaryTrackCard(track: track, run: run),
                          const SizedBox(height: 13),
                        ],
                        if (rejected)
                          _ResultNotice(message: strings.runRejectedBody),
                        if (syncPending)
                          _ResultNotice(message: strings.runSyncPending),
                        _EconomyCard(
                          run: run,
                          safeStopped: safeStopped,
                          rejected: rejected,
                        ),
                        if (run.streakDays != null) ...<Widget>[
                          const SizedBox(height: 10),
                          _StreakNote(days: run.streakDays!),
                        ],
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/history'),
                            icon: const Icon(Icons.route_outlined, size: 17),
                            label: Text(strings.runResultViewHistory),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xff385d43),
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xffe1e8df)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ResultActions(
                    onShare: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(strings.runResultShareUnavailable),
                      ),
                    ),
                    onClaim: () async {
                      final claimed = await ref
                          .read(runEngineControllerProvider.notifier)
                          .claimResultRewards();
                      if (!context.mounted) return;
                      if (!claimed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(strings.unknownError)),
                        );
                        return;
                      }
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(currentStreakProvider);
                      ref.invalidate(runHistoryControllerProvider);
                      context.go('/home');
                    },
                    rejected: rejected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -.35,
          color: Color(0xff24392b),
        ),
      ),
    ),
  );
}

class _SummaryTrackCard extends StatelessWidget {
  const _SummaryTrackCard({required this.track, required this.run});
  final TrackDto track;
  final RunDto run;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final distance = run.distanceMeters == null
        ? '—'
        : '${NumberFormat('0.00', locale).format(run.distanceMeters! / 1000)} km';
    final duration = run.durationSeconds == null
        ? '—'
        : _durationLabel(run.durationSeconds!, locale);
    final reached = run.reachedMilestones;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x141e3c2a)),
        borderRadius: BorderRadius.circular(23),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0e1c3727),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _PrivateRouteCover(track: track),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            strings.runResultYourRoute,
                            style: _resultEyebrow,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            track.narrative.trackTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff293c30),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const _SavedPill(),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  strings.runResultPrivacy,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xff78847b),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Color(0xffe8ede6)),
                ),
                Row(
                  children: <Widget>[
                    _SummaryMetric(
                      value: distance,
                      label: strings.historyDistance,
                    ),
                    _SummaryMetric(
                      value: duration,
                      label: strings.runResultMovingTime,
                    ),
                    _SummaryMetric(
                      value: reached == null
                          ? '—'
                          : '$reached/${track.milestones.length}',
                      label: strings.trackMilestones,
                    ),
                    _SummaryMetric(
                      value: run.estimatedCalories == null
                          ? '—'
                          : '~${run.estimatedCalories} kcal',
                      label: strings.runResultCalories,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateRouteCover extends StatelessWidget {
  const _PrivateRouteCover({required this.track});

  final TrackDto track;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return SizedBox(
      height: 174,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          MilestracksMap(track: track, height: 174, showSafePreview: false),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0x080f2018), Color(0x8c0f2018)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 11,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x70202b24),
                border: Border.all(color: const Color(0x66ffffff)),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: Text(
                  strings.runResultPrivatePreview.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 7,
                    letterSpacing: .6,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
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

class _SavedPill extends StatelessWidget {
  const _SavedPill();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xffeef5ef),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.check, size: 11, color: Color(0xff51815b)),
        const SizedBox(width: 3),
        Text(
          AppLocalizations.of(context)!.runResultSaved,
          style: const TextStyle(
            fontSize: 8,
            color: Color(0xff4c7653),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xff263a2d),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 7, color: Color(0xff7b877d)),
        ),
      ],
    ),
  );
}

class _EconomyCard extends StatelessWidget {
  const _EconomyCard({
    required this.run,
    required this.safeStopped,
    required this.rejected,
  });
  final RunDto run;
  final bool safeStopped;
  final bool rejected;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final number = NumberFormat.decimalPattern(locale);
    final earnedExp = run.milestoneExp ?? run.netExp;
    final loadout = run.loadoutLabel;
    final reward = run.netExp;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x101e3c2a)),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0d1c3727),
            blurRadius: 22,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      strings.runResultEconomyEyebrow,
                      style: _resultEyebrow,
                    ),
                    const SizedBox(height: 4),
                    Text(strings.runResultRewardsTitle, style: _resultTitle),
                  ],
                ),
              ),
              if (reward != null)
                RichText(
                  text: TextSpan(
                    text: '+${number.format(reward)}',
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff2c7544),
                    ),
                    children: const <InlineSpan>[
                      TextSpan(
                        text: ' EXP',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff6e7c71),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (loadout != null) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              strings.runResultLoadout(loadout),
              style: const TextStyle(fontSize: 9, color: Color(0xff78847b)),
            ),
          ],
          const SizedBox(height: 8),
          if (earnedExp != null)
            _EconomyRow(
              label: strings.runResultMilestoneExp,
              value: '+${number.format(earnedExp)} EXP',
            ),
          if (run.expMultiplier != null)
            _EconomyRow(
              label: strings.runResultMultiplier,
              value:
                  '${NumberFormat('0.0#', locale).format(run.expMultiplier)}x',
            ),
          if (run.runPenaltyExp != null)
            _EconomyRow(
              label: strings.runResultPenalty,
              value: run.runPenaltyExp == 0
                  ? '0 EXP'
                  : '-${number.format(run.runPenaltyExp)} EXP',
              negative: run.runPenaltyExp! > 0,
            ),
          if (rejected)
            _EconomyRow(
              label: strings.runRejectedTitle,
              value: '0 EXP',
              negative: true,
            ),
          if (!rejected && reward != null) ...<Widget>[
            const SizedBox(height: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xffeef5ef),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      strings.runResultAddedToLevel,
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color(0xff56715b),
                      ),
                    ),
                  ),
                  Text(
                    '+${number.format(reward)} EXP',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff2c7544),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (run.coinsEarned != null ||
              run.roleLeaguePoints != null) ...<Widget>[
            const SizedBox(height: 7),
            Row(
              children: <Widget>[
                if (run.coinsEarned != null)
                  Expanded(
                    child: _BonusCell(
                      value: '+${number.format(run.coinsEarned)}',
                      label: strings.runCoinsAwarded,
                    ),
                  ),
                if (run.roleLeaguePoints != null)
                  Expanded(
                    child: _BonusCell(
                      value: '+${number.format(run.roleLeaguePoints)}',
                      label: strings.runResultRolePoints,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            safeStopped
                ? strings.runResultSafeStopFootnote
                : strings.runResultDailyFootnote,
            style: const TextStyle(
              fontSize: 7,
              height: 1.35,
              color: Color(0xff7c887f),
            ),
          ),
        ],
      ),
    );
  }
}

class _EconomyRow extends StatelessWidget {
  const _EconomyRow({
    required this.label,
    required this.value,
    this.negative = false,
  });
  final String label;
  final String value;
  final bool negative;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 9, color: Color(0xff66766a)),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: negative ? const Color(0xffbd5146) : const Color(0xff304335),
          ),
        ),
      ],
    ),
  );
}

class _BonusCell extends StatelessWidget {
  const _BonusCell({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 5),
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xfffbfcfa),
      border: Border.all(color: const Color(0xffe7ece6)),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 6.5,
            letterSpacing: .35,
            color: Color(0xff78847b),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xff304335),
          ),
        ),
      ],
    ),
  );
}

class _StreakNote extends StatelessWidget {
  const _StreakNote({required this.days});
  final int days;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffe9eeea)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: <Widget>[
        const Icon(
          Icons.local_fire_department_outlined,
          color: Color(0xff263a2d),
          size: 24,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.runResultStreak,
              style: _resultEyebrow,
            ),
            const SizedBox(height: 3),
            Text(
              AppLocalizations.of(context)!.runResultStreakDay(days),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xff293c30),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ResultActions extends StatelessWidget {
  const _ResultActions({
    required this.onShare,
    required this.onClaim,
    required this.rejected,
  });
  final VoidCallback onShare;
  final VoidCallback onClaim;
  final bool rejected;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 12),
      decoration: const BoxDecoration(
        color: Color(0xf7f5f7f4),
        border: Border(top: BorderSide(color: Color(0x1b344c39))),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.ios_share, size: 16),
                  label: Text(
                    strings.runResultShareProgress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: _shareStyle(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.people_outline, size: 16),
                  label: Text(
                    strings.runResultShareTrack,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: _shareStyle(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton.icon(
              onPressed: onClaim,
              icon: Icon(
                rejected ? Icons.home_outlined : Icons.check_circle_outline,
                size: 17,
              ),
              label: Text(
                rejected ? strings.runBackHome : strings.runResultClaimFinish,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xff244b35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _shareStyle() => OutlinedButton.styleFrom(
    minimumSize: const Size(0, 42),
    backgroundColor: Colors.white,
    foregroundColor: const Color(0xff385d43),
    side: const BorderSide(color: Color(0xffe1e8df)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
  );
}

class _ResultNotice extends StatelessWidget {
  const _ResultNotice({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xfffbf3e4),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Text(
      message,
      style: const TextStyle(fontSize: 10, color: Color(0xff765d30)),
    ),
  );
}

const _resultEyebrow = TextStyle(
  fontSize: 7,
  letterSpacing: .8,
  fontWeight: FontWeight.w800,
  color: Color(0xff718076),
);
const _resultTitle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Color(0xff263a2d),
);

class _RunCelebration extends StatefulWidget {
  const _RunCelebration({required this.celebrate, required this.child});
  final bool celebrate;
  final Widget child;
  @override
  State<_RunCelebration> createState() => _RunCelebrationState();
}

class _RunCelebrationState extends State<_RunCelebration> {
  late final ConfettiController _controller;
  bool _reducedMotion = false;
  bool _played = false;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.disableAnimationsOf(context);
    _playIfAllowed();
  }

  @override
  void didUpdateWidget(covariant _RunCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _played = false;
      _playIfAllowed();
    }
  }

  void _playIfAllowed() {
    if (!_reducedMotion && widget.celebrate && !_played) {
      _played = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.play();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Stack(
      children: <Widget>[
        widget.child,
        if (!_reducedMotion && widget.celebrate)
          Positioned.fill(
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: ConfettiWidget(
                  confettiController: _controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: .06,
                  numberOfParticles: 18,
                  maxBlastForce: 22,
                  minBlastForce: 8,
                  gravity: .19,
                  colors: <Color>[
                    tokens.primary,
                    tokens.secondary,
                    tokens.accent,
                    tokens.success,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _durationLabel(int seconds, String locale) {
  final duration = Duration(seconds: seconds);
  final two = NumberFormat('00', locale);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final remainder = duration.inSeconds.remainder(60);
  return hours > 0
      ? '${two.format(hours)}:${two.format(minutes)}:${two.format(remainder)}'
      : '${two.format(minutes)}:${two.format(remainder)}';
}
