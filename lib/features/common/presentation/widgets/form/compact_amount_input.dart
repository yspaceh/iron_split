import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/constants/currency_constants.dart';

/// 緊湊型金額輸入框 (模仿 AppTextField 風格，但適合列表使用)
class CompactAmountInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final CurrencyConstants currencyConstants;
  final Color? fillColor;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  const CompactAmountInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.fillColor,
    required this.currencyConstants,
    this.autovalidateMode,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final borderRadius = BorderRadius.circular(12); // 稍微小一點的圓角

    // 1. 正常狀態：透明邊框 (保留 1px 避免跳動)
    final normalBorderStyle = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: fillColor ?? colorScheme.surface,
        width: 1.0,
      ),
    );

    // 2. 錯誤狀態：紅色全框 (因為沒有 labelText，所以不會有缺口！)
    final errorBorderStyle = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.0,
      ),
    );

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
          decimal: currencyConstants.decimalDigits > 0),
      inputFormatters: [
        currencyConstants.decimalDigits > 0
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      style: textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.5,
      ),
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          fontSize: 14,
        ),
        isDense: true, // 關鍵：緊湊模式
        filled: true,
        fillColor: fillColor ?? colorScheme.surface,
        prefixText: '${currencyConstants.symbol} ',
        prefixStyle: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        // 邊框設定
        border: normalBorderStyle,
        enabledBorder: normalBorderStyle,
        focusedBorder: normalBorderStyle,

        // 錯誤時顯示完整的紅框
        errorBorder: errorBorderStyle,
        focusedErrorBorder: errorBorderStyle,
      ),
    );
  }
}
