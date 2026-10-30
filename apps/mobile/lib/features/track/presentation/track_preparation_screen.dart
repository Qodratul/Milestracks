import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/shop/presentation/shop_providers.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_map.dart';

class TrackPreparationScreen extends ConsumerWidget {
  const TrackPreparationScreen({required this.trackId, super.key});
  final String trackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final track = ref.watch(trackByIdProvider(trackId));
    final tokens = context.milestracksTokens;
    return Scaffold(
      backgroundColor: const Color(0xfff4f7f3),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _PreparationAction(
            onPressed: track.value == null
                ? null
                : () => context.go('/run/${track.value!.id}'),
          ),
          const MilestracksBottomNavigation(
            selected: MainDestination.run,
            homeStyle: true,
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: Column(
              children: <Widget>[
                _PreparationHeader(onBack: () => context.go('/home')),
                Expanded(
                  child: track.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(tokens.pagePadding),
                        child: Text(
                          strings.unknownError,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    data: (value) => _PreparationContent(track: value),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PreparationHeader extends StatelessWidget {
  const _PreparationHeader({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
      child: Row(
        children: <Widget>[
          Semantics(
            button: true,
            label: strings.authBack,
            child: InkWell(
              onTap: onBack,
              customBorder: const CircleBorder(),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffdfe5df)),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xff627268),
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.historyBrand,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xff7b877d),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  strings.trackPreparationTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: -.45,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff24392b),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreparationContent extends ConsumerWidget {
  const _PreparationContent({required this.track});
  final TrackDto track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory =
        ref.watch(userInventoryProvider).value ?? const <InventoryItemDto>[];
    final locale = Localizations.localeOf(context).toLanguageTag();
    final exp = track.milestones.fold<int>(
      0,
      (total, milestone) => total + milestone.expReward,
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      children: <Widget>[
        _PreviewCard(track: track),
        const SizedBox(height: 12),
        _OverviewCard(track: track, totalExp: exp, locale: locale),
        const SizedBox(height: 12),
        _LoadoutCard(items: inventory),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.track});
  final TrackDto track;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(strings.trackSafePreview.toUpperCase(), style: _eyebrow),
          const SizedBox(height: 4),
          Text(track.narrative.trackTitle, style: _sectionTitle(14)),
          const SizedBox(height: 4),
          Text(track.narrative.mysteryBrief, style: _smallBody),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: <Widget>[
                MilestracksMap(track: track, showSafePreview: false),
                Positioned(
                  right: 8,
                  top: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Color(0x1a233d2c), blurRadius: 8),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      child: Text(
                        strings.trackFullMap,
                        style: const TextStyle(
                          fontSize: 8,
                          color: Color(0xff315e40),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          _RouteMarkerLegend(track: track),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(strings.trackStartDetailsHidden, style: _finePrint),
              ),
              const _ReportButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _RouteMarkerLegend extends StatelessWidget {
  const _RouteMarkerLegend({required this.track});

  final TrackDto track;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final startLetter = Localizations.localeOf(context).languageCode == 'id'
        ? 'M'
        : 'S';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 6,
          runSpacing: 5,
          children: <Widget>[
            _RouteMarkerChip(
              marker: startLetter,
              label: strings.trackStartPoint,
              isStart: true,
            ),
            ...track.milestones.map((milestone) {
              final distance = milestone.distanceMeters;
              final label = distance == null
                  ? '${milestone.order}'
                  : '${milestone.order} · ${NumberFormat('0', locale).format(distance)} m';
              return _RouteMarkerChip(
                marker: '${milestone.order}',
                label: label,
              );
            }),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          strings.trackMilestoneDistanceHint,
          style: const TextStyle(fontSize: 8, color: Color(0xff879188)),
        ),
      ],
    );
  }
}

class _RouteMarkerChip extends StatelessWidget {
  const _RouteMarkerChip({
    required this.marker,
    required this.label,
    this.isStart = false,
  });

  final String marker;
  final String label;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 3, 7, 3),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xffe4eae3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isStart ? tokens.primary : tokens.surface,
              shape: BoxShape.circle,
              border: Border.all(color: tokens.primary, width: 1.2),
            ),
            child: Text(
              marker,
              style: TextStyle(
                fontSize: 8,
                height: 1,
                fontWeight: FontWeight.w700,
                color: isStart ? tokens.surface : tokens.primary,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              height: 1,
              fontWeight: FontWeight.w600,
              color: Color(0xff59695d),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportButton extends StatelessWidget {
  const _ReportButton();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      onPressed: () =>
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(strings.trackReportLater))),
      icon: const Icon(Icons.error_outline, size: 14, color: Color(0xffdc5448)),
      label: Text(strings.trackReport),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(70, 34),
        padding: const EdgeInsets.symmetric(horizontal: 9),
        foregroundColor: const Color(0xff6e7b70),
        side: const BorderSide(color: Color(0xffe5eae3)),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 9),
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.track,
    required this.totalExp,
    required this.locale,
  });
  final TrackDto track;
  final int totalExp;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final distance = track.distanceMeters == null
        ? '—'
        : NumberFormat('0.0', locale).format(track.distanceMeters! / 1000);
    return _WhiteCard(
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
                    Text(strings.trackOverviewEyebrow, style: _eyebrow),
                    const SizedBox(height: 4),
                    Text(strings.trackPlanRun, style: _sectionTitle(15)),
                  ],
                ),
              ),
              if (track.safetyScore != null) _SafetyBadge(track: track),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.4,
            children: <Widget>[
              _StatCell(
                label: strings.runDistance,
                value: distance,
                unit: 'km',
              ),
              _StatCell(
                label: strings.trackEstimatedDuration,
                value: track.estimatedDurationMinutes == null
                    ? '—'
                    : NumberFormat.decimalPattern(locale)
                          .format(track.estimatedDurationMinutes),
                unit: strings.runMinutes,
              ),
              _StatCell(
                label: strings.trackMilestones,
                value: NumberFormat.decimalPattern(locale)
                    .format(track.milestones.length),
                unit: totalExp > 0
                    ? '${NumberFormat.decimalPattern(locale).format(totalExp)} EXP'
                    : '',
              ),
              _StatCell(
                label: strings.trackEstimatedCalories,
                value: track.estimatedCalories == null
                    ? '—'
                    : '~${NumberFormat.decimalPattern(locale).format(track.estimatedCalories)}',
                unit: 'kcal',
              ),
            ],
          ),
          _StartPointRow(track: track),
          const SizedBox(height: 8),
          _GuidanceCard(
            icon: Icons.warning_amber_rounded,
            title: strings.trackRouteNote,
            body: track.routeNote ?? track.narrative.preRunTip,
            warning: true,
          ),
          const SizedBox(height: 7),
          _GuidanceCard(
            icon: Icons.access_time,
            title: strings.trackBeforeStart,
            body: track.beforeStartTip ?? track.narrative.preRunTip,
          ),
        ],
      ),
    );
  }
}

