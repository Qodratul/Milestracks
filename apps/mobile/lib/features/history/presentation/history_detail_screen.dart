import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/history/presentation/history_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/feature_page_scaffold.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';
import 'package:milestracks/shared/widgets/milestracks_map.dart';

class HistoryDetailScreen extends ConsumerWidget {
  const HistoryDetailScreen({required this.runId, super.key});
  final String runId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final detail = ref.watch(runDetailProvider(runId));
    return FeaturePageScaffold(
      title: strings.historyDetailTitle,
      destination: MainDestination.history,
      showBottomNavigation: false,
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(context.milestracksTokens.pagePadding),
            child: Text(strings.historyError, textAlign: TextAlign.center),
          ),
        ),
        data: (value) => _RunDetailContent(detail: value),
      ),
    );
  }
}

class _RunDetailContent extends StatelessWidget {
  const _RunDetailContent({required this.detail});
  final RunDetailDto detail;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final run = detail.run;
    final route = detail.trace
        .map(
          (point) =>
              GeoPointDto(latitude: point.latitude, longitude: point.longitude),
        )
        .toList(growable: false);
    final status = switch (run.status) {
      RunStatus.completed => strings.historyCompleted,
      RunStatus.safeStopped => strings.historySafeStopped,
      RunStatus.rejected => strings.historyRejected,
      _ => strings.runActive,
    };
    return ListView(
      padding: EdgeInsets.all(tokens.pagePadding),
      children: <Widget>[
        if (route.length >= 2)
          ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radiusCard),
            child: MilestracksMap(routePoints: route, height: 280),
          )
        else
          SizedBox(
            height: 180,
            child: Center(child: Text(strings.historyNoTrace)),
          ),
        SizedBox(height: tokens.space16),
        Text(
          DateFormat.yMMMd(locale).format(run.startedAt.toLocal()),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: tokens.space8),
        Text(status, style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: tokens.space14),
        MilestracksCard(
          child: Column(
            children: <Widget>[
              _DetailMetric(
                label: strings.historyDistance,
                value: _distance(run.distanceMeters, locale),
              ),
              _DetailMetric(
                label: strings.historyDuration,
                value: _duration(run.durationSeconds, locale),
              ),
              _DetailMetric(
                label: strings.historyPace,
                value: _pace(run.paceSecondsPerKm, locale),
              ),
              _DetailMetric(
                label: strings.historyNetExp,
                value: run.netExp == null
                    ? '—'
                    : NumberFormat.decimalPattern(locale).format(run.netExp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailMetric extends StatelessWidget {
  const _DetailMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: context.milestracksTokens.space8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.labelMedium),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );
}

String _distance(double? meters, String locale) => meters == null
    ? '—'
    : '${NumberFormat('0.00', locale).format(meters / 1000)} km';
String _pace(double? seconds, String locale) =>
    seconds == null ? '—' : '${_duration(seconds.round(), locale)} / km';
String _duration(int? seconds, String locale) {
  if (seconds == null) return '—';
  final value = Duration(seconds: seconds);
  final two = NumberFormat('00', locale);
  return value.inHours > 0
      ? '${two.format(value.inHours)}:${two.format(value.inMinutes.remainder(60))}:${two.format(value.inSeconds.remainder(60))}'
      : '${two.format(value.inMinutes)}:${two.format(value.inSeconds.remainder(60))}';
}
