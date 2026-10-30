part of 'history_screen.dart';

class _HistoryHero extends StatelessWidget {
  const _HistoryHero();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      constraints: const BoxConstraints(minHeight: 187),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xff1e3d33), Color(0xff42634e)],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xff193627).withValues(alpha: .14),
            blurRadius: 30,
            offset: const Offset(0, 13),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: -78,
            right: -18,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[Color(0x40c4dbad), Color(0x00c4dbad)],
                ),
              ),
            ),
          ),
          Positioned(
            right: -22,
            bottom: -43,
            child: Transform.rotate(
              angle: -.4363,
              child: Container(
                width: 180,
                height: 110,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .12),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                strings.historyHeroEyebrow,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: .62),
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .98,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                strings.historyHeroTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.1,
                  letterSpacing: -1.25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                strings.historyHeroDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: .7),
                  fontSize: 9,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.white.withValues(alpha: .16)),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  _HeroStat(
                    value: '${HistoryDashboardPreview.completedRuns}',
                    label: strings.historyRunsCount,
                  ),
                  const _HeroDivider(),
                  _HeroStat(
                    value: _distance(
                      HistoryDashboardPreview.distanceMeters,
                      Localizations.localeOf(context).toLanguageTag(),
                    ),
                    label: strings.historyDistanceStat,
                  ),
                  const _HeroDivider(),
                  _HeroStat(
                    value: NumberFormat.decimalPattern(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(HistoryDashboardPreview.expEarned),
                    label: strings.historyExpEarned,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        value,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Colors.white, fontSize: 12, height: 1.1),
      ),
      const SizedBox(height: 2),
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white.withValues(alpha: .63),
          fontSize: 7,
          height: 1.2,
        ),
      ),
    ],
  );
}

class _HeroDivider extends StatelessWidget {
  const _HeroDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 25,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: Colors.white.withValues(alpha: .2),
  );
}

class _HistoryFilterChip extends StatelessWidget {
  const _HistoryFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Material(
            color: selected ? tokens.primary : const Color(0xffedf2ed),
            borderRadius: BorderRadius.circular(999),
            elevation: selected ? 3 : 0,
            shadowColor: const Color(0xff20422e).withValues(alpha: .18),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(999),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: selected
                            ? Colors.white
                            : const Color(0xff627268),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistorySearch extends StatefulWidget {
  const _HistorySearch({
    required this.hint,
    required this.label,
    required this.onChanged,
  });

  final String hint;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  State<_HistorySearch> createState() => _HistorySearchState();
}

class _HistorySearchState extends State<_HistorySearch> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        border: Border.all(
          color: Color.lerp(tokens.border, tokens.primary, .08)!,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xff1b3727).withValues(alpha: .035),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: tokens.textMuted),
            child: const MilestracksIcon('search', size: 17),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Semantics(
              label: widget.label,
              textField: true,
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  widget.onChanged(value);
                  setState(() {});
                },
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: tokens.textPrimary, fontSize: 9),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: tokens.textMuted, fontSize: 9),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
                setState(() {});
              },
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
              icon: Icon(Icons.close, size: 15, color: tokens.textMuted),
            ),
        ],
      ),
    );
  }
}
