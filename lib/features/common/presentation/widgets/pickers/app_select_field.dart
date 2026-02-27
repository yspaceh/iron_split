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
    final textColor = AppLayout.inputTextColor(colorScheme, enabled);
    final contentStyle = AppLayout.inputContentStyle(
      textTheme,
      textColor,
      finalLineHeight,
    );

    final iconColor = AppLayout.inputIconColor(colorScheme, enabled);
    final labelStyle =
        AppLayout.inputLableStyle(colorScheme, textTheme, enabled);
    final labelTopPos = AppLayout.inputLabelTopPos(isEnlarged);

    final labelRenderedHeight = AppLayout.renderedHeight(
      10.0,
      labelStyle.height,
      scale,
    );
    final contentTopPadding =
        AppLayout.inputContentTopPadding(labelTopPos, labelRenderedHeight);

    final contentBottomPadding =
        AppLayout.inputContentBottomPadding(isEnlarged);

    final borderRadius = AppLayout.inputBorderRadius;

    final normalBorderStyle =
        AppLayout.inputNormalBorderStyle(fillColor, colorScheme);
    final errorBorderStyle = AppLayout.inputErrorBorderStyle(colorScheme);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: borderRadius,
      child: Stack(
        children: [
          IgnorePointer(
            ignoring: true,
            child: TextFormField(
              key: ValueKey(text),
              enabled: enabled,
              initialValue: isEmpty ? null : text,
              readOnly: true,
              autovalidateMode: autovalidateMode,
              textAlignVertical: TextAlignVertical.bottom,
              style: contentStyle,
              decoration: InputDecoration(
                labelText: null, // 禁用內建 Label
                contentPadding: AppLayout.inputContentPadding(
                    contentTopPadding, contentBottomPadding),
                hintText: isEmpty ? hintText : null,
                hintStyle: AppLayout.inputHintStyle(colorScheme),
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
                suffixIconConstraints: BoxConstraints(
                  minHeight: isEnlarged ? 48 : 36,
                  minWidth: isEnlarged ? 48 : 36,
                ),

                border: normalBorderStyle,
                disabledBorder: normalBorderStyle,
                enabledBorder: normalBorderStyle,
                focusedBorder: normalBorderStyle,
                errorBorder: errorBorderStyle,
                focusedErrorBorder: errorBorderStyle,
                errorText: errorText,
              ),
            ),
          ),

          // 手動繪製 Label (固定在左上)
          if (labelText != null)
            Positioned(
              top: labelTopPos, // 距離頂部
              left: (prefixIcon != null)
                  ? AppLayout.gridUnit * 6
                  : AppLayout.spaceXL, // 如果有 icon 要避開
              child: IgnorePointer(
                child: Text(
                  labelText!,
                  style: labelStyle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
