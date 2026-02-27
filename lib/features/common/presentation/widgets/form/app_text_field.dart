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
  final TextCapitalization textCapitalization;

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
    this.textCapitalization = TextCapitalization.none,
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
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final labelStyle =
        AppLayout.inputLableStyle(colorScheme, textTheme, enabled);
    final textColor = AppLayout.inputTextColor(colorScheme, enabled);
    final contentStyle = AppLayout.inputContentStyle(
      textTheme,
      textColor,
      finalLineHeight,
    );
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
    final normalBorderStyle =
        AppLayout.inputNormalBorderStyle(fillColor, colorScheme);
    final errorBorderStyle = AppLayout.inputErrorBorderStyle(colorScheme);

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
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          textAlignVertical: TextAlignVertical.bottom,
          style: contentStyle,
          decoration: InputDecoration(
            labelText: null,
            contentPadding: AppLayout.inputContentPadding(
                contentTopPadding, contentBottomPadding),
            hintText: hintText,
            hintStyle: AppLayout.inputHintStyle(colorScheme),
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
            border: normalBorderStyle,
            disabledBorder: normalBorderStyle,
            enabledBorder: normalBorderStyle,
            focusedBorder: normalBorderStyle,
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
