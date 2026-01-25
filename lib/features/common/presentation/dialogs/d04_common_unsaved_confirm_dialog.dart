import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D04_Common.UnsavedConfirm
/// 職責：通用「未儲存變更」確認彈窗
/// 回傳：Future<bool> -> true 表示確認離開 (Discard)，false 表示留下來繼續編輯
class D04CommonUnsavedConfirmDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;

  const D04CommonUnsavedConfirmDialog({
    super.key,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(title ?? t.dialog.unsaved_changes_title),
      content: Text(content ?? t.dialog.unsaved_changes_content),
      actions: [
        // 左側按鈕：回首頁 (離開/放棄) - 紅色
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.error,
          ),
          child: Text(confirmText ?? t.common.discard),
        ),

        // 右側按鈕：繼續編輯 (留下來)
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText ?? t.common.keep_editing),
        ),
      ],
    );
  }
}
