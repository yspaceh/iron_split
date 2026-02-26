import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
  final bool enabled;

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
    this.scrollPadding = const EdgeInsets.all(AppLayout.spaceXL),
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final scale = displayState.scale;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    final labelStyle = textTheme.labelMedium?.copyWith(
          color: enabled
              ? colorScheme.onSurfaceVariant
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ) ??
        const TextStyle(fontSize: 10);
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
        return Icon(prefixIcon,
            color: colorScheme.onSurfaceVariant, size: iconSize);
      }
      return null;
    }

    // 使用 Stack 來手動佈局 Label，達成「在 Container 內」且「不切斷邊框」的效果
    return Stack(
      children: [
        // Layer 1: 輸入框本體
        TextFormField(
          enabled: enabled,
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
          style: contentStyle,
          decoration: InputDecoration(
            labelText: null,
            contentPadding: EdgeInsets.only(
                left: AppLayout.spaceL,
                right: AppLayout.spaceL,
                top: contentTopPadding,
                bottom: contentBottomPadding),

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
            prefixStyle: contentStyle,

            filled: true,
            fillColor: fillColor != null
                ? (enabled ? fillColor : fillColor!.withValues(alpha: 0.3))
                : (enabled
                    ? colorScheme.surface
                    : colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3)),
            errorMaxLines: 3,

            // 邊框設定
            border: normalBorderStyle,
            disabledBorder: normalBorderStyle,
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
            top: labelTopPos, // 距離頂部
            left: (prefixIcon != null || leading != null)
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
    );
  }
}
