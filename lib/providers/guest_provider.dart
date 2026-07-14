import 'package:flutter/material.dart';

import '../data/repository/guest_repository.dart';
import '../models/guest.dart';

enum GuestStatus { idle, loading, loaded, error }

class GuestProvider extends ChangeNotifier {
  final GuestRepository guestRepository;

  GuestProvider({required this.guestRepository});

  GuestStatus _status = GuestStatus.idle;
  String? _errorMessage;
  List<Guest> _guests = [];
  String? _tblCode;

  GuestStatus get status => _status;
  String? get errorMessage => _errorMessage;
  List<Guest> get guests => _guests;
  String? get tblCode => _tblCode;
  bool get isLoading => _status == GuestStatus.loading;

  Future<void> loadGuests(String tblCode) async {
    if (_status == GuestStatus.loading) return;

    _tblCode = tblCode;
    _status = GuestStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _guests = await guestRepository.fetchGuests(tblCode);
      _status = GuestStatus.loaded;
    } catch (e) {
      _errorMessage = 'Failed to load guests: ${e.toString()}';
      _status = GuestStatus.error;
    }

    notifyListeners();
  }

  void reset() {
    _guests = [];
    _tblCode = null;
    _status = GuestStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
