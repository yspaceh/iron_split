import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart'; // 請確認路徑正確
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    required this.onCurrencyTap,
    required this.amountController,
    required this.selectedCurrencyConstants,
  });

  final VoidCallback onCurrencyTap;
  final TextEditingController amountController;
  final CurrencyConstants selectedCurrencyConstants;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      // [關鍵]：因為 AppTextField 上方可能有 Label，使用 end 讓幣別按鈕對齊「輸入框」的底部
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 左側：幣別選擇按鈕 (風格化為 AppTextField 的樣式)
        Padding(
          // 為了對齊右邊 AppTextField 輸入框的高度，稍微往下推一點點 (若右邊有 label)
          // 如果覺得對不齊，可以調整這裡，或者單純靠 CrossAxisAlignment.end
          padding: const EdgeInsets.only(bottom: 2),
          child: InkWell(
            onTap: onCurrencyTap,
            borderRadius: BorderRadius.circular(16), // 與 AppTextField 統一
            child: Container(
              // 高度設定為與 AppTextField (含 padding) 一致，約 54~56
              height: 54,
              width: 64, // 稍微加寬一點，讓內容呼吸
              decoration: BoxDecoration(
                // [風格統一]：使用與 AppTextField 相同的淡灰底色
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedCurrencyConstants.symbol,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary, // 強調色
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedCurrencyConstants.code,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant, // 次要色
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // 右側：金額輸入 (使用 AppTextField)
        Expanded(
          child: AppTextField(
            controller: amountController,
            labelText: t.S15_Record_Edit.label_amount,
            hintText: '0.00', // 給個提示
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            // 驗證邏輯
            validator: (v) {
              if (v == null || v.isEmpty) return null; // 空值不擋，交由 Submit 檢查
              final value = double.tryParse(v);
              if (value == null || value <= 0) {
                return t.error.text_input.invalid_amount; // 建議使用翻譯字串
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
