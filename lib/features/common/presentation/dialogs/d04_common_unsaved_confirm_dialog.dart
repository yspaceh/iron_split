import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

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
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );

    return CommonAlertDialog(
        title: t.d04_common_unsaved_confirm.title,
        content: Text(
          t.d04_common_unsaved_confirm.content,
          style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
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
