// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String _apiUrl = 'https://example.com/api'; // Replace with  actual API URL

  // Sign up user
  Future<bool> signUp(User user) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return true; // Successfully signed up
    } else {
      return false; // Failed to sign up
    }
  }

  // Sign in user
  Future<bool> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    return response.statusCode == 200;
  }
}
