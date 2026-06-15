import 'package:ballysfoodbeverage/data/repository/department_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/department_provider.dart';

import 'routes/app_routes.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const BallysApp());
}

class BallysApp extends StatelessWidget {
  const BallysApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(ApiService())),
        ChangeNotifierProvider(
          create: (_) => DepartmentProvider(
            DepartmentRepository(apiService),
          ),
        ),
      ],
      child: MaterialApp(
        title: "Bally's Food & Beverage",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.initialRoute,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}