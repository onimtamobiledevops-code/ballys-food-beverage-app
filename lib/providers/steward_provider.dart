import 'package:flutter/material.dart';

import '../data/repository/steward_repository.dart';
import '../models/steward.dart';

enum StewardStatus { idle, loading, loaded, error }

class StewardProvider extends ChangeNotifier {
  final StewardRepository stewardRepository;

  StewardProvider({required this.stewardRepository});

  StewardStatus _status = StewardStatus.idle;
  String? _errorMessage;
  List<Steward> _stewards = [];

  StewardStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Steward> get stewards => _stewards;
  List<Steward> get activeStewards =>
      _stewards.where((s) => s.isActive).toList();
  bool get isLoading => _status == StewardStatus.loading;

  Future<void> loadStewards({String searchText = ''}) async {
    if (_status == StewardStatus.loading) return;

    _status = StewardStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _stewards = await stewardRepository.fetchStewards(searchText: searchText);
      _status = StewardStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load stewards: ${e.toString()}';
      _status = StewardStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _stewards = [];
    _status = StewardStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}