import 'package:ballysfoodbeverage/data/repository/department_repository.dart';
import 'package:flutter/material.dart';

import '../models/department.dart';

import '../services/api_service.dart';

enum DepartmentStatus { idle, loading, loaded, error }

// ── Providers (manual Provider pattern matching your project style) ──────────

final _apiService = ApiService();

final departmentRepository = DepartmentRepository(_apiService);

// ── Notifier ─────────────────────────────────────────────────────────────────

class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository _repository;

  DepartmentProvider(this._repository);

  DepartmentStatus _status = DepartmentStatus.idle;
  List<Department> _departments = [];
  String? _errorMessage;

  DepartmentStatus get status => _status;
  List<Department> get departments => _departments;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == DepartmentStatus.loading;

  Future<void> fetchDepartments() async {
    if (_status == DepartmentStatus.loading) return;

    _status = DepartmentStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _departments = await _repository.fetchDepartments();
      _status = DepartmentStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _status = DepartmentStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _departments = [];
    _status = DepartmentStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}