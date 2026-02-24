import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemoInput extends StatelessWidget {
  const TaskMemoInput({
    super.key,
    required this.memoController,
    this.fillColor,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(20.0),
  });
  final TextEditingController memoController;
  final Color? fillColor;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;

  @override
  Widget build(BuildContext context) {
    // 直接替換為 AppTextField
    return AppTextField(
      controller: memoController,
      scrollPadding: scrollPadding,
      fillColor: fillColor,
      labelText: t.common.label.memo, // 標題
      hintText: t.S15_Record_Edit.hint.memo, // 增加一點提示 (Optional)
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      focusNode: focusNode,
    );
  }
}
