import 'package:flutter/cupertino.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart';

class RemainderRulePickerSheet {
  // 取得顯示名稱的 Helper
  static String getRuleName(BuildContext context, String rule) {
    final t = Translations.of(context);
    switch (rule) {
      case 'random':
        return t.S13_Task_Dashboard.rule_random;
      case 'order':
        return t.S13_Task_Dashboard.rule_order;
      case 'member':
        return t.S13_Task_Dashboard.rule_member;
      default:
        return rule;
    }
  }

  /// 顯示餘額處理規則選擇器
  /// 遵循 CurrencyPickerSheet 的 Static Pattern
  static void show({
    required BuildContext context,
    required String initialRule, // 'random', 'order', 'member'
    required Function(String selectedRule) onSelected,
  }) {
    // 定義規則清單 (Key)
    final List<String> rules = ['random', 'order', 'member'];

    // 計算初始索引
    int selectedIndex = rules.indexOf(initialRule);
    if (selectedIndex == -1) selectedIndex = 0;

    // 暫存索引 (避免滾動時直接觸發更新)
    int tempIndex = selectedIndex;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(rules[tempIndex]);
      },
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: (index) {
          tempIndex = index;
        },
        children: rules.map((rule) {
          return Center(
            child: Text(
              getRuleName(context, rule),
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