class _SafetyBadge extends StatelessWidget {
  const _SafetyBadge({required this.track});
  final TrackDto track;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xffeef5ec),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.shield_outlined, size: 16, color: Color(0xff4a7550)),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                strings.trackSafetyScore(track.safetyScore!),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff35633f),
                ),
              ),
              if (track.safetyConfidence != null)
                Text(
                  strings.trackDataConfidence(track.safetyConfidence!),
                  style: const TextStyle(fontSize: 7, color: Color(0xff728274)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.label,
    required this.value,
    required this.unit,
  });
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(9, 7, 5, 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 7,
            letterSpacing: .7,
            fontWeight: FontWeight.w700,
            color: Color(0xff7b877d),
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            text: value,
            style: const TextStyle(
              fontSize: 17,
              height: 1,
              fontWeight: FontWeight.w700,
              color: Color(0xff293d30),
            ),
            children: <InlineSpan>[
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff77847a),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StartPointRow extends StatelessWidget {
  const _StartPointRow({required this.track});
  final TrackDto track;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final distance = track.distanceToStartMeters;
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffedf0eb))),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: Color(0xff5a765d),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  strings.trackStartPoint,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff3a4b3e),
                  ),
                ),
                if (distance != null)
                  Text(
                    strings.trackAboutStart(distance),
                    style: const TextStyle(
                      fontSize: 8,
                      color: Color(0xff7d887f),
                    ),
                  ),
              ],
            ),
          ),
          if (distance != null)
            Text(
              strings.trackMeters(distance),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xff3b6744),
              ),
            ),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({
    required this.icon,
    required this.title,
    required this.body,
    this.warning = false,
  });
  final IconData icon;
  final String title;
  final String body;
  final bool warning;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      color: warning ? const Color(0xfffbf7ed) : const Color(0xfff1f6ef),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          size: 17,
          color: warning ? const Color(0xffa18447) : const Color(0xff5e8061),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff405145),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 8.5,
                  height: 1.35,
                  color: Color(0xff748177),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LoadoutCard extends StatelessWidget {
  const _LoadoutCard({required this.items});
  final List<InventoryItemDto> items;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final equipped = items.where((item) => item.equipped).toList();
    return _WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(strings.trackRunLoadout, style: _sectionTitle(15)),
                    const SizedBox(height: 3),
                    Text(strings.trackLoadoutDescription, style: _finePrint),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(strings.trackLoadoutUnavailable)),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(70, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  foregroundColor: const Color(0xff4d7052),
                  side: const BorderSide(color: Color(0xffe4eae2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  strings.trackEditLoadout,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          for (final item in equipped) _EquippedItem(item: item),
          const SizedBox(height: 5),
          Text(strings.trackStreakFreezeNote, style: _finePrint),
        ],
      ),
    );
  }
}

