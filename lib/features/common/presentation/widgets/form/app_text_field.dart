import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              labelText!,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500, // 輸入的字稍微粗一點點，更有質感
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: colorScheme.outline),

            // [風格核心]：淡灰填充
            filled: true,
            fillColor: colorScheme.surfaceContainerLow, // 或 Colors.grey[100]

            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

            // [Icon 降噪]：統一使用灰色
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    color: colorScheme.onSurfaceVariant, size: 20)
                : null,
            suffixIcon: suffixIcon,

            // [邊框邏輯]：平時無框，圓角 12~16
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none, // 預設無邊框
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            // 聚焦時，給一點點顏色提示 (Optional)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.5),
                  width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
