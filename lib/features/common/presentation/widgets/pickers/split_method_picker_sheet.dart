import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';

class SplitMethodPickerSheet {
  static void show({
    required BuildContext context,
    required String initialMethod,
    required Function(String selected) onSelected,
  }) {
    // 取得當前主題顏色，用於強制指定文字顏色
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int selectedIndex =
        SplitMethodConstant.allRules.indexWhere((e) => e == initialMethod);
    if (selectedIndex == -1) selectedIndex = 0;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(SplitMethodConstant.allRules[selectedIndex]);
      },
      child: CupertinoPicker(
        // [參數調整] 增加原生感
        magnification: 1.22,
        useMagnifier: true,
        itemExtent: 40,
        scrollController:
            FixedExtentScrollController(initialItem: selectedIndex),
        onSelectedItemChanged: (index) {
          selectedIndex = index;
        },
        selectionOverlay: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        children: SplitMethodConstant.allRules.map((e) {
          return Center(
            child: Text(
              SplitMethodConstant.getLabel(context, e),
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: '.SF Pro Display',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
