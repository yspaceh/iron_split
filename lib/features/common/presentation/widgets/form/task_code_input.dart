import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/constants/task_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskCodeInput extends StatelessWidget {
  const TaskCodeInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.fillColor,
    this.autofocus = false,
    this.focusNode,
    this.enabled = true,
    this.onScanPressed,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final Color? fillColor;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool enabled;
  final VoidCallback? onScanPressed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return AppTextField(
          controller: controller,
          autofocus: autofocus,
          labelText: label,
          hintText: hint,
          fillColor: fillColor,
          textCapitalization: TextCapitalization.characters,
          maxLength: TaskConstants.inviteCodeLength,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
          ],
          validator: (val) => (val == null || val.trim().isEmpty)
              ? t.error.message.empty(key: label)
              : null,
          focusNode: focusNode,
          enabled: enabled,
          suffixIcon: IconButton(
            onPressed: onScanPressed,
            icon: const Icon(Icons.qr_code_scanner_outlined),
          ),
        );
      },
    );
  }
}
