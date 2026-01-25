import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class D05DateJumpNoResultDialog extends StatelessWidget {
  final DateTime targetDate;
  final String taskId;

  const D05DateJumpNoResultDialog({
    super.key,
    required this.targetDate,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(t.D05_DateJump_NoResult.title),
      content: Text(t.D05_DateJump_NoResult.content),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(t.D05_DateJump_NoResult.action_cancel),
        ),
        FilledButton(
          onPressed: () {
            context.pop(); // Close dialog first
            // Navigate to Create Page with pre-filled date
            // Note: We use 'date' as key because AppRouter extracts it as initialDate
            context.pushNamed(
              'S15',
              pathParameters: {'taskId': taskId},
              extra: {'date': targetDate},
            );
          },
          child: Text(t.D05_DateJump_NoResult.action_add),
        ),
      ],
    );
  }
}
