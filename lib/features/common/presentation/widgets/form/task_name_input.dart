import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskNameInput extends StatelessWidget {
  const TaskNameInput({
    super.key,
    required this.controller,
    this.maxLength,
    required this.label,
    required this.hint,
    this.fillColor,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final int? maxLength;
  final String label;
  final String hint;
  final Color? fillColor;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    // 定義最大長度，方便維護
    int inputMaxLength = maxLength ?? 20;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AppTextField(
          controller: controller,
          autofocus: autofocus,
          labelText: label, // 或 field_name
          hintText: hint,
          fillColor: fillColor,
          maxLength: inputMaxLength,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
          ],
          suffixText: "${value.text.length}/$inputMaxLength",
          validator: (val) => (val == null || val.trim().isEmpty)
              ? t.error.message.empty(key: label)
              : null,
          focusNode: focusNode,
        );
      },
    );
  }
}
