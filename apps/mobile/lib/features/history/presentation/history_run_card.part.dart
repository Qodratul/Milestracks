part of 'history_screen.dart';

class _RunHistoryCard extends StatelessWidget {
  const _RunHistoryCard({required this.run, required this.onTap});

  final RunDto run;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final tokens = context.milestracksTokens;
    final title = run.trackTitle ?? _fakeTrackTitle(run.trackId, strings);
    final date = DateFormat.yMMMd(locale)
        .add_jm()
        .format(run.startedAt.toLocal());
    final status = switch (run.status) {
      RunStatus.completed => strings.historyCompleted,
      RunStatus.safeStopped => strings.historySafeStopped,
      RunStatus.rejected => strings.historyRejected,
      _ => strings.runActive,
    };
    // The API's current RunDto has no integrity field; these badges are fake-demo presentation only.
    final isFlagged = HistoryDashboardPreview.flaggedRunIds.contains(run.id);
    final integrityLabel = isFlagged
        ? strings.historyFlaggedTag
        : run.status == RunStatus.rejected
        ? strings.historyRejected
        : strings.historyClean;
    final integrityColor = isFlagged
        ? const Color(0xff806219)
        : run.status == RunStatus.rejected
        ? tokens.error
        : tokens.success;
    final integrityBackground = isFlagged
        ? const Color(0xfff6efdc)
        : run.status == RunStatus.rejected
        ? const Color(0xfff5e9e7)
        : const Color(0xffedf2ed);
    return Semantics(
      button: true,
      label: '$title, $date, $status, ${_distance(run.distanceMeters, locale)}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            constraints: const BoxConstraints(minHeight: 88),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              border: Border.all(color: const Color(0x1721432e)),
              borderRadius: BorderRadius.circular(17),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: const Color(0xff1b3727).withValues(alpha: .045),
                  blurRadius: 13,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xff20392a),
                          fontSize: 12,
                          letterSpacing: -.24,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xff7d8980),
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 5,
                        runSpacing: 4,
                        children: <Widget>[
                          _StatusTag(
                            label: status,
                            color: _statusColor(run.status, tokens),
                            background: _statusBackground(run.status),
                          ),
                          _StatusTag(
                            label: integrityLabel,
                            color: integrityColor,
                            background: integrityBackground,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _distance(run.distanceMeters, locale),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xff294333),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_movingDuration(run.durationSeconds)} ${strings.historyMoving}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xff7d8980),
                        fontSize: 8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '+${NumberFormat.decimalPattern(locale).format(run.netExp ?? 0)} EXP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xff56805d),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
