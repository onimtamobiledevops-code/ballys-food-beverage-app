import 'package:ballysfoodbeverage/data/repository/category_repository.dart';
import 'package:ballysfoodbeverage/data/repository/department_repository.dart';
import 'package:ballysfoodbeverage/data/repository/item_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/department_provider.dart';
import 'providers/menu_data_provider.dart';

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
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        // ChangeNotifierProvider(
        //   create: (_) => DepartmentProvider(
        //     DepartmentRepository(apiService),
        //   ),
        // ),
        ChangeNotifierProvider(
          create: (_) => MenuDataProvider(
            departmentRepository: DepartmentRepository(apiService),
            categoryRepository: CategoryRepository(apiService),
            itemRepository: ItemRepository(apiService),
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
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