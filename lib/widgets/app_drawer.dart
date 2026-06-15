import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';

/// Side navigation drawer for the Home shell.
///
/// [selectedIndex] highlights the tab matching the bottom navigation bar.
/// [onSelectTab] is called when the user taps one of the primary tabs
/// (Home, Menu, Orders, Profile) so the shell can sync the bottom bar.
class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Drawer(
      backgroundColor: AppColors.black,
      child: SafeArea(
        child: Column(
          children: [
           // _buildHeader(user?.name, user?.email),
            const SizedBox(height: 8),
            _buildTile(
              context,
              icon: Icons.home_outlined,
              label: 'Home',
              index: 0,
            ),
            _buildTile(
              context,
              icon: Icons.restaurant_menu_outlined,
              label: 'Menu',
              index: 1,
            ),
            _buildTile(
              context,
              icon: Icons.receipt_long_outlined,
              label: 'My Orders',
              index: 2,
            ),
            _buildTile(
              context,
              icon: Icons.person_outline,
              label: 'Profile',
              index: 3,
            ),
            const Divider(color: AppColors.surfaceBlackLight, height: 24),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: AppColors.greyText),
              title: const Text('Favorites', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.local_offer_outlined, color: AppColors.greyText),
              title: const Text('Offers & Deals', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.greyText),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: AppColors.greyText),
              title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            const Divider(color: AppColors.surfaceBlackLight, height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryRed),
              title: const Text(
                'Log out',
                style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthProvider>().logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String? name, String? email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              (name?.isNotEmpty ?? false) ? name![0].toUpperCase() : 'B',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Guest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = index == selectedIndex;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryOrange : AppColors.greyText,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.greyText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.surfaceBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () {
        onSelectTab(index);
        Navigator.pop(context);
      },
    );
  }
}
