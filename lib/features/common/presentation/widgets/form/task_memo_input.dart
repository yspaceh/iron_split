import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemoInput extends StatelessWidget {
  const TaskMemoInput({
    super.key,
    required this.memoController,
  });
  final TextEditingController memoController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: memoController,
      keyboardType: TextInputType.multiline,
      minLines: 2,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: t.S15_Record_Edit.label_memo,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
