import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _authToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get authToken => _authToken;

  /// Logs in the user and saves the token in SharedPreferences.
  Future<void> login(String token) async {
    try {
      _authToken = token;
      _isLoggedIn = true;
      notifyListeners();

      // Save token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
    } catch (e) {
      // Handle any potential errors during login
      throw Exception('Failed to save login state: $e');
    }
  }

  /// Logs out the user and clears the token from SharedPreferences.
  Future<void> logout() async {
    try {
      _authToken = null;
      _isLoggedIn = false;
      notifyListeners();

      // Clear token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
    } catch (e) {
      // Handle any potential errors during logout
      throw Exception('Failed to clear login state: $e');
    }
  }

  /// Checks if the user is logged in by retrieving the token from SharedPreferences.
  Future<void> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('authToken')) {
        _authToken = prefs.getString('authToken');
        _isLoggedIn = true;
      } else {
        _authToken = null;
        _isLoggedIn = false;
      }
      notifyListeners();
    } catch (e) {
      // Handle any potential errors during login status check
      throw Exception('Failed to check login status: $e');
    }
  }
}
