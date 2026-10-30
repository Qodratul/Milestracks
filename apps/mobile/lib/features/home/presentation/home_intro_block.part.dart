part of 'home_screen.dart';

class _IntroBlock extends StatelessWidget {
  const _IntroBlock();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final t = context.milestracksTokens;
    final now = DateTime.now();
    final time = DateFormat.jm(Localizations.localeOf(context).toLanguageTag())
        .format(now);
    final date = DateFormat.yMMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: t.primary,
                borderRadius: BorderRadius.circular(14),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: t.shadow,
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: IconTheme(
                  data: IconThemeData(color: Colors.white),
                  child: MilestracksIcon('brand', size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    s.homeWelcomeEyebrow,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 8, letterSpacing: 1.05),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.homeSaferRoute,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 25,
                      letterSpacing: -1.3,
                      height: 1.06,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 21),
        Row(
          children: <Widget>[
            Text(
              time,
              style: Theme.of(context).textTheme.headlineLarge
                  ?.copyWith(fontSize: 30, letterSpacing: -1.3, height: 1),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    s.homeCity,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 9),
                  ),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 8, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 30, color: t.border),
            const SizedBox(width: 10),
            const MilestracksIcon('weather', size: 21),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  s.homeWeatherToday.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontSize: 7),
                ),
                Text(
                  s.homeWeatherText,
                  style: Theme.of(context).textTheme.labelSmall
                      ?.copyWith(fontSize: 8, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
