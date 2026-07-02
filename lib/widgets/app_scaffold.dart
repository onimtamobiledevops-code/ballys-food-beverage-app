import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import 'app_side_drawer.dart';
import 'bottom_nav_bar.dart';

/// A reusable app shell that shows the side drawer and the bottom navigation
/// bar on every screen that uses it.
///
/// Tapping a bottom-bar or drawer item from a secondary screen returns to the
/// [HomeScreen] with the matching tab selected. Pass [selectedIndex] to
/// highlight the active tab, or leave it as `-1` when the current screen does
/// not correspond to a bottom-bar tab.
class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int selectedIndex;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.selectedIndex = -1,
    this.actions,
    this.backgroundColor,
  });

  void _goToTab(BuildContext context, int index) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: AppSideDrawer(
        selectedIndex: selectedIndex,
        onSelectTab: (index) => _goToTab(context, index),
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) => _goToTab(context, index),
      ),
    );
  }
}
