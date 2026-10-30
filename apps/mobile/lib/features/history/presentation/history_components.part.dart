part of 'history_screen.dart';

class _StatusTag extends StatelessWidget {
  const _StatusTag({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontSize: 7,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.1,
      ),
    ),
  );
}

class _NoMatchingRuns extends StatelessWidget {
  const _NoMatchingRuns({required this.title, required this.detail});
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 18),
    child: Column(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        if (detail.isNotEmpty) ...<Widget>[
          const SizedBox(height: 6),
          Text(detail, textAlign: TextAlign.center),
        ],
      ],
    ),
  );
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({
    required this.message,
    required this.action,
    required this.onPressed,
  });
  final String message;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton(onPressed: onPressed, child: Text(action)),
        ],
      ),
    ),
  );
}

String _filterLabel(HistoryStatusFilter filter, AppLocalizations strings) =>
    switch (filter) {
      HistoryStatusFilter.all => strings.historyFilterAll,
      HistoryStatusFilter.completed => strings.historyFilterCompleted,
      HistoryStatusFilter.safeStopped => strings.historyFilterSafeStop,
      HistoryStatusFilter.flagged => strings.historyFilterFlagged,
      HistoryStatusFilter.rejected => strings.historyFilterRejected,
    };

Color _statusColor(RunStatus status, MilestracksTokens tokens) =>
    switch (status) {
      RunStatus.completed => tokens.success,
      RunStatus.safeStopped => const Color(0xff806219),
      RunStatus.rejected => tokens.error,
      _ => tokens.textMuted,
    };

Color _statusBackground(RunStatus status) => switch (status) {
  RunStatus.completed => const Color(0xffedf2ed),
  RunStatus.safeStopped => const Color(0xfff6efdc),
  RunStatus.rejected => const Color(0xfff5e9e7),
  _ => const Color(0xffedf2ed),
};

String _fakeTrackTitle(String trackId, AppLocalizations strings) =>
    switch (trackId) {
      'track-senayan' =>
        strings.localeName == 'id'
            ? 'Jalur Teduh Senayan'
            : 'Senayan Shaded Loop',
      'track-city-park' =>
        strings.localeName == 'id'
            ? 'Pagi di Taman Kota'
            : 'Morning at the City Park',
      'track-canal-side' =>
        strings.localeName == 'id' ? 'Rute Tepi Kanal' : 'Canal-side Route',
      'track-old-trees' || 'track-fog-001' =>
        strings.localeName == 'id'
            ? 'Jalur Pagi di Balik Pepohonan Tua'
            : 'Morning Trail Beyond the Old Trees',
      _ => trackId,
    };

String _distance(double? meters, String locale) => meters == null
    ? '—'
    : '${NumberFormat('0.00', locale).format(meters / 1000)} km';

String _movingDuration(int? seconds) {
  if (seconds == null) return '—';
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '${NumberFormat('00').format(minutes)}:${NumberFormat('00').format(remainder)}';
}
