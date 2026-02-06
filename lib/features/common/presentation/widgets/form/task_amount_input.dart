import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    required this.onCurrencyChanged,
    required this.amountController,
    required this.selectedCurrencyConstants,
    this.isIncome = false,
  });

  final ValueChanged<String> onCurrencyChanged;
  final TextEditingController amountController;
  final CurrencyConstants selectedCurrencyConstants;
  final bool isIncome;

  void _showCurrencyPicker(BuildContext context) {
    CurrencyPickerSheet.show(
      context: context,
      initialCode: selectedCurrencyConstants.code,
      onSelected: (currency) {
        onCurrencyChanged(currency.code);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      // 保持 start 對齊，避免錯誤訊息出現時左側跑版
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左側：幣別按鈕
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
                    color: isIncome == true
                        ? AppTheme.incomeDeep
                        : AppTheme.expenseDeep,
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

        // 右側：金額輸入
        Expanded(
          child: AppTextField(
            controller: amountController,
            labelText: t.S15_Record_Edit.label.amount,
            hintText: CurrencyConstants.formatAmount(
                0, selectedCurrencyConstants.code),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),

            // [精準驗證邏輯]
            validator: (v) {
              // 1. 空值檢查
              if (v == null || v.isEmpty) {
                // 回傳 "此欄位必填"
                return t.error.message.required;
              }

              final value = double.tryParse(v);

              // 2. 格式檢查 (亂填文字)
              if (value == null) {
                // 回傳 "格式錯誤"
                return t.error.message.format;
              }

              // 3. 零值檢查 (這裡放您的新訊息)
              if (value == 0) {
                // [在此處放入您準備好的錯誤訊息]
                // 例如: t.S15_Record_Edit.error_amount_zero
                return t.error.message
                    .zero(key: t.S15_Record_Edit.label.amount);
              }

              // 4. 負數檢查 (如果您的 App 不允許負支出)
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
