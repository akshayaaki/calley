import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';

class LocalStorage {
  static const String _keyUser = 'calley_user_session';
  static const String _keyLanguage = 'calley_selected_language';
  static const String _keyActiveListId = 'calley_active_list_id';
  static const String _keySeenGettingStarted = 'calley_seen_getting_started';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.remove(_keyActiveListId);
  }

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, languageCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLanguage);
  }

  static Future<void> saveActiveListId(String listId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyActiveListId, listId);
  }

  static Future<String?> getActiveListId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyActiveListId);
  }

  static Future<void> setSeenGettingStarted(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySeenGettingStarted, seen);
  }

  static Future<bool> hasSeenGettingStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySeenGettingStarted) ?? false;
  }
}

