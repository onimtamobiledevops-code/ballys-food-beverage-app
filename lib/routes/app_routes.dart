import 'package:ballysfoodbeverage/screens/steward_screen.dart';
import 'package:ballysfoodbeverage/screens/pits_screen.dart';
import 'package:ballysfoodbeverage/screens/tables_screen.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/department.dart';
import '../screens/category_screen.dart';
import '../screens/home_screen.dart';
import '../screens/item_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String items = '/items';
static const String steward = '/steward';
  static const String pits = '/pits';
  static const String tables = '/tables';
  static const String initialRoute = splash;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen(), settings);
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case home:
        final initialIndex = settings.arguments is int
            ? settings.arguments as int
            : 0;
        return _buildRoute(HomeScreen(initialIndex: initialIndex), settings);
      case categories:
        final department = settings.arguments as Department;

        return _buildRoute(
          CategoryScreen(department: department),
          settings,
        );
      case items:
        final category = settings.arguments as Category;
        return _buildRoute(ItemScreen(category: category), settings);
      case steward:
        return MaterialPageRoute(builder: (_) => const StewardScreen());
      case pits:
        return _buildRoute(const PitsScreen(), settings);
      case tables:
        final pitName = settings.arguments as String;
        return _buildRoute(TablesScreen(pitName: pitName), settings);
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