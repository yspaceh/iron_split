import 'package:flutter/material.dart';

class AppSelectField extends StatelessWidget {
  final String text; // 目前選中的內容
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final VoidCallback onTap; // 點擊觸發 BottomSheet
  final String? errorText; // 外部傳入的錯誤訊息 (如果有)

  const AppSelectField({
    super.key,
    required this.text,
    required this.onTap,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isEmpty = text.isEmpty;

    // 同步使用 UnderlineInputBorder
    final borderStyle = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: IgnorePointer(
        ignoring: true, // 讓 InkWell 處理點擊
        child: TextFormField(
          key: ValueKey(text), // 強制刷新
          initialValue: isEmpty ? null : text,
          readOnly: true,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          decoration: InputDecoration(
            // 標題設定
            labelText: labelText,
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,

            hintText: isEmpty ? hintText : null,
            hintStyle: TextStyle(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                fontSize: 14),

            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            filled: true,
            fillColor: colorScheme.surface, // 白色背景

            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    color: colorScheme.onSurfaceVariant, size: 20)
                : null,

            suffixIcon: Icon(
              Icons.expand_more_rounded,
              color: colorScheme.onSurfaceVariant,
            ),

            border: borderStyle,
            enabledBorder: borderStyle,
            focusedBorder: borderStyle,
            errorBorder: borderStyle,
            errorText: errorText,
          ),
        ),
      ),
    );
  }
}
