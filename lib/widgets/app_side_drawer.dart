import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../navigation/app_destinations.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

class AppSideDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;

  const AppSideDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: AppColors.surfaceBlack,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.restaurant,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Guest',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          "Bally's F&B",
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.surfaceBlackLight, height: 1),
            const SizedBox(height: 8),

            // ── Nav items ────────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: kAppDestinations.map((dest) {
                  final isSelected = dest.isTab
                      ? (currentRoute == AppRoutes.home &&
                          dest.tabIndex == selectedIndex)
                      : (dest.route == currentRoute);
                  return ListTile(
                    leading: Icon(
                      isSelected ? dest.activeIcon : dest.icon,
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.greyText,
                    ),
                    title: Text(
                      dest.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.greyText,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor:
                        AppColors.primaryOrange.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () => _onDestinationTap(context, dest, currentRoute),
                  );
                }).toList(),
              ),
            ),

            const Divider(color: AppColors.surfaceBlackLight, height: 1),

            // ── Logout ───────────────────────────────────────────────────────
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryRed),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppColors.primaryRed),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

extension on AppSideDrawer {
  /// Handles a tap on a drawer destination.
  ///
  /// - Tab destinations swap the [HomeScreen] tab via [onSelectTab].
  /// - Route destinations push their named route (unless already there).
  void _onDestinationTap(
    BuildContext context,
    AppDestination dest,
    String? currentRoute,
  ) {
    Navigator.pop(context); // close the drawer first
    if (dest.isTab) {
      onSelectTab(dest.tabIndex!);
    } else if (dest.route != null && dest.route != currentRoute) {
      Navigator.pushNamed(context, dest.route!);
    }
  }
}