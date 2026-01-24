import 'package:flutter/material.dart';

/// Page Key: [在此填入 CSV 中的 Page Key，例如 D03_TaskCreate.Confirm]
/// 類型: Dialog
/// 描述: 根據專案聖經規範預留的空白 Dialog 檔案
class D06SettlementConfirmDialog extends StatelessWidget {
  const D06SettlementConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Material 3 圓角規範
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,

      // Header 區塊 (對應 UI Blocks: Title)
      title: const Text(
        '標題預留位置',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1C1B1F),
        ),
      ),

      // Body 區塊 (對應 UI Blocks: Text/BodyText)
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '在此根據 Page Spec 實作 Data Needed 顯示內容或防呆規則說明。',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF49454F),
            ),
          ),
        ],
      ),

      // Footer 區塊 (對應 UI Blocks: ActionsRow/PrimaryButton)
      actions: [
        // Secondary Action (例如：取消/返回編輯)
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            '取消',
            style: TextStyle(color: Color(0xFF49454F)),
          ),
        ),

        // Primary Action (例如：確認)
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF9C393F), // 聖經指定主色: 酒紅色
          ),
          onPressed: () {
            // 主要操作行為
            Navigator.pop(context);
          },
          child: const Text('確認'),
        ),
      ],
    );
  }
}

// 呼叫此 Dialog 的範例方法：
/*
showDialog(
  context: context,
  builder: (context) => const GenericDialog(),
);
*/
