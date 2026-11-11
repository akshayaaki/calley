import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/utils/local_storage.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  UserModel? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  bool _isLoading = false;
  String? _errorMessage;

  // Temp storage during registration flow before OTP verification
  String? _pendingEmail;
  String? _pendingUsername;
  String? _pendingPhone;
  String? _pendingPassword;

  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get pendingEmail => _pendingEmail;
  String? get pendingUsername => _pendingUsername;
  String? get pendingPhone => _pendingPhone;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    checkSavedSession();
  }

  Future<void> checkSavedSession() async {
    final savedUser = await LocalStorage.getUser();
    if (savedUser != null) {
      _currentUser = savedUser;
      _status = AuthStatus.authenticated;
      notifyListeners();
    }
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
      final user = await _authService.login(email: email, password: password);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      await LocalStorage.saveUser(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> initiateRegistration({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pendingUsername = name;
      _pendingEmail = email;
      _pendingPassword = password;
      _pendingPhone = phone;

      // Register user with backend
      await _authService.register(
        username: name,
        email: email,
        password: password,
        phone: phone,
      );

      // Trigger OTP dispatch
      await _authService.sendOtp(email: email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOtp() async {
    if (_pendingEmail == null) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.sendOtp(email: _pendingEmail!);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtpAndCompleteLogin(String otp) async {
    if (_pendingEmail == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final verified = await _authService.verifyOtp(
        email: _pendingEmail!,
        otp: otp,
      );

      if (verified) {
        // Complete login
        final user = await _authService.login(
          email: _pendingEmail!,
          password: _pendingPassword ?? '123',
        );

        final updatedUser = user.copyWith(
          username: _pendingUsername ?? user.username,
          phone: _pendingPhone ?? user.phone,
        );

        _currentUser = updatedUser;
        _status = AuthStatus.authenticated;
        await LocalStorage.saveUser(updatedUser);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid OTP code. Please check and try again.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    await LocalStorage.clearUser();
    notifyListeners();
  }
}

