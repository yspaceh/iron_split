import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskExchangeRateInput extends StatelessWidget {
  const TaskExchangeRateInput({
    super.key,
    required this.controller,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.amountController,
    required this.isRateLoading,
    required this.onFetchRate,
    required this.onShowRateInfo,
    this.isIncome = false,
  });

  final TextEditingController controller;
  final CurrencyConstants baseCurrency;
  final CurrencyConstants targetCurrency;
  final TextEditingController amountController;
  final bool isRateLoading;
  final VoidCallback onFetchRate;
  final VoidCallback onShowRateInfo;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          // [UI 統一]：對齊底部，確保左側按鈕跟右側輸入框平行 (跟 TaskAmountInput 一樣)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左側：獨立的更新按鈕
            Padding(
              // 因為右側 Input 有 label (top padding)，所以按鈕要稍微往下推或是與其對齊
              // 這裡因為我們希望按鈕高度 64 跟 Input 一樣，所以直接放即可
              // 如果 Input 有錯誤訊息變長，使用 CrossAxisAlignment.start 會讓按鈕停在上面
              padding: const EdgeInsets.only(bottom: 2),
              child: InkWell(
                onTap: isRateLoading ? null : onFetchRate,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 64,
                  width: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: isRateLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: isIncome == true
                                  ? AppTheme.incomeDeep
                                  : AppTheme.expenseDeep,
                            ),
                          )
                        : Icon(
                            Icons.sync_alt_rounded, // 更新/交換圖示
                            color: isIncome == true
                                ? AppTheme.incomeDeep
                                : AppTheme.expenseDeep,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // 右側：匯率輸入框
            Expanded(
              child: AppTextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                labelText: t.S15_Record_Edit.label.rate_with_base(
                  base: baseCurrency.code,
                  target: targetCurrency.code,
                ),
                // [防呆邏輯核心]
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return t.error.message.required; // 必填
                  }
                  final rate = double.tryParse(val);
                  if (rate == null) {
                    return t.error.message.format; // 格式錯誤
                  }
                  // [關鍵]：禁止輸入 0 或 負數
                  if (rate <= 0) {
                    // 建議新增翻譯: "匯率必須大於 0"
                    return t.error.message
                        .zero(key: t.S15_Record_Edit.label.rate);
                  }
                  return null;
                },
                // 右側只保留 Info 按鈕
                suffixIcon: IconButton(
                  icon: const Icon(Icons.info_outline),
                  iconSize: 20,
                  color: colorScheme.onSurfaceVariant,
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onShowRateInfo,
                ),
              ),
            ),
          ],
        ),

        // 下方的換算結果顯示
        Builder(
          builder: (context) {
            return ValueListenableBuilder<TextEditingValue>(
              valueListenable: amountController,
              builder: (context, amountVal, _) {
                return ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, rateVal, _) {
                    final amount = double.tryParse(amountVal.text) ?? 0.0;
                    final rate = double.tryParse(rateVal.text) ?? 0.0;

                    final converted = amount * rate;
                    final formattedAmount = CurrencyConstants.formatAmount(
                        converted, baseCurrency.code);

                    return Text(
                      t.S15_Record_Edit.val.converted_amount(
                          base: baseCurrency.code,
                          symbol: baseCurrency.symbol,
                          amount: formattedAmount),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
