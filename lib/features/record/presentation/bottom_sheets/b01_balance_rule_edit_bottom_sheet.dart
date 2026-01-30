import 'package:flutter/material.dart';

/// Page Key: [在此填入 CSV 中的 Page Key，例如 B06_PaymentInfo.Detail]
/// 類型: BottomSheet
/// 描述: 根據專案聖經規範預留的空白 Bottom Sheet 檔案
class B01BalanceRuleEditBottomSheet extends StatelessWidget {
  const B01BalanceRuleEditBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 使用 Material 3 的圓角規範
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 根據內容自動調整高度
        children: [
          // Handle Bar (M3 標準樣式)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              width: 32.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),

          // Header 區塊 (對應 UI Blocks: Header)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '標題預留位置',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(),

          // Body 區塊 (預留給資料顯示)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('在此實作 UI Blocks 與 Data Needed 內容'),
          ),

          // Footer 區塊 (預留給操作按鈕)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9C393F), // 聖經指定主色: 酒紅色
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // 主要操作行為
                },
                child: const Text('確認'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 呼叫此 BottomSheet 的範例方法：
/*
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
  ),
  builder: (context) => const GenericBottomSheet(),
);
*/
