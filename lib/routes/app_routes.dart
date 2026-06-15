import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/department.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/item_screen.dart';
import '../screens/login_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String items = '/items';

  static const String initialRoute = login;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(const LoginScreen(), settings);

      case home:
        return _buildRoute(const HomeScreen(), settings);

      case categories:
        final department = settings.arguments as Department;
        return _buildRoute(
          CategoryScreen(department: department),
          settings,
        );

      case items:
        final category = settings.arguments as Category;
        return _buildRoute(ItemScreen(category: category), settings);

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings,
        );
    }
  }

  static Route<dynamic> _buildRoute(Widget child, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );
  }
}