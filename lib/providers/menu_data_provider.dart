import 'package:ballysfoodbeverage/data/repository/category_repository.dart';
import 'package:ballysfoodbeverage/data/repository/department_repository.dart';
import 'package:ballysfoodbeverage/data/repository/item_repository.dart';
import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/department.dart';
import '../models/item.dart';


enum MenuDataStatus { idle, loading, loaded, error }

class MenuDataProvider extends ChangeNotifier {
  final DepartmentRepository departmentRepository;
  final CategoryRepository categoryRepository;
  final ItemRepository itemRepository;

  MenuDataProvider({
    required this.departmentRepository,
    required this.categoryRepository,
    required this.itemRepository,
  });

  MenuDataStatus _status = MenuDataStatus.idle;
  String? _errorMessage;

  List<Department> _departments = [];

  // deptCode → categories
  Map<String, List<Category>> _categoriesByDept = {};

  // catCode → items
  Map<String, List<Item>> _itemsByCat = {};

  MenuDataStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Department> get departments => _departments;
  Map<String, List<Category>> get categoriesByDept => _categoriesByDept;
  Map<String, List<Item>> get itemsByCat => _itemsByCat;
  bool get isLoading => _status == MenuDataStatus.loading;

  List<Category> categoriesOf(String deptCode) =>
      _categoriesByDept[deptCode] ?? [];

  List<Item> itemsOf(String catCode) => _itemsByCat[catCode] ?? [];
List<Category> get allCategories =>
      _categoriesByDept.values.expand((c) => c).toList();

  List<Item> get allItems =>
      _itemsByCat.values.expand((i) => i).toList();
  /// Call this once after a successful login.
  /// Fetches departments → then categories for each dept →
  /// then items for each category, all sequentially.
  Future<void> loadAll() async {
    if (_status == MenuDataStatus.loading) return;

    _status = MenuDataStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1 — departments
      _departments = await departmentRepository.fetchDepartments();

      // Step 2 — categories for every department (parallel)
      final catResults = await Future.wait(
        _departments.map((d) => categoryRepository
            .fetchCategories(d.deptCode)
            .catchError((_) => <Category>[])),
      );

      _categoriesByDept = {
        for (int i = 0; i < _departments.length; i++)
          _departments[i].deptCode: catResults[i],
      };

      // Step 3 — items for every category (parallel)
      final allCategories = catResults.expand((c) => c).toList();

      final itemResults = await Future.wait(
        allCategories.map((c) => itemRepository
            .fetchItems(c.deptCode, c.catCode)
            .catchError((_) => <Item>[])),
      );

      _itemsByCat = {
        for (int i = 0; i < allCategories.length; i++)
          allCategories[i].catCode: itemResults[i],
      };

      _status = MenuDataStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load menu data: ${e.toString()}';
      _status = MenuDataStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _departments = [];
    _categoriesByDept = {};
    _itemsByCat = {};
    _status = MenuDataStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}