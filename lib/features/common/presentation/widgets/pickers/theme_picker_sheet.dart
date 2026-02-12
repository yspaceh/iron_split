// lib/features/common/presentation/widgets/pickers/language_picker_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/theme_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';
// 引入 AppLocale

class ThemePickerSheet {
  static void show({
    required BuildContext context,
    required ThemeMode initialTheme, // [修改] 型別改為 AppLocale
    required Function(ThemeMode selected) onSelected, // [修改] 回傳 AppLocale
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int selectedIndex = ThemeConstants.allThemes.indexOf(initialTheme);
    if (selectedIndex == -1) selectedIndex = 0;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(ThemeConstants.allThemes[selectedIndex]);
      },
      child: CupertinoPicker(
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
        children: ThemeConstants.allThemes.map((locale) {
          return Center(
            child: Text(
              ThemeConstants.getLabel(context, locale),
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
