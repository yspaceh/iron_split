import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: [在此填入 CSV 中的 Page Key，例如 D03_TaskCreate.Confirm]
/// 類型: Dialog
/// 描述: 根據專案聖經規範預留的空白 Dialog 檔案
class D07RenameMemberDialog extends StatefulWidget {
  final String initialName;
  final ValueChanged<String> onConfirm;
  const D07RenameMemberDialog(
      {super.key, required this.initialName, required this.onConfirm});

  static Future<T?> show<T>(
    BuildContext context, {
    required String initialName,
    required ValueChanged<String> onConfirm,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          D07RenameMemberDialog(initialName: initialName, onConfirm: onConfirm),
    );
  }

  @override
  State<D07RenameMemberDialog> createState() => _D07RenameMemberDialogState();
}

class _D07RenameMemberDialogState extends State<D07RenameMemberDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleConfirm(BuildContext context) {
    final newName = _controller.text.trim();
    if (newName.isEmpty) return;
    context.pop();
    widget.onConfirm(newName);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return CommonAlertDialog(
      title: t.s53_task_settings_members.title,
      content: SizedBox(
        width: double.maxFinite,
        child: TaskNameInput(
          controller: _controller,
          maxLength: AppConstants.maxUserNameLength,
          fillColor: colorScheme.surfaceContainerLow,
          label: t.s53_task_settings_members.member_name,
          hint: t.s53_task_settings_members.member_name,
        ),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            final isValid = value.text.trim().isNotEmpty;
            return AppButton(
              text: t.common.buttons.confirm,
              type: AppButtonType.primary,
              onPressed: isValid ? () => _handleConfirm(context) : null,
            );
          },
        ),
      ],
    );
  }
}
