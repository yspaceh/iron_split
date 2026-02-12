// lib/core/viewmodels/theme_vm.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const String _key = 'theme_mode';

  // 預設跟隨系統
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeViewModel() {
    _loadFromPrefs();
  }

  // S70 頁面會呼叫這個方法
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners(); // 這會通知 main.dart 重畫

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.toString());
    } catch (e) {
      debugPrint("Save theme error: $e");
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedString = prefs.getString(_key);

    if (savedString != null) {
      if (savedString == ThemeMode.light.toString()) {
        _themeMode = ThemeMode.light;
      } else if (savedString == ThemeMode.dark.toString()) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    }
  }
}
