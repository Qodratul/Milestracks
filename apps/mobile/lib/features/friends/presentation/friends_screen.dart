import 'package:flutter/material.dart';
import 'package:milestracks/features/league/presentation/placeholder_screen.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/coming_soon_view.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key, this.showBottomNavigation = true});
  final bool showBottomNavigation;
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    // TODO: Add Friends data only in a later phase after product approval.
    return PlaceholderScreen(
      title: strings.navFriends,
      destination: MainDestination.friends,
      showBottomNavigation: showBottomNavigation,
      body: ComingSoonView(
        kind: ComingSoonKind.friends,
        title: strings.friendsComingSoonTitle,
        description: strings.friendsComingSoonBody,
        semanticsLabel: strings.friendsComingSoonSemantics,
      ),
    );
  }
}
