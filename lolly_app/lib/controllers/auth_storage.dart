import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _emailKey = 'email';
  static const _passwordKey = 'password';
  static const _rememberKey = 'remember_me';

  // Ghi nhớ thông tin đăng nhập
  static Future<void> saveCredentials(String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberKey, rememberMe);
    if (rememberMe) {
      await prefs.setString(_emailKey, email);
      await _storage.write(key: _passwordKey, value: password);
    } else {
      await prefs.remove(_emailKey);
      await _storage.delete(key: _passwordKey);
    }
  }

  // Lấy thông tin
  static Future<Map<String, String>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_rememberKey) ?? false;
    if (!rememberMe) return {};

    final email = prefs.getString(_emailKey) ?? '';
    final password = await _storage.read(key: _passwordKey) ?? '';
    return {
      'email': email,
      'password': password,
    };
  }
}
