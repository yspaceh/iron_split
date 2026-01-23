import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart'; // 確保能讀取 i18n

/// 統一的滾輪選擇器 BottomSheet
/// 負責顯示「取消/完成」與容器樣式
void showCommonWheelPicker({
  required BuildContext context,
  required Widget child, // 傳入 CupertinoPicker 或 CupertinoDatePicker
  VoidCallback? onConfirm, // 按下「完成」時的 callback
}) {
  // 收起鍵盤
  FocusScope.of(context).unfocus();

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    // 讓 BottomSheet 圓角好看一點
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            // 1. 頂部工具列 (取消 / 完成)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 取消按鈕
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      t.common.cancel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  // 完成按鈕
                  TextButton(
                    onPressed: () {
                      // 先執行確認邏輯 (儲存變數)
                      onConfirm?.call();
                      // 再關閉視窗
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      t.S16_TaskCreate_Edit.picker_done,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // 2. 內容區 (Picker)
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}
