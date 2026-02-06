import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';

class CurrencyPickerSheet {
  /// 彈出統一的幣別選擇器
  static void show({
    required BuildContext context,
    required String initialCode,
    required Function(CurrencyConstants selected) onSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int selectedIndex =
        kSupportedCurrencies.indexWhere((e) => e.code == initialCode);
    if (selectedIndex == -1) selectedIndex = 0;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        onSelected(kSupportedCurrencies[selectedIndex]);
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
        children: kSupportedCurrencies.map((e) {
          return Center(
            child: Text(
              "${e.code} ${e.symbol} - ${e.getLocalizedName(context)}",
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
