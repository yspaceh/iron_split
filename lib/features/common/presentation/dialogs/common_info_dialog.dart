import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';

class CommonInfoDialog extends StatelessWidget {
  final String title;
  final String content;

  const CommonInfoDialog(
      {super.key, required this.title, required this.content});

  static void show(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => CommonInfoDialog(
        title: title,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonAlertDialog(
      title: title,
      content: Text(
        content,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.close,
          type: AppButtonType.primary,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
