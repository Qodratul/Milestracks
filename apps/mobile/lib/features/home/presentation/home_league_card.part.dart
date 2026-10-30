part of 'home_screen.dart';

class _LeagueCard extends StatelessWidget {
  const _LeagueCard();
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            MilestracksTokens.homeDeepGreen,
            Color(0xff31564d),
            Color(0xff516a53),
          ],
          stops: <double>[0, .68, 1],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: context.milestracksTokens.shadow,
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .11),
                  border: Border.all(
                    color: const Color(0xffe9d49a).withValues(alpha: .45),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events_outlined,
                  color: Color(0xfff0d998),
                  size: 18,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  s.homeLeagueLabel.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .84),
                    fontSize: 8,
                  ),
                ),
              ),
              Container(
                width: 33,
                height: 33,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .09),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffe9d49a).withValues(alpha: .5),
                  ),
                ),
                child: const Text(
                  '#7',
                  style: TextStyle(
                    color: Color(0xfff0d998),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            s.homeLeagueRp(HomeDashboardPreview.leaguePoints),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            s.homeLeagueRank(
              HomeDashboardPreview.leagueRank,
              HomeDashboardPreview.leagueSize,
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: .75),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: const LinearProgressIndicator(
              value: .25,
              minHeight: 5,
              backgroundColor: Color(0x334f6d60),
              color: Color(0xffe6d49b),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  s.homeLeaguePrize(HomeDashboardPreview.leaguePrize),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/league'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xfff0d998),
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 30),
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      s.homeViewStandings,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 15),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
