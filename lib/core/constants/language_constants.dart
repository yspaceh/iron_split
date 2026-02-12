import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart'; // 必須引入 slang 生成的檔案

class LanguageConstants {
  // 定義預設語系
  static const AppLocale defaultLocale = AppLocale.enUs; // 或 AppLocale.enUs

  // 定義清單 (直接使用 Enum)
  static const List<AppLocale> allLanguages = [
    AppLocale.zhTw,
    AppLocale.enUs,
    AppLocale.jaJp, // 假設 slang 生成的是 ja
  ];

  // Helper: 取得顯示名稱
  static String getLabel(BuildContext context, AppLocale locale) {
    final t = Translations.of(context);
    switch (locale) {
      case AppLocale.zhTw:
        return t.common.language.zh_TW; // 確保 strings.g.dart 裡有對應翻譯
      case AppLocale.enUs:
        return t.common.language.en_US;
      case AppLocale.jaJp:
        return t.common.language.jp_JP;
    }
  }
}
