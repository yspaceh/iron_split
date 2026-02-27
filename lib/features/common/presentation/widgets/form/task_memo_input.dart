import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemoInput extends StatelessWidget {
  const TaskMemoInput({
    super.key,
    required this.memoController,
    this.fillColor,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(AppLayout.spaceXL),
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
      hintText: t.s15_record_edit.hint.memo, // 增加一點提示 (Optional)
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      focusNode: focusNode,
    );
  }
}
