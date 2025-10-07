import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _nameKey = 'user_name';
  static const _imageKey = 'user_image';
  static const _bioKey = 'biometric_enabled';

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_nameKey, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<void> saveUserImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_imageKey, path);
  }

  static Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imageKey);
  }

  static Future<void> saveBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_bioKey, enabled);
  }

  static Future<bool?> getBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bioKey);
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
