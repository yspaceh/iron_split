import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';

class D04CommonUnsavedConfirmDialog extends StatelessWidget {
  const D04CommonUnsavedConfirmDialog({
    super.key,
  });

  static Future<T?> show<T>(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => D04CommonUnsavedConfirmDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonAlertDialog(
        title: t.D04_CommonUnsaved_Confirm.title,
        content: Text(
          t.D04_CommonUnsaved_Confirm.content,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        actions: [
          AppButton(
            text: t.common.buttons.discard,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(true),
          ),
          AppButton(
            text: t.common.buttons.keep_editing,
            type: AppButtonType.primary,
            onPressed: () => context.pop(false),
          ),
        ]);
  }
}
