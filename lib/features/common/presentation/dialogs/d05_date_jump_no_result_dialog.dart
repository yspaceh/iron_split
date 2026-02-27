import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

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
      title: t.d05_date_jump_no_result.title,
      content: Text(
        t.d05_date_jump_no_result.content,
        style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.back,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.common.buttons.add_record,
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