class _EquippedItem extends StatelessWidget {
  const _EquippedItem({required this.item});
  final InventoryItemDto item;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 9),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffedf0eb))),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xffeff5ed),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                switch (item.itemId) {
                  'exp_boost' => Icons.bolt,
                  'less_compensation' => Icons.shield_outlined,
                  _ => Icons.route,
                },
                size: 18,
                color: const Color(0xff4a7550),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.itemId == 'exp_boost'
                      ? strings.trackExpBoost
                      : strings.trackRouteModifier,
                  style: const TextStyle(
                    fontSize: 7,
                    letterSpacing: .5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff839087),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff34483a),
                  ),
                ),
              ],
            ),
          ),
          Text(
            strings.trackEquippedCount(1),
            style: const TextStyle(fontSize: 8, color: Color(0xff7b877d)),
          ),
        ],
      ),
    );
  }
}

class _PreparationAction extends StatelessWidget {
  const _PreparationAction({required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0x00f4f7f3), Color(0xf7f4f7f3)],
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.play_arrow, size: 17),
          label: Text(
            strings.trackStartRunNextStage,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xff315e40),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
        ),
      ),
    );
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({
    required this.child,
    this.padding = const EdgeInsets.all(13),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xffe2e9e0)),
      borderRadius: BorderRadius.circular(21),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0a1f3b27),
          blurRadius: 17,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: child,
  );
}

const _eyebrow = TextStyle(
  fontSize: 8,
  letterSpacing: 1,
  fontWeight: FontWeight.w800,
  color: Color(0xff77847a),
);
const _smallBody = TextStyle(
  fontSize: 10,
  height: 1.4,
  color: Color(0xff78847b),
);
const _finePrint = TextStyle(
  fontSize: 8,
  height: 1.35,
  color: Color(0xff818b83),
);
TextStyle _sectionTitle(double size) => TextStyle(
  fontSize: size,
  height: 1.2,
  letterSpacing: -.25,
  fontWeight: FontWeight.w700,
  color: const Color(0xff263a2d),
);
