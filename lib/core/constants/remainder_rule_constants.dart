// lib/features/task/data/constants/remainder_rule_constants.dart

import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class RemainderRuleConstants {
  // 定義 Key (避免打錯字)
  static const String random = 'random';
  static const String order = 'order';
  static const String member = 'member';

  static const String defaultRule = 'random';

  // 定義清單 (給 UI 選單用)
  static const List<String> allRules = [
    random,
    order,
    member,
  ];

  // Helper: 取得顯示名稱 (集中管理翻譯邏輯)
  static String getLabel(BuildContext context, String rule) {
    final t = Translations.of(context);
    switch (rule) {
      case random:
        return t.common.remainder_rule.rule_random;
      case order:
        return t.common.remainder_rule.rule_order;
      case member:
        return t.common.remainder_rule.rule_member;
      default:
        return rule;
    }
  }
}
