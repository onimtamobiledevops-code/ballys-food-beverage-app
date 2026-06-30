import 'package:flutter/material.dart';

import '../widgets/app_side_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'tabs/home_tab.dart';
import 'tabs/menu_tab.dart';
import 'tabs/orders_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    "BALLYS",
    'Menu',
    'My Orders',
    'Profile',
    'stu'
  ];

  void _onSelectTab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeTab(),
      const MenuTab(),
      const OrdersTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: AppSideDrawer(
        selectedIndex: _selectedIndex,
        onSelectTab: _onSelectTab,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onSelectTab,
      ),
    );
  }
}