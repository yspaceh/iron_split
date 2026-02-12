// lib/core/viewmodels/locale_vm.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iron_split/gen/strings.g.dart'; // 記得 import slang 生成的檔案

class LocaleViewModel extends ChangeNotifier {
  static const String _key = 'app_locale';

  // 預設語言 (通常 slang 會自動抓系統，這裡我們先設為當前 slang 的狀態)
  AppLocale _currentLocale = LocaleSettings.currentLocale;

  AppLocale get currentLocale => _currentLocale;

  LocaleViewModel() {
    _init();
  }

  // 初始化：從手機讀取上次的設定
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_key);

    if (savedCode != null) {
      // 嘗試將字串轉回 AppLocale enum
      // slang 提供了方便的 helper: AppLocaleUtils.parse
      final locale = AppLocaleUtils.parse(savedCode);

      if (locale != _currentLocale) {
        _currentLocale = locale;
        LocaleSettings.setLocale(locale); // 告訴 slang 切換語言
        notifyListeners(); // 通知 main.dart
      }
    } else {
      // useDeviceLocale() 會自動偵測手機語言 (日文)，並回傳正確的 locale
      final deviceLocale = await LocaleSettings.useDeviceLocale();

      if (_currentLocale != deviceLocale) {
        _currentLocale = deviceLocale; // 更新變數 (變成 ja)
        notifyListeners(); // 通知 main.dart 更新畫面
      }
    }
  }

  // S70 會呼叫這個方法
  Future<void> updateLanguage(AppLocale newLocale) async {
    if (_currentLocale == newLocale) return;

    _currentLocale = newLocale;
    LocaleSettings.setLocale(newLocale); // 1. 設定 slang
    notifyListeners(); // 2. 更新 UI

    // 3. 存檔
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, newLocale.languageCode);
      // 註：如果是 zh-Hant 這種複雜的，建議存 newLocale.languageTag
    } catch (e) {
      debugPrint("Save locale error: $e");
    }
  }
}
