import 'package:flutter/material.dart';

class CommonPickerField extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String value;
  final IconData icon;
  final bool isError;
  const CommonPickerField({
    super.key,
    required this.onTap,
    required this.label,
    required this.value,
    required this.icon,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(icon, color: isError ? colorScheme.error : null), // Icon 變色
          // 邊框變色邏輯
          enabledBorder: isError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error),
                )
              : OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: isError
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.error, width: 2),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: isError ? colorScheme.error : null // 文字變色
                        ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
