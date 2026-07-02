import 'package:flutter/material.dart';

import '../routes/app_routes.dart';

/// A single navigation destination, shown in the side drawer and/or the
/// bottom navigation bar.
///
/// A destination is one of two kinds:
///  - a **tab** inside [HomeScreen] — has a non-null [tabIndex]; selecting it
///    swaps the `IndexedStack` page instead of pushing a new route;
///  - a **standalone route** — has a non-null [route]; selecting it pushes a
///    named route on top of the navigator.
///
/// This is the *single source of truth* for navigation. The drawer and the
/// bottom bar both render from [kAppDestinations], so there are no duplicated
/// index values and no label string-matching anywhere in the UI.
class AppDestination {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  /// Non-null when this destination is a [HomeScreen] tab.
  final int? tabIndex;

  /// Non-null when this destination is a pushed named route.
  final String? route;

  /// Whether this destination appears in the bottom navigation bar.
  final bool inBottomBar;

  const AppDestination({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.tabIndex,
    this.route,
    this.inBottomBar = false,
  }) : assert(tabIndex != null || route != null,
            'A destination must be either a tab or a route.');

  bool get isTab => tabIndex != null;
}

/// The full list of navigation destinations, in display order.
///
/// The first four are the [HomeScreen] tabs (also shown in the bottom bar);
/// the rest are standalone routes shown only in the drawer.
const List<AppDestination> kAppDestinations = [
  AppDestination(
    label: 'Home',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    tabIndex: 0,
    inBottomBar: true,
  ),
  AppDestination(
    label: 'Menu',
    icon: Icons.restaurant_menu_outlined,
    activeIcon: Icons.restaurant_menu,
    tabIndex: 1,
    inBottomBar: true,
  ),
  AppDestination(
    label: 'Orders',
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long,
    tabIndex: 2,
    inBottomBar: true,
  ),
  AppDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings,
    tabIndex: 3,
    inBottomBar: true,
  ),
  AppDestination(
    label: 'Steward',
    icon: Icons.room_service_outlined,
    activeIcon: Icons.room_service,
    route: AppRoutes.steward,
  ),
  AppDestination(
    label: 'Pits',
    icon: Icons.table_bar_outlined,
    activeIcon: Icons.table_bar,
    route: AppRoutes.pits,
  ),
];

/// Destinations that appear in the bottom navigation bar, in order.
List<AppDestination> get kBottomBarDestinations =>
    kAppDestinations.where((d) => d.inBottomBar).toList(growable: false);
