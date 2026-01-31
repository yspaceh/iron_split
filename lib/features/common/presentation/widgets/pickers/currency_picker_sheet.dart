import 'package:flutter/cupertino.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';

class CurrencyPickerSheet {
  /// 彈出統一的幣別選擇器
  static void show({
    required BuildContext context,
    required String initialCode,
    required Function(CurrencyConstants selected) onSelected,
  }) {
    // 1. 取得初始索引
    int selectedIndex =
        kSupportedCurrencies.indexWhere((e) => e.code == initialCode);
    if (selectedIndex == -1) selectedIndex = 0;

    // 2. 呼叫共用的 WheelPicker
    // 注意：這裡不加 await，因為 showCommonWheelPicker 回傳 void
    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        // 當使用者在彈窗點擊「確定」時，才執行回調
        onSelected(kSupportedCurrencies[selectedIndex]);
      },
      child: CupertinoPicker(
        itemExtent: 40,
        // 設定初始選中項
        scrollController:
            FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: (index) {
          selectedIndex = index; // 更新暫存索引
        },
        children: kSupportedCurrencies.map((e) {
          return Center(
            child: Text(
              "${e.code} (${e.symbol}) - ${e.getLocalizedName(context)}",
              style: const TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
