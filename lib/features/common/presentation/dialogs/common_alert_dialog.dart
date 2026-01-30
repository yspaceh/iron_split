import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? confirmText;
  final String? cancelText;
  final bool isDestructive; // 是否為破壞性操作 (紅色按鈕)
  final bool? showCancel; // 強制顯示/隱藏取消按鈕 (若為 null 則自動判斷)
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.isDestructive = false,
    this.showCancel,
    this.onConfirm,
    this.onCancel,
  });

  /// Helper static method 方便直接呼叫
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
    bool? showCancel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        showCancel: showCancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    // 自動判斷是否顯示取消按鈕：
    // 如果有指定 showCancel 則依指定；
    // 否則，如果有 onConfirm (代表有選擇性)，預設顯示取消；否則視為純通知 (Info)，不顯示取消。
    final bool shouldShowCancel = showCancel ?? (onConfirm != null);

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      content: Text(content, style: theme.textTheme.bodyMedium),
      actions: [
        // 取消按鈕
        if (shouldShowCancel)
          TextButton(
            onPressed: () {
              context.pop();
              if (onCancel != null) onCancel!();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant, // 灰色/次要色
            ),
            child: Text(cancelText ?? t.common.cancel),
          ),

        // 確認按鈕
        TextButton(
          onPressed: () {
            context.pop(); // 關閉 Dialog
            if (onConfirm != null) onConfirm!();
          },
          style: TextButton.styleFrom(
            foregroundColor:
                isDestructive ? theme.colorScheme.error : null, // 紅色警示
          ),
          child: Text(confirmText ?? t.common.confirm),
        ),
      ],
    );
  }
}
