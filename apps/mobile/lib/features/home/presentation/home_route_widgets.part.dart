part of 'home_screen.dart';

class _RouteHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final t = context.milestracksTokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                s.homeTodaysRoute.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(fontSize: 8, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                s.homeMysteryTrack,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: t.success.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.circle, size: 6, color: t.success),
              const SizedBox(width: 5),
              Text(
                s.trackReady,
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(color: t.success, fontSize: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.track,
    required this.isDemo,
    required this.onOpen,
  });
  final AsyncValue<TrackDto> track;
  final bool isDemo;
  final ValueChanged<String> onOpen;
  @override
  Widget build(BuildContext context) {
    final t = context.milestracksTokens;
    final s = AppLocalizations.of(context)!;
    return track.when(
      loading: () => const _HomeLoadingCard(),
      error: (_, _) => Container(
        height: 320,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(23),
        ),
        child: Text(s.networkError),
      ),
      data: (value) => Container(
        height: 253,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: t.primary,
          borderRadius: BorderRadius.circular(23),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: t.shadow,
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 176,
              child: MilestracksMap(
                track: value,
                height: 176,
                showSafePreview: false,
              ),
            ),
            if (isDemo)
              Positioned(
                top: 11,
                left: 11,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: t.surface.withValues(alpha: .93),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: t.shadow, blurRadius: 9),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      const MilestracksIcon('shield', size: 13),
                      const SizedBox(width: 5),
                      Text(
                        '${HomeDashboardPreview.safetyScore}%  ${s.homeSafetyScore}',
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(fontSize: 8),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 10,
              right: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .86),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  child: Text(
                    AppConfig.mapTileAttribution.isEmpty
                        ? s.mapAttribution
                        : '${s.mapAttribution} · ${AppConfig.mapTileAttribution}',
                    style: Theme.of(context).textTheme.labelSmall
                        ?.copyWith(fontSize: 6, color: const Color(0xff42564c)),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 173,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      t.primary.withValues(alpha: 0),
                      t.primary.withValues(alpha: .93),
                      t.primary,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 15,
              bottom: 13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${s.homeMysteryRoute.toUpperCase()}  ·  ${s.trackReady}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: .82),
                      fontSize: 8,
                      letterSpacing: .65,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.narrative.trackTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                      letterSpacing: -.65,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.place_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: .85),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${s.homeCity} · ${s.homeDistanceToStart}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: .84),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value.narrative.mysteryBrief,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: .8),
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: isDemo
                            ? Row(
                                children: <Widget>[
                                  _RouteMetric(
                                    value:
                                        NumberFormat.decimalPattern(
                                          Localizations.localeOf(context)
                                              .toLanguageTag(),
                                        ).format(
                                          HomeDashboardPreview.routeDistanceKm,
                                        ),
                                    unit: 'km',
                                  ),
                                  const _MetricDivider(),
                                  _RouteMetric(
                                    value:
                                        '${HomeDashboardPreview.routeMinutes}',
                                    unit: s.homeMinutes,
                                  ),
                                  const _MetricDivider(),
                                  _RouteMetric(
                                    value: '${value.milestones.length}',
                                    unit: s.homeMilestones,
                                  ),
                                ],
                              )
                            : Text(
                                s.trackMilestoneCount(value.milestones.length),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                      ),
                      FilledButton(
                        onPressed: () => onOpen(value.id),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(112, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          backgroundColor: t.accent,
                          foregroundColor: t.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              s.homeCheckTrack,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const MilestracksIcon('arrow', size: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({required this.value, required this.unit});
  final String value;
  final String unit;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          unit,
          style: TextStyle(
            color: Colors.white.withValues(alpha: .8),
            fontSize: 8,
          ),
        ),
      ],
    ),
  );
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 19,
    color: Colors.white.withValues(alpha: .28),
  );
}

class _HomeLoadingCard extends StatelessWidget {
  const _HomeLoadingCard();
  @override
  Widget build(BuildContext context) => Container(
    height: 250,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: context.milestracksTokens.surface,
      borderRadius: BorderRadius.circular(23),
    ),
    child: const CircularProgressIndicator(),
  );
}
