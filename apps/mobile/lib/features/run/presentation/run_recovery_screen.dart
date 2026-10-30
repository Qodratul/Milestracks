import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/storage/app_database.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/home/presentation/home_screen.dart';
import 'package:milestracks/features/run/domain/run_repository.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/run_engine/gps_point_source.dart';
import 'package:milestracks/run_engine/run_engine_controller.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RunRecoveryScreen extends ConsumerWidget {
  const RunRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRun = ref.watch(activeRunRecoveryProvider);
    return Theme(
      data: MilestracksTheme.light,
      child: activeRun.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, _) => _RecoveryMessage(
          message: AppLocalizations.of(context)!.networkError,
          action: AppLocalizations.of(context)!.trackTryAgain,
          onPressed: () => ref.invalidate(activeRunRecoveryProvider),
        ),
        data: (run) => run == null
            ? const HomeScreen(showBottomNavigation: false)
            : _ActiveRunRecovery(run: run),
      ),
    );
  }
}

class _ActiveRunRecovery extends ConsumerStatefulWidget {
  const _ActiveRunRecovery({required this.run});
  final ActiveRunRecovery run;

  @override
  ConsumerState<_ActiveRunRecovery> createState() => _ActiveRunRecoveryState();
}

class _ActiveRunRecoveryState extends ConsumerState<_ActiveRunRecovery> {
  bool _stopping = false;

  Future<void> _continueRun() async {
    final strings = AppLocalizations.of(context)!;
    setState(() => _stopping = true);
    try {
      final engine = ref.read(runEngineControllerProvider.notifier);
      await engine.retryPendingSync();
      final database = await ref.read(appDatabaseProvider.future);
      if ((await database.pendingRunPointsFor(widget.run.id)).isNotEmpty) {
        throw StateError('Pending run locations could not be synchronized.');
      }
      final latestRun = await ref.read(runRepositoryProvider).getActiveRun();
      if (latestRun == null) {
        if (!mounted) return;
        ref.invalidate(activeRunRecoveryProvider);
        context.go('/home');
        return;
      }
      final track = await ref
          .read(trackRepositoryProvider)
          .getTrack(latestRun.trackId);
      await engine.restoreActiveRun(
        track: track,
        activeRun: latestRun,
        notificationCopy: RunNotificationCopy(
          title: strings.runNotificationTitle,
          body: strings.runNotificationBody,
          channelName: strings.runNotificationChannelName,
        ),
      );
      if (!mounted) return;
      ref.invalidate(activeRunRecoveryProvider);
      context.go('/run/${latestRun.trackId}');
    } on Object {
      if (!mounted) return;
      setState(() => _stopping = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.runRecoveryFailed)));
    }
  }

  Future<void> _safeStop() async {
    final strings = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.runRecoveryTitle),
        content: Text(strings.runRecoveryConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.authBack),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(strings.runRecoverySafeStop),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _stopping = true);
    try {
      final engine = ref.read(runEngineControllerProvider.notifier);
      await engine.retryPendingSync();
      final database = await ref.read(appDatabaseProvider.future);
      final unsynced = await database.pendingRunPointsFor(widget.run.id);
      if (unsynced.isNotEmpty) {
        throw StateError('Pending run locations could not be synchronized.');
      }
      final latestRun = await ref.read(runRepositoryProvider).getActiveRun();
      if (latestRun == null) {
        if (!mounted) return;
        ref.invalidate(activeRunRecoveryProvider);
        context.go('/home');
        return;
      }
      final result = await ref
          .read(runRepositoryProvider)
          .safeStopRun(
            latestRun.id,
            SafeStopRequestDto(
              reasonCode: 'other',
              lastSampleSequence: latestRun.lastSampleSequence,
            ),
            idempotencyKey: IdempotencyKey.create(),
          );
      if (!mounted) return;
      engine.restoreRecoveredResult(result);
      ref.invalidate(activeRunRecoveryProvider);
      context.go('/run-result');
    } on Object {
      if (!mounted) return;
      setState(() => _stopping = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.runRecoveryFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final started = DateFormat.yMMMd(locale)
        .add_Hm()
        .format(widget.run.startedAt.toLocal());
    final distance = NumberFormat(
      '0.00',
      locale,
    ).format(widget.run.distanceMeters / 1000);
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f3),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: EdgeInsets.all(tokens.pagePadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.directions_run, size: 54, color: tokens.primary),
                  const SizedBox(height: 20),
                  Text(
                    strings.runRecoveryTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    strings.runRecoveryBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: tokens.textSecondary),
                  ),
                  const SizedBox(height: 22),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(strings.runRecoveryStartedAt(started)),
                          const SizedBox(height: 8),
                          Text(strings.runRecoveryDistance(distance)),
                          const SizedBox(height: 8),
                          Text(
                            widget.run.status == RunStatus.paused
                                ? strings.runRecoveryPaused
                                : strings.runRecoveryActive,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _stopping ? null : _safeStop,
                    icon: _stopping
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.stop_circle_outlined),
                    label: Text(strings.runRecoverySafeStop),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _stopping ? null : _continueRun,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(strings.runRecoveryContinue),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.runRecoverySafeStopHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: tokens.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _stopping
                        ? null
                        : () => ref.invalidate(activeRunRecoveryProvider),
                    child: Text(strings.trackTryAgain),
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

class _RecoveryMessage extends StatelessWidget {
  const _RecoveryMessage({
    required this.message,
    required this.action,
    required this.onPressed,
  });
  final String message;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(action)),
          ],
        ),
      ),
    ),
  );
}
