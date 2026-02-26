import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

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
  final bool enabled;

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
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isEmpty = text.isEmpty;
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final scale = displayState.scale;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final Color textColor = enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final contentStyle = textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w500,
      color: textColor,
      height: finalLineHeight,
    );

    final Color iconColor = enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.38);

    final labelStyle = textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ) ??
        const TextStyle(fontSize: 10);
    final double labelTopPos = isEnlarged ? AppLayout.spaceS : AppLayout.spaceM;

    final double labelRenderedHeight = AppLayout.renderedHeight(
      10.0,
      labelStyle.height,
      scale,
    );
    final double contentTopPadding =
        labelTopPos + labelRenderedHeight + AppLayout.spaceXS;

    final double contentBottomPadding =
        isEnlarged ? AppLayout.spaceL : AppLayout.spaceM;

    final borderRadius = BorderRadius.circular(AppLayout.radiusL);

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
      onTap: enabled ? onTap : null,
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
              style: contentStyle,
              decoration: InputDecoration(
                labelText: null, // 禁用內建 Label
                contentPadding: EdgeInsets.only(
                    left: AppLayout.spaceL,
                    right: AppLayout.spaceL,
                    top: contentTopPadding,
                    bottom: contentBottomPadding),

                hintText: isEmpty ? hintText : null,
                hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    fontSize: 14),

                filled: true,
                fillColor: fillColor != null
                    ? (enabled ? fillColor : fillColor!.withValues(alpha: 0.3))
                    : (enabled
                        ? colorScheme.surface
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3)),

                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: iconColor, size: iconSize)
                    : null,

                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (trailing != null) ...[
                      trailing!,
                      const SizedBox(width: AppLayout.spaceS),
                    ],
                    Icon(
                      Icons.expand_more_rounded,
                      size: iconSize,
                      color: iconColor,
                    ),
                    const SizedBox(width: AppLayout.spaceM),
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
              left: (prefixIcon != null)
                  ? AppLayout.gridUnit * 6
                  : AppLayout.spaceXL,
              child: Text(
                labelText!,
                style: labelStyle,
              ),
            ),
        ],
      ),
    );
  }
}
