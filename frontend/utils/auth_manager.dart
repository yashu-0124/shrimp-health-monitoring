import 'package:shared_preferences/shared_preferences.dart';

/// Auth Manager
/// Handles JWT token storage and retrieval using SharedPreferences
class AuthManager {
  static const String _tokenKey = 'jwt_token';

  /// Save JWT token to local storage
  static Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      return false;
    }
  }

  /// Get JWT token from local storage
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is logged in (token exists)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear JWT token (logout)
  static Future<bool> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tokenKey);
    } catch (e) {
      return false;
    }
  }
}
