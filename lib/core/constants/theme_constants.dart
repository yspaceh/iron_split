import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class ThemeConstants {
  // 定義預設語系
  static const ThemeMode defaultTheme = ThemeMode.system;

  // 定義清單 (直接使用 Enum)
  static const List<ThemeMode> allThemes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  // Helper: 取得顯示名稱
  static String getLabel(BuildContext context, ThemeMode locale) {
    final t = Translations.of(context);
    switch (locale) {
      case ThemeMode.system:
        return t.common.theme.system; // 確保 strings.g.dart 裡有對應翻譯
      case ThemeMode.light:
        return t.common.theme.light;
      case ThemeMode.dark:
        return t.common.theme.dark;
    }
  }
}
