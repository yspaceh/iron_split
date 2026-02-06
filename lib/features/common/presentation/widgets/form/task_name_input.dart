import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskNameInput extends StatelessWidget {
  const TaskNameInput({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    // 定義最大長度，方便維護
    const int maxLength = 20;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AppTextField(
          controller: controller,
          autofocus: true,

          // 標題設定 (符合新風格)
          labelText: t.S16_TaskCreate_Edit.label.name, // 或 field_name
          hintText: t.S16_TaskCreate_Edit.placeholder.name,

          // 限制設定
          maxLength: maxLength,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
          ],

          // [關鍵] 動態傳入計數文字
          suffixText: "${value.text.length}/$maxLength",

          // 驗證邏輯
          validator: (val) => (val == null || val.trim().isEmpty)
              ? t.error.message.empty(key: t.S16_TaskCreate_Edit.label.name)
              : null,
        );
      },
    );
  }
}
