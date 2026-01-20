import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D02_InviteJoin.Error
/// 職責：顯示加入任務失敗的錯誤訊息（連結無效、過期、或已滿）。
class D02InviteJoinErrorDialog extends StatelessWidget {
  final String? errorMessage;

  const D02InviteJoinErrorDialog({
    super.key,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Title: "無法加入任務" / "Cannot Join Task"
      title: Text(t.D02_InviteJoin_Error.title),

      // Content: 優先顯示後端傳回的具體錯誤，若無則顯示通用訊息
      // "連結無效、已過期或任務人數已達上限。"
      content: Text(errorMessage ?? t.D02_InviteJoin_Error.message),

      actions: [
        // Action: "關閉" / "Close"
        FilledButton(
          onPressed: () => context.pop(),
          child: Text(t.D02_InviteJoin_Error.action_close),
        ),
      ],
    );
  }
}
