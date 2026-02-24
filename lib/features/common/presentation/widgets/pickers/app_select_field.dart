import 'package:flutter/material.dart';

class AppSelectField extends StatelessWidget {
  final String text;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final String? errorText;
  final Color? fillColor;
  final Widget? trailing;
  final AutovalidateMode? autovalidateMode;

  const AppSelectField({
    super.key,
    required this.text,
    required this.onTap,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.errorText,
    this.fillColor,
    this.trailing,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isEmpty = text.isEmpty;

    final borderRadius = BorderRadius.circular(16);

    // 1. 正常狀態：透明邊框
    final normalBorderStyle = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
    );

    // 2. 錯誤狀態：紅色邊框
    final errorBorderStyle = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.0,
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: true,
            child: TextFormField(
              key: ValueKey(text),
              initialValue: isEmpty ? null : text,
              readOnly: true,
              autovalidateMode: autovalidateMode,
              textAlignVertical: TextAlignVertical.bottom,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              decoration: InputDecoration(
                labelText: null, // 禁用內建 Label

                contentPadding: const EdgeInsets.only(
                    left: 16, right: 16, top: 28, bottom: 12),

                hintText: isEmpty ? hintText : null,
                hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontSize: 14),

                filled: true,
                fillColor: fillColor ?? colorScheme.surface,

                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon,
                        color: colorScheme.onSurfaceVariant, size: 20)
                    : null,

                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trailing != null) ...[
                      trailing!,
                      const SizedBox(width: 8),
                    ],
                    Icon(
                      Icons.expand_more_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 48,
                  minWidth: 48,
                ),

                border: normalBorderStyle,
                enabledBorder: normalBorderStyle,
                focusedBorder: normalBorderStyle,

                // 錯誤狀態
                errorBorder: errorBorderStyle,
                focusedErrorBorder: errorBorderStyle,

                errorText: errorText,
              ),
            ),
          ),

          // 手動繪製 Label (固定在左上)
          if (labelText != null)
            Positioned(
              top: 12,
              left: (prefixIcon != null) ? 48 : 20,
              child: Text(
                labelText!,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
