import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/gen/strings.g.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? leading;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final EdgeInsets scrollPadding;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final String? suffixText;
  final String? prefixText;

  final bool isRequired;
  final Color? fillColor;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.leading,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofocus = false,
    this.suffixText,
    this.isRequired = false,
    this.fillColor,
    this.focusNode,
    this.prefixText,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.scrollPadding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final borderRadius = BorderRadius.circular(16);

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

    final effectiveValidator = validator ??
        (isRequired
            ? (String? val) {
                if (val == null || val.trim().isEmpty) {
                  return t.error.message.required;
                }
                return null;
              }
            : null);

    Widget? buildPrefix() {
      if (leading != null) return leading;
      if (prefixIcon != null) {
        return Icon(prefixIcon, color: colorScheme.onSurfaceVariant, size: 20);
      }
      return null;
    }

    // 使用 Stack 來手動佈局 Label，達成「在 Container 內」且「不切斷邊框」的效果
    return Stack(
      children: [
        // Layer 1: 輸入框本體
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          scrollPadding: scrollPadding,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: effectiveValidator,
          autovalidateMode: autovalidateMode,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          textAlignVertical: TextAlignVertical.bottom,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          decoration: InputDecoration(
            // [關鍵] 不使用內建 labelText，避免 OutlineBorder 切出缺口
            labelText: null,
            // [關鍵] 使用 contentPadding 把輸入文字往下推
            // Top: 26 (留位置給上面的 Label)
            // Bottom: 10 (下方留白)
            // 這樣整體高度大約會是 64px 左右
            contentPadding:
                const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 12),

            hintText: hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              fontSize: 14,
            ),

            counterText: maxLength != null ? "" : null,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            suffixStyle: textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
            prefixText: prefixText,
            prefixIcon: buildPrefix(),
            prefixStyle: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.5,
            ),

            filled: true,
            fillColor: fillColor ?? colorScheme.surface,

            // 邊框設定
            border: normalBorderStyle,
            enabledBorder: normalBorderStyle,
            focusedBorder: normalBorderStyle,

            // 錯誤時顯示完整的紅框
            errorBorder: errorBorderStyle,
            focusedErrorBorder: errorBorderStyle,
          ),
        ),

        // Layer 2: 手動繪製 Label (固定在左上角)
        if (labelText != null)
          Positioned(
            top: 12, // 距離頂部
            left: (prefixIcon != null || leading != null)
                ? 48
                : 20, // 如果有 icon 要避開
            child: IgnorePointer(
              // 讓點擊穿透 Label，直接點到輸入框
              child: Text(
                labelText!,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 10, // 小字體
                ),
              ),
            ),
          ),
      ],
    );
  }
}
