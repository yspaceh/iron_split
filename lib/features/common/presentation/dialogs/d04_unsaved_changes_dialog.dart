import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D04_Common.UnsavedChanges
/// Wireframe: Iron_split-15.jpg
/// 職責：通用「未儲存變更」確認彈窗
/// 回傳：Future<bool> -> true 表示確認離開 (Discard)，false 表示留下來繼續編輯
class D04UnsavedChangesDialog extends StatelessWidget {
  const D04UnsavedChangesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(t.D04_Common_UnsavedChanges.title),
      content: Text(t.D04_Common_UnsavedChanges.content),
      actions: [
        // 左側按鈕：回首頁 (離開/放棄) - 對應 Wireframe 左邊
        // 通常破壞性操作 (Discard) 會用 Outlined 或 TextButton，但在這裡它是「確認離開」的意思
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.error, // 用紅色提示這是「放棄」操作
          ),
          child: Text(t.D04_Common_UnsavedChanges.action_leave),
        ),

        // 右側按鈕：繼續編輯 (留下來) - 對應 Wireframe 右邊 (Primary Action)
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(t.D04_Common_UnsavedChanges.action_stay),
        ),
      ],
    );
  }
}
