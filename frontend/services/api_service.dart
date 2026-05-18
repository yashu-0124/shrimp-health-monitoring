import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// API Service
/// Handles all API calls to the backend server
class ApiService {
  // Production API Base URL
  static const String baseUrl =
      'https://aqabackend-9llxvgslt-adithyavennas-projects.vercel.app';

  /// Signup - Register new user
  /// POST /api/auth/signup
  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String farmName,
    required String email,
    required String phone,
    required String preferredLanguage,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'farmName': farmName,
          'email': email,
          'phone': phone,
          'preferredLanguage': preferredLanguage,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'token': data['token'],
          'user': UserModel.fromJson(data['user']),
          'message': data['message'] ?? 'Signup successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Login - Authenticate existing user
  /// POST /api/auth/login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': data['token'],
          'user': UserModel.fromJson(data['user']),
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Get User Profile
  /// GET /api/user/profile
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': UserModel.fromJson(data['user']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// Update User Profile
  /// PUT /api/user/profile
  static Future<Map<String, dynamic>> updateUserProfile({
    required String token,
    required String fullName,
    required String farmName,
    required String phone,
    required String preferredLanguage,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'fullName': fullName,
          'farmName': farmName,
          'phone': phone,
          'preferredLanguage': preferredLanguage,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': UserModel.fromJson(data['user']),
          'message': data['message'] ?? 'Profile updated successfully',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
