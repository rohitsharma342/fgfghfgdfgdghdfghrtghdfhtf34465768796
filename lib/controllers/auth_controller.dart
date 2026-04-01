import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/static_data_service.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthController extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthState get state => _state;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;

  Future<void> checkAuthStatus() async {
    _state = AuthState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    _currentUser = StaticDataService.currentUser;
    _state = AuthState.authenticated;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    if (!_isValidEmail(email)) {
      _errorMessage = 'Please enter a valid email address';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match';
      _state = AuthState.error;
      notifyListeners();
      return false;
    }

    _currentUser = UserModel(
      id: 'new_user',
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
    _state = AuthState.authenticated;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}