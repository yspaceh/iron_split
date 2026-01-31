import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String? content; // 改為可空，用於顯示純文字
  final Widget? child; // 新增：用於顯示複雜內容 (如列表)
  final String? confirmText;
  final String? cancelText;
  final bool isDestructive;
  final bool? showCancel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CommonAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.child,
    this.confirmText,
    this.cancelText,
    this.isDestructive = false,
    this.showCancel,
    this.onConfirm,
    this.onCancel,
  }) : assert(content != null || child != null,
            'Content or child must be provided');

  /// Helper static method
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? child, // 新增參數
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
        child: child,
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

    final bool shouldShowCancel = showCancel ?? (onConfirm != null);

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      // 核心修改：優先使用 child，沒有才用 Text
      content: child ?? Text(content ?? '', style: theme.textTheme.bodyMedium),
      // 統一使用 Scrollable，避免內容過長爆版
      scrollable: true,
      actions: [
        if (shouldShowCancel)
          TextButton(
            onPressed: () {
              context.pop();
              if (onCancel != null) onCancel!();
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurfaceVariant,
            ),
            child: Text(cancelText ?? t.common.cancel),
          ),
        TextButton(
          onPressed: () {
            context.pop();
            if (onConfirm != null) onConfirm!();
          },
          style: TextButton.styleFrom(
            foregroundColor: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          ),
          child: Text(confirmText ?? t.common.confirm),
        ),
      ],
    );
  }
}
