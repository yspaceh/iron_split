// lib/features/common/presentation/widgets/pickers/language_picker_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/language_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart'; // 引入 AppLocale

class LanguagePickerSheet {
  static void show({
    required BuildContext context,
    required AppLocale initialLanguage, // [修改] 型別改為 AppLocale
    required Function(AppLocale selected) onSelected, // [修改] 回傳 AppLocale
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int selectedIndex = LanguageConstants.allLanguages.indexOf(initialLanguage);
    if (selectedIndex == -1) selectedIndex = 0;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(LanguageConstants.allLanguages[selectedIndex]);
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
        children: LanguageConstants.allLanguages.map((locale) {
          return Center(
            child: Text(
              LanguageConstants.getLabel(context, locale),
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
