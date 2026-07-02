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

  /// When `false`, the side drawer is hidden and the app bar shows a back
  /// button instead of the menu (hamburger) icon. The bottom bar still shows.
  final bool showDrawer;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.selectedIndex = -1,
    this.actions,
    this.backgroundColor,
    this.showDrawer = true,
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
      // With no drawer, AppBar automatically shows the back button when the
      // route can be popped.
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: showDrawer
          ? AppSideDrawer(
              selectedIndex: selectedIndex,
              onSelectTab: (index) => _goToTab(context, index),
            )
          : null,
      body: SafeArea(child: body),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) => _goToTab(context, index),
      ),
    );
  }
}
