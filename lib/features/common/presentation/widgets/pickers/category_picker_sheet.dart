import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart';

class CategoryPickerSheet {
  /// 顯示類別選擇器
  static void show({
    required BuildContext context,
    required String initialCategoryId,
    required Function(CategoryConstant selected) onSelected,
  }) {
    final t = Translations.of(context);
    // 取得當前主題顏色，用於強制指定文字顏色
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final int initialIndex = kAppCategories
        .indexWhere((c) => c.id == initialCategoryId)
        .clamp(0, kAppCategories.length - 1);

    int tempIndex = initialIndex;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(kAppCategories[tempIndex]);
      },
      child: CupertinoPicker(
        // [參數調整] 加上放大效果，讓選中的項目更突出 (模擬原生)
        magnification: 1.22,
        useMagnifier: true,
        itemExtent: 40, // 稍微縮小行高，配合放大效果會更緊湊好看，或維持 40
        scrollController:
            FixedExtentScrollController(initialItem: initialIndex),
        onSelectedItemChanged: (index) => tempIndex = index,
        // [風格修正]
        // 1. 移除 selectionOverlay (設為 null)，這樣就不會有灰色的底塊，
        //    或是維持您喜歡的「淺灰圓角塊」(如下保留代碼)。
        //    原生 DatePicker 其實是有兩條淡淡的線，若您喜歡之前的圓角塊可以保留。
        //    這裡我們保留圓角塊，但把文字加深。
        selectionOverlay: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        children: kAppCategories.map((c) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // [修正] Icon 顏色強制深黑
              Icon(c.icon, size: 20, color: colorScheme.onSurface),
              const SizedBox(width: 8),
              // [修正] 文字顏色強制深黑，大小 21
              Text(
                c.getName(t),
                style: TextStyle(
                  color: colorScheme.onSurface, // 解決太淺的問題
                  fontSize: 18, // 夠大才清晰
                  fontWeight: FontWeight.w500, // 原生通常是 Regular
                  fontFamily: '.SF Pro Display', // iOS 預設字體 (Optional)
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
