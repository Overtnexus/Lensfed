import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lensfed/Services/Authservise.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _firebaseUser;
  Map<String, dynamic>? _userData;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authService.userChanges.listen((user) {
      _firebaseUser = user;
      notifyListeners();
    });
  }

  // ================= REGISTER =================
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String role,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final userData = await _authService.register(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        role: role,
      );

      _userData = userData;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = "Registration failed";
      _setLoading(false);
      return false;
    }
  }

  // ================= LOGIN =================
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final userData = await _authService.login(email, password);

      _userData = userData;
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = "Login failed";
      _setLoading(false);
      return false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _authService.logout();
    _firebaseUser = null;
    _userData = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}