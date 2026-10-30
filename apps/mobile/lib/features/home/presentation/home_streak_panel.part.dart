part of 'home_screen.dart';

class _StreakPanel extends StatefulWidget {
  const _StreakPanel({
    required this.days,
    required this.bestDays,
    required this.freezes,
    required this.showDemoPrice,
  });
  final int days, bestDays, freezes;
  final bool showDemoPrice;

  @override
  State<_StreakPanel> createState() => _StreakPanelState();
}

class _StreakPanelState extends State<_StreakPanel> {
  bool _showMonthlyHistory = false;
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    final days = widget.days;
    final bestDays = widget.bestDays;
    final freezes = widget.freezes;
    final showDemoPrice = widget.showDemoPrice;
    final s = AppLocalizations.of(context)!;
    final t = context.milestracksTokens;
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            MilestracksTokens.homeDeepGreen,
            MilestracksTokens.homeForestGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(21),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: t.primary.withValues(alpha: .15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      s.homeStreakTitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .76),
                        fontSize: 8,
                        letterSpacing: .8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.homeStreakRhythm,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '$days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      height: .9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    s.homeDayStreak.toLowerCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  showDemoPrice ? s.homeAtRiskMinimum : s.streakCurrent,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .85),
                    fontSize: 8,
                  ),
                ),
              ),
              Text(
                showDemoPrice ? s.homeBestStreak(bestDays) : s.streakBest,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .8),
                  fontSize: 7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.shield_outlined,
                      size: 13,
                      color: Color(0xffe9d49a),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        showDemoPrice
                            ? freezes == 0
                                  ? s.homeFreezeProtection
                                  : s.streakFreezes
                            : s.streakFreezes,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .85),
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (showDemoPrice)
                OutlinedButton(
                  onPressed: () => context.go('/shop'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(60, 32),
                    foregroundColor: const Color(0xfff4e2af),
                    side: BorderSide(
                      color: const Color(0xffe8d49b).withValues(alpha: .35),
                    ),
                    backgroundColor: Colors.white.withValues(alpha: .08),
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(s.homeBuy, style: const TextStyle(fontSize: 8)),
                      const SizedBox(width: 5),
                      const MilestracksIcon('coin', size: 12),
                      const SizedBox(width: 3),
                      const Text(
                        '${HomeDashboardPreview.freezePrice}',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                )
              else
                TextButton(
                  onPressed: () => context.go('/shop'),
                  child: Text(s.streakShop),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .07),
              border: Border.all(color: Colors.white.withValues(alpha: .12)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: List<Widget>.generate(7, (i) {
                final d = weekStart.add(Duration(days: i));
                final today = DateUtils.isSameDay(d, now);
                return Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        DateFormat.E(
                          Localizations.localeOf(context).toLanguageTag(),
                        ).format(d).substring(0, 1),
                        style: TextStyle(
                          color: today
                              ? const Color(0xfff0d998)
                              : Colors.white.withValues(alpha: .65),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i < days
                              ? Colors.white.withValues(alpha: .12)
                              : Colors.white.withValues(alpha: .07),
                          border: Border.all(
                            color: today
                                ? const Color(0xffe8c778)
                                : Colors.white.withValues(alpha: .14),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          DateFormat.d().format(d),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .88),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  s.homeWeeklyRhythmFooter,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .75),
                    fontSize: 8,
                  ),
                ),
              ),
              Text(
                s.homeDaysOfWeek(days),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            height: 37,
            child: OutlinedButton(
              onPressed: () =>
                  setState(() => _showMonthlyHistory = !_showMonthlyHistory),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: .16)),
                backgroundColor: Colors.white.withValues(alpha: .08),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    _showMonthlyHistory
                        ? s.homeMonthlyHide
                        : s.homeMonthlyDetails,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _showMonthlyHistory ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_showMonthlyHistory) ...<Widget>[
            const SizedBox(height: 9),
            _MonthlyStreakHistory(
              month: _month,
              onMonthChanged: (month) => setState(() => _month = month),
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthlyStreakHistory extends ConsumerWidget {
  const _MonthlyStreakHistory({
    required this.month,
    required this.onMonthChanged,
  });
  final DateTime month;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final history = ref.watch(profileRunSummaryProvider);
    final first = DateTime(month.year, month.month);
    final offset = first.weekday - DateTime.monday;
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final cellCount = ((offset + daysInMonth + 6) ~/ 7) * 7;
    final dates = List<DateTime?>.generate(cellCount, (index) {
      final day = index - offset + 1;
      if (day < 1 || day > daysInMonth) return null;
      return DateTime(month.year, month.month, day);
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  DateFormat.yMMMM(locale).format(month),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _MonthButton(
                tooltip: strings.homePreviousMonth,
                icon: Icons.chevron_left,
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month - 1)),
              ),
              const SizedBox(width: 5),
              _MonthButton(
                tooltip: strings.homeNextMonth,
                icon: Icons.chevron_right,
                onPressed: () =>
                    onMonthChanged(DateTime(month.year, month.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: List<Widget>.generate(7, (index) {
              final weekday = DateTime(2024, 1, 1 + index);
              return Expanded(
                child: Center(
                  child: Text(
                    DateFormat.E(locale).format(weekday).substring(0, 1),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .65),
                      fontSize: 8,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 5),
          history.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => Text(
              strings.profileHistoryError,
              style: TextStyle(
                color: Colors.white.withValues(alpha: .8),
                fontSize: 9,
              ),
            ),
            data: (runs) {
              final runDates = runs
                  .where(
                    (run) =>
                        run.status == RunStatus.completed ||
                        run.status == RunStatus.safeStopped,
                  )
                  .map((run) => DateUtils.dateOnly(run.startedAt.toLocal()))
                  .toSet();
              final monthRuns = runDates
                  .where(
                    (date) =>
                        date.year == month.year && date.month == month.month,
                  )
                  .length;
              return Column(
                children: <Widget>[
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dates.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisExtent: 34,
                        ),
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      if (date == null) return const SizedBox.shrink();
                      final hasRun = runDates.contains(date);
                      final today = DateUtils.isSameDay(date, DateTime.now());
                      return Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: hasRun
                              ? Colors.white.withValues(alpha: .2)
                              : Colors.transparent,
                          border: Border.all(
                            color: today
                                ? const Color(0xffe8c778)
                                : hasRun
                                ? Colors.white.withValues(alpha: .2)
                                : Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: date.isAfter(DateTime.now())
                                ? Colors.white.withValues(alpha: .35)
                                : Colors.white,
                            fontSize: 9,
                            fontWeight: hasRun
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 11, color: Color(0x33FFFFFF)),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .25),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          strings.homeRunDayLegend,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .72),
                            fontSize: 8,
                          ),
                        ),
                      ),
                      Text(
                        strings.homeMonthlyRunCount(
                          NumberFormat.decimalPattern(locale).format(monthRuns),
                        ),
                        style: TextStyle(
                          color: tokens.surface,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    visualDensity: VisualDensity.compact,
    constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
    padding: EdgeInsets.zero,
    style: IconButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white.withValues(alpha: .08),
      side: BorderSide(color: Colors.white.withValues(alpha: .16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    ),
    icon: Icon(icon, size: 18),
  );
}
