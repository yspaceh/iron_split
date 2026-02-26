import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

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
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    // M3 標準高度: 40
    // Flutter 的 FilledButton 預設就是 40，但我們明確指定以防萬一
    final double minHeight =
        isEnlarged ? AppLayout.gridUnit * 7 : AppLayout.gridUnit * 5;
    final Size minimumSize = Size.fromHeight(minHeight);

    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    // 通用樣式設定
    final ButtonStyle baseStyle;

    if (type == AppButtonType.primary) {
      // [Primary] -> FilledButton
      baseStyle = FilledButton.styleFrom(
        minimumSize: minimumSize, // 高度 40
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const StadiumBorder(),
        elevation: 0, // M3 FilledButton 預設無陰影
      );
    } else {
      // [Secondary] -> OutlinedButton
      baseStyle = OutlinedButton.styleFrom(
        minimumSize: minimumSize, // 高度 40
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
    Widget buttonContent = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: isLoading ? 0.0 : 1.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // 保持緊湊以確保 Stack 完美置中
            children: [
              if (icon != null) ...[
                Icon(icon, size: iconSize),
                const SizedBox(width: AppLayout.spaceS),
              ],
              if (text != null) ...[
                Text(
                  text!,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: type == AppButtonType.primary
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                  ),
                ),
              ]
            ],
          ),
        ),
        if (isLoading)
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: type == AppButtonType.primary
                  ? colorScheme.onPrimary
                  : colorScheme.primary,
            ),
          ),
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
