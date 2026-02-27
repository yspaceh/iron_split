import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_code_input.dart';
import 'package:iron_split/gen/strings.g.dart';

class S18InputView extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onScanPressed;

  const S18InputView({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return TaskCodeInput(
      controller: controller,
      focusNode: focusNode,
      label: t.S18_Task_Join.label.input,
      hint: t.S18_Task_Join.hint.input,
      onScanPressed: onScanPressed,
    );
  }
}
