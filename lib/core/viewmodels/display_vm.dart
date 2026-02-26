// lib/core/viewmodels/display_vm.dart
import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayViewModel extends ChangeNotifier {
  static const String _key = 'display_mode';

  // 預設跟隨系統
  DisplayMode _displayMode = DisplayMode.system;

  DisplayMode get displayMode => _displayMode;

  DisplayViewModel() {
    _loadFromPrefs();
  }

  // S70 頁面會呼叫這個方法
  Future<void> setDisplayMode(DisplayMode mode) async {
    if (_displayMode == mode) return;
    _displayMode = mode;
    notifyListeners(); // 這會通知 main.dart 重畫

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.toString());
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedString = prefs.getString(_key);

    if (savedString != null) {
      if (savedString == DisplayMode.standard.toString()) {
        _displayMode = DisplayMode.standard;
      } else if (savedString == DisplayMode.enlarged.toString()) {
        _displayMode = DisplayMode.enlarged;
      } else {
        _displayMode = DisplayMode.system;
      }
      notifyListeners();
    }
  }
}
