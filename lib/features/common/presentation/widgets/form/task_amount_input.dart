import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    this.onCurrencyChanged,
    required this.amountController,
    required this.selectedCurrencyConstants,
    this.isIncome = false,
    this.showCurrencyPicker = true,
    this.fillColor,
    // [新增] 外部驗證器
    this.externalValidator,
  });

  final ValueChanged<String>? onCurrencyChanged;
  final TextEditingController amountController;
  final CurrencyConstants selectedCurrencyConstants;
  final bool isIncome;
  final bool showCurrencyPicker;
  final Color? fillColor;
  final String? Function(double value)? externalValidator;

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

    final amountColor = isIncome ? AppTheme.incomeDeep : AppTheme.expenseDeep;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: AppTextField(
            controller: amountController,
            fillColor: fillColor,
            labelText: t.S15_Record_Edit.label.amount,
            hintText: CurrencyConstants.formatAmount(
                0, selectedCurrencyConstants.code),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixText: !showCurrencyPicker
                ? '${selectedCurrencyConstants.symbol} '
                : null,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.error.message.required;
              }

              // [修正] 必須先移除逗號，否則 tryParse 會失敗
              final cleanValue = v.replaceAll(',', '');
              final value = double.tryParse(cleanValue);

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

              // [新增] 執行外部驗證 (例如檢查餘額)
              if (externalValidator != null) {
                return externalValidator!(value);
              }

              return null;
            },
          ),
        ),
      ],
    );
  }
}
