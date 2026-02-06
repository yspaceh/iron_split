import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonType type;
  final bool isLoading;

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.type = AppButtonType.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // M3 標準高度: 40
    // Flutter 的 FilledButton 預設就是 40，但我們明確指定以防萬一
    const height = 40.0;

    // 通用樣式設定
    final ButtonStyle baseStyle;

    if (type == AppButtonType.primary) {
      // [Primary] -> FilledButton
      baseStyle = FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(height), // 高度 40
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const StadiumBorder(),
        elevation: 0, // M3 FilledButton 預設無陰影
      );
    } else {
      // [Secondary] -> OutlinedButton
      baseStyle = OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(height), // 高度 40
        side: BorderSide(color: colorScheme.outline),
        foregroundColor: colorScheme.primary,
        shape: const StadiumBorder(),
      );
    }

    final VoidCallback? handledOnPressed = (onPressed == null || isLoading)
        ? null
        : () {
            HapticFeedback.lightImpact(); // 輕微震動
            onPressed!();
          };

    // 根據類型回傳對應的 Flutter M3 元件
    Widget buttonContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: type == AppButtonType.primary
                      ? colorScheme.onPrimary
                      : colorScheme.primary)),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18), // M3 Icon 建議 18dp
          const SizedBox(width: 8), // M3 間距 8dp
        ],
        Visibility(
          visible: text != null,
          child: Text(
            text ?? '',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500, // M3 Label Large
              // 確保顏色跟隨 Button 樣式
              color: type == AppButtonType.primary
                  ? colorScheme.onPrimary
                  : colorScheme.primary,
            ),
          ),
        )
      ],
    );

    if (type == AppButtonType.primary) {
      return FilledButton(
        onPressed: handledOnPressed,
        style: baseStyle,
        child: buttonContent,
      );
    } else {
      return OutlinedButton(
        onPressed: handledOnPressed,
        style: baseStyle,
        child: buttonContent,
      );
    }
  }
}
