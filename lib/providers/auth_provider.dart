import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/device_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;

  AuthProvider(this._apiService);

  static const String _userKey = 'auth_user';

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  Future<bool> login(String password) async {
    _setLoading(true);

    try {
      final deviceId = await DeviceService.getDeviceId();
      // Step 1 — login
      final loginRes = await _apiService.post('CommonExecute', {
        "HasReturnData": "T",
        "Parameters": [
          {
            "Para_Data": "1",
            "Para_Direction": "Input",
            "Para_Lenth": 1,
            "Para_Name": "@Iid",
            "Para_Type": "int",
          },
          {
            "Para_Data": password.trim(),
            "Para_Direction": "Input",
            "Para_Lenth": 100,
            "Para_Name": "@Text2",
            "Para_Type": "varchar",
          },
          {
            "Para_Data": deviceId,
            "Para_Direction": "Input",
            "Para_Lenth": 100,
            "Para_Name": "@Text3",
            "Para_Type": "varchar",
          },
        ],
        "SpName": "sp_Android_Common_API",
        "con": "1",
      });

      final loginRow = _firstRow(loginRes);
      if (loginRow == null) return _fail('Unexpected response from server.');
      if ((loginRow['ReturnMSG'] as String?) != 'T') {
        return _fail('Incorrect password. Please try again.');
      }

      final empName = loginRow['Emp_Name'] as String? ?? '';
      final secLevel = (loginRow['Sec_Lvl'] as num?)?.toInt() ?? 0;

      // Step 2 — device check
      final deviceRes = await _apiService.post('CommonExecute', {
        "HasReturnData": "T",
        "Parameters": [
          {
            "Para_Data": "2",
            "Para_Direction": "Input",
            "Para_Lenth": 1,
            "Para_Name": "@Iid",
            "Para_Type": "int",
          },
          {
            "Para_Data": "e3010a59df78cdae",
            "Para_Direction": "Input",
            "Para_Lenth": 100,
            "Para_Name": "@Text1",
            "Para_Type": "varchar",
          },
        ],
        "SpName": "sp_Android_Common_API",
        "con": "1",
      });

      final deviceRow = _firstRow(deviceRes);
      if (deviceRow == null) return _fail('Device verification failed.');
      if ((deviceRow['CheckDeviceID'] as String?) != 'T') {
        return _fail('This device is not registered. Please contact support.');
      }

      _currentUser = UserModel(
        name: empName,
        secLevel: secLevel,
        deviceId: (deviceRow['Device_Id'] as num?)?.toInt() ?? 0,
        docNo: deviceRow['Doc_No']?.toString() ?? '',
      );
      _isLoggedIn = true;
      _isLoading = false;
      await _persistSession(_currentUser!);
      notifyListeners();
      return true;
    } catch (e) {
      return _fail('Connection error: ${e.toString()}');
    }
  }

  /// Restores a previously saved session from local storage.
  ///
  /// Call this on app start (splash) before deciding which screen to show.
  /// Returns `true` if a saved user was found and restored.
  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_userKey);
      if (raw == null) return false;

      _currentUser =
          UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;
    await _clearSession();
    notifyListeners();
  }

  Future<void> _persistSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }

  bool _fail(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Map<String, dynamic>? _firstRow(Map<String, dynamic> response) {
    try {
      final table =
          (response['CommonResult'] as Map<String, dynamic>?)?['Table']
              as List<dynamic>?;
      if (table == null || table.isEmpty) return null;
      return table.first as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}