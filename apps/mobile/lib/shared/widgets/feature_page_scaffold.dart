import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';

class FeaturePageScaffold extends StatelessWidget {
  const FeaturePageScaffold({
    required this.title,
    required this.destination,
    required this.body,
    super.key,
    this.actions = const <Widget>[],
    this.appBarBottom,
    this.floatingActionButton,
    this.showBottomNavigation = true,
  });

  final String title;
  final MainDestination destination;
  final Widget body;
  final List<Widget> actions;
  final PreferredSizeWidget? appBarBottom;
  final Widget? floatingActionButton;
  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        bottom: appBarBottom,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: body,
          ),
        ),
      ),
      bottomNavigationBar: showBottomNavigation
          ? MilestracksBottomNavigation(selected: destination, homeStyle: true)
          : null,
      floatingActionButton: floatingActionButton,
    );
  }
}
