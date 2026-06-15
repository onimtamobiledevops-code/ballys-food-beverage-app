import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import 'tabs/home_tab.dart';
import 'tabs/menu_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/profile_tab.dart';

/// Main Home shell.
///
/// Combines a side [AppDrawer] with a [BottomNavigationBar]. Both controls
/// stay in sync via [_selectedIndex] - tapping a drawer item updates the
/// bottom bar and vice versa.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = ['BALLY\'S', 'Menu', 'My Orders', 'Profile'];

  void _onSelectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(onViewMenu: () => _onSelectTab(1)),
      const MenuTab(),
      const OrdersTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onSelectTab: _onSelectTab,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
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
          currentIndex: _selectedIndex,
          onTap: _onSelectTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surfaceBlack,
          selectedItemColor: AppColors.primaryOrange,
          unselectedItemColor: AppColors.greyText,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
