import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';

/// Centralized route names and route generation for the app.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String home = '/home';

  /// The route the app starts on.
  static const String initialRoute = login;

  /// Generates routes based on the requested [settings.name].
  ///
  /// Used as the `onGenerateRoute` callback of [MaterialApp], so all
  /// navigation goes through `Navigator.pushNamed(context, AppRoutes.xxx)`.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(const LoginScreen(), settings);
      case home:
        return _buildRoute(const HomeScreen(), settings);
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
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    );
  }
}
