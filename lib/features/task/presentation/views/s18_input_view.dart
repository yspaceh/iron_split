import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_code_input.dart';
import 'package:iron_split/gen/strings.g.dart';

class S18InputView extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const S18InputView({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return TaskCodeInput(
      controller: controller,
      focusNode: focusNode,
      label: t.s18_task_enter_code.label.input,
      hint: t.s18_task_enter_code.hint.input,
    );
  }
}
