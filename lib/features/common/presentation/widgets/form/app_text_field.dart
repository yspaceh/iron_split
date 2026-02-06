import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/gen/strings.g.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  // 原本的單純圖示資料
  final IconData? prefixIcon;
  // [新增] 支援複雜的前綴組件 (例如 IconButton)
  final Widget? leading;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;

  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final String? suffixText;

  final bool isRequired;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    // [新增]
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
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderStyle = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
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

    // [新增邏輯] 決定前綴顯示什麼
    Widget? buildPrefix() {
      // 1. 如果有傳入複雜組件 (leading)，優先使用
      if (leading != null) {
        return leading;
      }
      // 2. 如果只有傳入圖示資料 (prefixIcon)，則自動包裝成統一樣式的 Icon
      if (prefixIcon != null) {
        return Icon(prefixIcon, color: colorScheme.onSurfaceVariant, size: 20);
      }
      // 3. 都沒有則不顯示
      return null;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: effectiveValidator,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.5,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,

        hintText: hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          fontSize: 14,
        ),

        counterText: maxLength != null ? "" : null,
        suffixText: suffixText,
        suffixStyle: theme.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),

        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        filled: true,
        fillColor: colorScheme.surface,

        // [修改] 使用新的建構邏輯
        prefixIcon: buildPrefix(),

        suffixIcon: suffixIcon,

        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
        errorBorder: borderStyle,
      ),
    );
  }
}
