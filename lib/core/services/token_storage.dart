/// File: lib/core/services/token_storage.dart
/// Penyimpanan Sesi & Token Menggunakan SharedPreferences

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class TokenStorage {
  static const String _keyToken = 'netlayan_token';
  static const String _keyUser = 'netlayan_user';
  static const String _keyRole = 'netlayan_role';

  /// Simpan Token & Session User
  static Future<void> saveSession({
    required String token,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyRole, user.role);
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  /// Ambil User Ter-login
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    if (userString == null) return null;
    try {
      final Map<String, dynamic> json = jsonDecode(userString);
      return UserModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Ambil Role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  /// Ambil Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  /// Hapus Session / Logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyRole);
  }
}
