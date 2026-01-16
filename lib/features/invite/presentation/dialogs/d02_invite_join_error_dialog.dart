import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D02_InviteJoin.Error (p10)
/// 職責：顯示加入失敗訊息，包含名額已滿、連結過期等情況。
class D02InviteJoinErrorDialog extends StatelessWidget {
  final String errorCode; // 例如: 'TASK_FULL', 'EXPIRED', 'INVALID'

  const D02InviteJoinErrorDialog({
    super.key,
    required this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 根據 errorCode 決定顯示的文字內容
    String title = t.D02_InviteJoin_Error.title;
    String message = t.D02_InviteJoin_Error.message;

    if (errorCode == 'TASK_FULL') {
      title = t.error.taskFull.title;
      message = t.error.taskFull.message(limit: 6); // 假設上限 6 人
    } else if (errorCode == 'EXPIRED' || errorCode == 'INVALID') {
      title = t.error.expiredCode.title;
      message = t.error.expiredCode.message(minutes: 15);
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      icon: Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 48),
      title: Text(title, textAlign: TextAlign.center),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: textTheme.bodyLarge,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/tasks'); // 錯誤後回到首頁
            },
            child: Text(t.D02_InviteJoin_Error.action_close),
          ),
        ),
      ],
    );
  }
}