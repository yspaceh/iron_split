import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// 統一的滾輪選擇器 BottomSheet
void showCommonWheelPicker({
  required BuildContext context,
  required Widget child,
  VoidCallback? onConfirm,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final t = Translations.of(context);

  // 收起鍵盤
  FocusManager.instance.primaryFocus?.unfocus();

  showModalBottomSheet(
    context: context,
    backgroundColor: colorScheme.surface, // 純白背景
    // [修正] 恢復頂部圓角 16
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: SizedBox(
        height: 320, // 保持高度以容納大字體
        child: Column(
          children: [
            // 1. 頂部工具列
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 取消按鈕
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      t.common.buttons.cancel,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant, // 深灰色
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // 完成按鈕
                  TextButton(
                    onPressed: () {
                      onConfirm?.call();
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      t.common.buttons.confirm,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: colorScheme.primary, // 主色
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // [修正] 加強分隔線，使其清晰可見
            Divider(
                height: 1,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2)),

            // 2. 內容區
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}
