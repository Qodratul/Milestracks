part of 'home_screen.dart';

class _DailyStatusCard extends StatelessWidget {
  const _DailyStatusCard();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final t = context.milestracksTokens;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xffffffff), Color(0xfff2f7f1)],
        ),
        borderRadius: BorderRadius.circular(23),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xff1b3727).withValues(alpha: .055),
            blurRadius: 23,
            offset: const Offset(0, 8),
          ),
        ],
      ),
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
                      s.homeDailyStatus.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(fontSize: 8, letterSpacing: .9),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.homeDailyLimits,
                      style: Theme.of(context).textTheme.titleSmall
                          ?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: t.success.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  s.homeRefreshesLeft(HomeDashboardPreview.refreshesLeft),
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(color: t.success, fontSize: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: <Widget>[
              Expanded(
                child: _DailyMetric(
                  title: s.homeExpAvailable,
                  value: NumberFormat.decimalPattern(locale)
                      .format(HomeDashboardPreview.expCap),
                  caption: s.homeOfToday(HomeDashboardPreview.expCap),
                  progress: 1,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _DailyMetric(
                  title: s.homeLeaguePoints,
                  value:
                      '${NumberFormat.decimalPattern(locale).format(HomeDashboardPreview.leaguePoints)} RP',
                  caption: s.homeOfToday(HomeDashboardPreview.rpCap),
                  progress: .84,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _DailyMetric(
                  title: s.homeCoinsAvailable,
                  value: '${HomeDashboardPreview.coinCap}',
                  caption: s.homeOfToday(HomeDashboardPreview.coinCap),
                  progress: 1,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _DailyMetric(
                  title: s.homeSafeStops,
                  value: s.homeLeft(HomeDashboardPreview.safeStopsLeft),
                  caption: s.homeOfThisWeek(2),
                  progress: .5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyMetric extends StatelessWidget {
  const _DailyMetric({
    required this.title,
    required this.value,
    required this.caption,
    required this.progress,
  });
  final String title, value, caption;
  final double progress;
  @override
  Widget build(BuildContext context) {
    final t = context.milestracksTokens;
    return Container(
      height: 82,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 9),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xfff7faf6), Color(0xffeef4ee)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 8),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontSize: 17, height: 1.1),
          ),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 7, color: t.textMuted),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: t.success.withValues(alpha: .1),
              color: const Color(0xff92b47e),
            ),
          ),
        ],
      ),
    );
  }
}
