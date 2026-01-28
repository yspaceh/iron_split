import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskNameInput extends StatelessWidget {
  const TaskNameInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // [修正] 使用 ValueListenableBuilder 監聽文字變化
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextFormField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
          ],
          decoration: InputDecoration(
            hintText: t.S16_TaskCreate_Edit.field_name_hint,
            counterText: "",
            // 這裡現在會隨著 value (輸入內容) 即時更新了
            suffixText: "${value.text.length}/20",
            suffixStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
          ),
          validator: (val) => (val == null || val.trim().isEmpty)
              ? t.S16_TaskCreate_Edit.error_name_empty
              : null,
        );
      },
    );
  }
}
