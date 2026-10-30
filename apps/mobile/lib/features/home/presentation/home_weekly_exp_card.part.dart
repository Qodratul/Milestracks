part of 'home_screen.dart';

class _WeeklyExpCard extends StatelessWidget {
  const _WeeklyExpCard();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final t = context.milestracksTokens;
    final today = DateTime.now();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.white, Color(0xfff1f5f0)],
        ),
        border: Border.all(color: t.primary.withValues(alpha: .1)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            s.homeThisWeek.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontSize: 8, letterSpacing: .8),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                '${HomeDashboardPreview.dailyExp}',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(fontSize: 23, height: 1),
              ),
              const SizedBox(width: 5),
              Text(
                'EXP',
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 8),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: t.surface.withValues(alpha: .76),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    DateFormat.MMMd(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(today),
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 8),
                  ),
                ),
                Text(
                  '${HomeDashboardPreview.dailyExp} EXP',
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontSize: 9, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List<Widget>.generate(7, (i) {
                final date = today.subtract(
                  Duration(days: today.weekday - 1 - i),
                );
                final isToday = i == today.weekday - 1;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 25,
                        height: 3,
                        decoration: BoxDecoration(
                          color: isToday
                              ? t.primary.withValues(alpha: .86)
                              : t.border.withValues(alpha: .6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        DateFormat.E(
                          Localizations.localeOf(context).toLanguageTag(),
                        ).format(date).substring(0, 3),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 7,
                          color: isToday ? t.primary : t.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 7),
          Divider(height: 1, color: t.border),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  s.homeWeeklyActivity,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontSize: 8),
                ),
              ),
              Text(
                s.homeRunsAndExp(
                  HomeDashboardPreview.weeklyRuns,
                  HomeDashboardPreview.dailyExp,
                ),
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 8, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 5,
              backgroundColor: t.primary.withValues(alpha: .08),
              color: const Color(0xff83a77c),
            ),
          ),
        ],
      ),
    );
  }
}
