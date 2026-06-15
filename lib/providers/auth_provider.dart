import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Handles authentication state for the app using the Provider pattern.
///
/// This is a mock implementation (no real backend). Replace [login] with
/// an actual API call when integrating with a real authentication service.
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  /// Attempts to log the user in with the given [email] and [password].
  ///
  /// Returns `true` on success, `false` on failure. Sets [errorMessage]
  /// when authentication fails.
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network/auth delay.
    await Future.delayed(const Duration(milliseconds: 1200));

    // Simple mock validation - replace with real authentication logic.
    if (email.trim().isEmpty || password.trim().isEmpty) {
      _errorMessage = 'Please enter both email and password.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 4) {
      _errorMessage = 'Password must be at least 4 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Mock successful login.
    _currentUser = UserModel(
      name: email.split('@').first,
      email: email.trim(),
    );
    _isLoggedIn = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Logs the current user out and resets the auth state.
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears any existing error message (e.g. when the user edits a field).
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
