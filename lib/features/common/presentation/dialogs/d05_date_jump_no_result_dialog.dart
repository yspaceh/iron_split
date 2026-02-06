import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';

class D05DateJumpNoResultDialog extends StatelessWidget {
  final DateTime targetDate;
  final String taskId;

  const D05DateJumpNoResultDialog({
    super.key,
    required this.targetDate,
    required this.taskId,
  });

  static void show(BuildContext context,
      {required DateTime targetDate, required String taskId}) {
    showDialog(
      context: context,
      builder: (context) => D05DateJumpNoResultDialog(
        targetDate: targetDate,
        taskId: taskId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonAlertDialog(
      title: t.D05_DateJump_NoResult.title,
      content: Text(t.D05_DateJump_NoResult.content),
      actions: [
        AppButton(
          text: t.D05_DateJump_NoResult.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.D05_DateJump_NoResult.buttons.add,
          type: AppButtonType.primary,
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
        ),
      ],
    );
  }
}
