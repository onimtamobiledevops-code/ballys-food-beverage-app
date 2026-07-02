import 'package:flutter/material.dart';

import '../data/repository/pit_repository.dart';
import '../models/pit.dart';

enum PitStatus { idle, loading, loaded, error }

class PitProvider extends ChangeNotifier {
  final PitRepository pitRepository;

  PitProvider({required this.pitRepository});

  PitStatus _status = PitStatus.idle;
  String? _errorMessage;
  List<Pit> _pits = [];

  PitStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Pit> get pits => _pits;
  bool get isLoading => _status == PitStatus.loading;

  Future<void> loadPits() async {
    if (_status == PitStatus.loading) return;

    _status = PitStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pits = await pitRepository.fetchPits();
      _status = PitStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load pits: ${e.toString()}';
      _status = PitStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _pits = [];
    _status = PitStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
