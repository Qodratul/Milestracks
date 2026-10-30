import 'package:flutter/material.dart';
import 'package:milestracks/shared/widgets/feature_page_scaffold.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    required this.destination,
    required this.body,
    super.key,
    this.showBottomNavigation = true,
  });
  final String title;
  final MainDestination destination;
  final Widget body;
  final bool showBottomNavigation;
  @override
  Widget build(BuildContext context) => FeaturePageScaffold(
    title: title,
    destination: destination,
    body: body,
    showBottomNavigation: showBottomNavigation,
  );
}
