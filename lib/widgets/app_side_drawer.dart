import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  static const List<_DrawerItem> _items = [
    _DrawerItem(icon: Icons.home_outlined,           activeIcon: Icons.home,              label: 'Home',               index: 0),
    _DrawerItem(icon: Icons.restaurant_menu_outlined, activeIcon: Icons.restaurant_menu,   label: 'Current Orders',     index: 1),
    _DrawerItem(icon: Icons.receipt_long_outlined,   activeIcon: Icons.receipt_long,      label: 'Past Orders',        index:2),
    _DrawerItem(icon: Icons.language_outlined,       activeIcon: Icons.language,          label: 'KOT Web Orders',     index: 3),
    _DrawerItem(icon: Icons.room_service_outlined,   activeIcon: Icons.room_service,      label: 'Steward',            index: 99),
    _DrawerItem(icon: Icons.people_outline,          activeIcon: Icons.people,            label: 'Guest',              index: 2),
    _DrawerItem(icon: Icons.table_bar_outlined,      activeIcon: Icons.table_bar,         label: 'Pits',               index: 2),
    _DrawerItem(icon: Icons.note_alt_outlined,       activeIcon: Icons.note_alt,          label: 'Issue Note',         index: 3),
    _DrawerItem(icon: Icons.notifications_off_outlined, activeIcon: Icons.notifications_off, label: 'Clear Notification', index: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

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
                children: _items.map((item) {
                  final isSelected = selectedIndex == item.index;
                  return ListTile(
                    leading: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.greyText,
                    ),
                    title: Text(
                      item.label,
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
                    // onTap: () {
                    //   Navigator.pop(context);
                    //   onSelectTab(item.index);
                    // },
                    onTap: () {
  Navigator.pop(context);
  if (item.label == 'Steward') {
    Navigator.pushNamed(context, AppRoutes.steward);
  } else {
    onSelectTab(item.index);
  }
},
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

class _DrawerItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;

  const _DrawerItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
}