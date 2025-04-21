// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // Use environment variable or configuration for base URL
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8001',
  );
  static const String tokenKey = 'auth_token';
  static const Duration tokenExpiryDuration = Duration(hours: 1);

  // Input validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  Future<String?> login(String email, String password) async {
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }
    if (!_isValidPassword(password)) {
      throw Exception('Password must be at least 8 characters long');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];
        final expiryTime = DateTime.now().add(tokenExpiryDuration);
        await _saveToken(token, expiryTime);
        return token;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to login');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error occurred. Please try again.');
    }
  }

  Future<String?> signup(String email, String password, String fullName, String role) async {
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address');
    }
    if (!_isValidPassword(password)) {
      throw Exception('Password must be at least 8 characters long');
    }
    if (fullName.isEmpty) {
      throw Exception('Please enter your full name');
    }
    if (!['victim', 'volunteer', 'ngo'].contains(role.toLowerCase())) {
      throw Exception('Invalid role selected');
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'full_name': fullName,
          'role': role.toLowerCase(),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['access_token'];
        final expiryTime = DateTime.now().add(tokenExpiryDuration);
        await _saveToken(token, expiryTime);
        return token;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to signup');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Network error occurred. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove('${tokenKey}_expiry');
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(tokenKey);
      final expiryString = prefs.getString('${tokenKey}_expiry');
      
      if (token == null || expiryString == null) return null;
      
      final expiryTime = DateTime.parse(expiryString);
      if (DateTime.now().isAfter(expiryTime)) {
        await logout();
        return null;
      }
      
      return token;
    } catch (e) {
      debugPrint('Error getting token: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> _saveToken(String token, DateTime expiryTime) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(tokenKey, token);
      await prefs.setString('${tokenKey}_expiry', expiryTime.toIso8601String());
    } catch (e) {
      debugPrint('Error saving token: $e');
      throw Exception('Failed to save authentication data');
    }
  }
}
