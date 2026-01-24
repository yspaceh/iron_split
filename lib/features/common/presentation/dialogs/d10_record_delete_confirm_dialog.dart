import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class D10RecordDeleteConfirmDialog extends StatelessWidget {
  final String title;
  final String amount;
  final VoidCallback onConfirm;

  const D10RecordDeleteConfirmDialog({
    super.key,
    required this.title,
    required this.amount,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(t.D10_RecordDelete_Confirm.delete_record_title),
      content: Text(
        t.D10_RecordDelete_Confirm.delete_record_content(
            title: title, amount: amount),
      ),
      actions: [
        // Left: Secondary Action (Tonal/Outlined) - Cancel
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(t.common.cancel),
        ),
        // Right: Primary Action (Filled) - Delete
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () {
            onConfirm();
            context.pop();
          },
          child: Text(t.common.delete),
        ),
      ],
    );
  }
}
