import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    // [重構] onCurrencyChanged 改為可空 (Nullable)，因為如果不顯示 Picker 就不需要它
    this.onCurrencyChanged,
    required this.amountController,
    required this.selectedCurrencyConstants,
    this.isIncome = false,
    // [新增] 控制是否顯示左側幣別選擇器
    this.showCurrencyPicker = true,
  });

  final ValueChanged<String>? onCurrencyChanged;
  final TextEditingController amountController;
  final CurrencyConstants selectedCurrencyConstants;
  final bool isIncome;
  final bool showCurrencyPicker;

  void _showCurrencyPicker(BuildContext context) {
    if (onCurrencyChanged == null) return;

    CurrencyPickerSheet.show(
      context: context,
      initialCode: selectedCurrencyConstants.code,
      onSelected: (currency) {
        onCurrencyChanged!(currency.code);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 定義金額顏色 (支出紅/收入綠)
    final amountColor = isIncome ? AppTheme.incomeDeep : AppTheme.expenseDeep;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 左側：幣別選擇按鈕 (只在 showCurrencyPicker 為 true 時顯示)
        if (showCurrencyPicker) ...[
          InkWell(
            onTap: () => _showCurrencyPicker(context),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 64,
              width: 56,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    selectedCurrencyConstants.symbol,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedCurrencyConstants.code,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        // 2. 右側：金額輸入
        Expanded(
          child: AppTextField(
            controller: amountController,
            labelText: t.S15_Record_Edit.label.amount,
            hintText: CurrencyConstants.formatAmount(
                0, selectedCurrencyConstants.code),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),

            // [新增] 如果左側沒顯示 Picker，我們在輸入框內顯示幣別符號，
            // 這樣使用者才知道現在輸入的是什麼幣
            prefixIcon: !showCurrencyPicker
                ? null // 這裡如果想用 IconData 可以傳，但我們想顯示文字符號
                : null,
            // 使用 leading 屬性 (如果您的 AppTextField 有支援 widget leading)
            // 或是利用 prefixText (AppTextField 需要支援)
            // 假設 AppTextField 暫時只支援 prefixIcon (IconData)，
            // 我們可以利用 suffixText 或是改用 decoration 來顯示幣別

            // 這裡為了簡單，如果不顯示 Picker，我們可以在 suffix 顯示幣別代碼
            suffixText:
                !showCurrencyPicker ? selectedCurrencyConstants.code : null,

            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.error.message.required;
              }
              final value = double.tryParse(v);
              if (value == null) {
                return t.error.message.format;
              }
              if (value == 0) {
                return t.error.message
                    .zero(key: t.S15_Record_Edit.label.amount);
              }
              if (value < 0) {
                return t.error.message.invalid_amount;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
