import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final VoidCallback? onConfirm;

  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.onConfirm,
  });

  /// Helper static method 方便直接呼叫
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    VoidCallback? onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(content, style: theme.textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: () {
            context.pop(); // 關閉 Dialog
            if (onConfirm != null) onConfirm!();
          },
          child: Text(confirmText ?? t.common.confirm),
        ),
      ],
    );
  }
}
