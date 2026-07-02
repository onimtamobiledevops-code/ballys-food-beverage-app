import 'package:flutter/material.dart';

import '../data/repository/table_repository.dart';
import '../models/pit_table.dart';

enum TableStatus { idle, loading, loaded, error }

class TableProvider extends ChangeNotifier {
  final TableRepository tableRepository;

  TableProvider({required this.tableRepository});

  TableStatus _status = TableStatus.idle;
  String? _errorMessage;
  List<PitTable> _tables = [];
  String? _pitName;

  TableStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<PitTable> get tables => _tables;
  String? get pitName => _pitName;
  bool get isLoading => _status == TableStatus.loading;

  Future<void> loadTables(String pitName) async {
    if (_status == TableStatus.loading) return;

    _pitName = pitName;
    _status = TableStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _tables = await tableRepository.fetchTables(pitName);
      _status = TableStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load tables: ${e.toString()}';
      _status = TableStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _tables = [];
    _pitName = null;
    _status = TableStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
