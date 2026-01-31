// lib/features/task/data/constants/remainder_rule_constants.dart

import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class SplitMethodConstants {
  // 定義 Key (避免打錯字)
  static const String even = 'even';
  static const String exact = 'exact';
  static const String percent = 'percent';

  static const String defaultMethod = 'even';

  // 定義清單 (給 UI 選單用)
  static const List<String> allRules = [
    even,
    exact,
    percent,
  ];

  // Helper: 取得顯示名稱 (集中管理翻譯邏輯)
  static String getLabel(BuildContext context, String method) {
    final t = Translations.of(context);
    switch (method) {
      case even:
        return t.B03_SplitMethod_Edit.method_even;
      case exact:
        return t.B03_SplitMethod_Edit.method_exact;
      case percent:
        return t.B03_SplitMethod_Edit.method_percent;
      default:
        return method;
    }
  }
}
