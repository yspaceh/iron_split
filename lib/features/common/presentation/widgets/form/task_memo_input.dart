import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemoInput extends StatelessWidget {
  const TaskMemoInput({
    super.key,
    required this.memoController,
    this.fillColor,
  });
  final TextEditingController memoController;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    // 直接替換為 AppTextField
    return AppTextField(
      controller: memoController,
      fillColor: fillColor,
      labelText: t.S15_Record_Edit.label.memo, // 標題
      hintText: t.S15_Record_Edit.hint.memo, // 增加一點提示 (Optional)

      // 多行設定
      keyboardType: TextInputType.multiline,
      maxLines: 3, // 稍微高一點，讓備註欄位看起來不一樣

      // AppTextField 內部已經設定好 "淡灰底 + 圓角 16"
    );
  }
}
