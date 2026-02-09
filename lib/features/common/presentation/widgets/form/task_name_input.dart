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
  });

  final TextEditingController controller;
  final int? maxLength;
  final String label;
  final String hint;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    // 定義最大長度，方便維護
    int inputMaxLength = maxLength ?? 20;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AppTextField(
          controller: controller,
          autofocus: true,
          labelText: label, // 或 field_name
          hintText: hint,
          fillColor: fillColor,
          maxLength: inputMaxLength,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
          ],

          // [關鍵] 動態傳入計數文字
          suffixText: "${value.text.length}/$inputMaxLength",

          // 驗證邏輯
          validator: (val) => (val == null || val.trim().isEmpty)
              ? t.error.message.empty(key: label)
              : null,
        );
      },
    );
  }
}
