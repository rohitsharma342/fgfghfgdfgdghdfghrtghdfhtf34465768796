import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  AuthController() {
    _currentUser = _authService.currentUser;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);
      
      if (result['success'] == true) {
        _currentUser = result['user'] as UserModel;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] as String;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.register(name, email, password);
      
      if (result['success'] == true) {
        _currentUser = result['user'] as UserModel;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['error'] as String;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  void updateProfile(UserModel updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}