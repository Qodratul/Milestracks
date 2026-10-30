import 'package:flutter/material.dart';
import 'package:milestracks/features/league/presentation/placeholder_screen.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/coming_soon_view.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';

class LeagueScreen extends StatelessWidget {
  const LeagueScreen({super.key, this.showBottomNavigation = true});
  final bool showBottomNavigation;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    // TODO: Add League data only in a later phase after product approval.
    return PlaceholderScreen(
      title: strings.navLeague,
      destination: MainDestination.league,
      showBottomNavigation: showBottomNavigation,
      body: ComingSoonView(
        kind: ComingSoonKind.league,
        title: strings.leagueComingSoonTitle,
        description: strings.leagueComingSoonBody,
        semanticsLabel: strings.leagueComingSoonSemantics,
      ),
    );
  }
}
