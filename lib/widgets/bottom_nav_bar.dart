import 'package:flutter/material.dart';

import '../navigation/app_destinations.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = kBottomBarDestinations;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          // Clamp so screens that aren't a bottom-bar tab (selectedIndex == -1)
          // don't crash BottomNavigationBar.
          currentIndex: (selectedIndex >= 0 && selectedIndex < destinations.length)
              ? selectedIndex
              : 0,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceBlack,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.greyText,
          showUnselectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: [
            for (final d in destinations)
              BottomNavigationBarItem(
                icon: Icon(d.icon),
                activeIcon: Icon(d.activeIcon),
                label: d.label,
              ),
          ],
        ),
      ),
    );
  }
}
