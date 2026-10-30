part of 'home_screen.dart';

class _SponsoredCard extends StatelessWidget {
  const _SponsoredCard({required this.onExplore});
  final VoidCallback onExplore;
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                s.homeInspiredToMove.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 8, letterSpacing: .9),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(color: context.milestracksTokens.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                s.homeSponsored.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Container(
          height: 176,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1786630251101-0f0ce3470cb6?auto=format&fit=crop&w=1000&q=82',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: context.milestracksTokens.shadow,
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xd10c1f17), Color(0x220c1f17)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      s.homeMilestridePicks.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        letterSpacing: .7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 240,
                      child: Text(
                        s.homeAdTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          height: 1.02,
                          letterSpacing: -.7,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.homeAdBody,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .87),
                        fontSize: 9,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: onExplore,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: .5),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: .15),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            s.homeExploreTrack,
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(width: 5),
                          const MilestracksIcon('arrow', size: 13),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 7,
                bottom: 6,
                child: Text(
                  s.homePhotoCredit,
                  style: const TextStyle(color: Colors.white, fontSize: 6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
