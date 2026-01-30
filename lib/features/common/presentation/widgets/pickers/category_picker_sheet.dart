import 'package:flutter/cupertino.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart';

class CategoryPickerSheet {
  /// 顯示類別選擇器
  static void show({
    required BuildContext context,
    required String initialCategoryId,
    required Function(CategoryConstant selected) onSelected,
  }) {
    // 1. 取得翻譯實體
    final t = Translations.of(context);

    // 2. 計算初始索引
    final int initialIndex = kAppCategories
        .indexWhere((c) => c.id == initialCategoryId)
        .clamp(0, kAppCategories.length - 1);

    int tempIndex = initialIndex;

    // 3. 呼叫共用滾輪元件
    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        // 確認時回傳當前選中的類別
        onSelected(kAppCategories[tempIndex]);
      },
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        onSelectedItemChanged: (index) => tempIndex = index,
        children: kAppCategories.map((c) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(c.icon, size: 20),
              const SizedBox(width: 8),
              // 直接使用 CategoryConstant 裡的 getName 方法取得翻譯名稱
              Text(c.getName(t)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
