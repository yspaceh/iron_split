import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    this.onCurrencyChanged,
    required this.amountController,
    required this.selectedCurrencyConstants,
    this.isPrepay = false,
    this.showCurrencyPicker = true,
    this.fillColor,
    this.externalValidator,
    this.focusNode,
  });

  final ValueChanged<String>? onCurrencyChanged;
  final TextEditingController amountController;
  final CurrencyConstants selectedCurrencyConstants;
  final bool isPrepay;
  final bool showCurrencyPicker;
  final Color? fillColor;
  final String? Function(double value)? externalValidator;
  final FocusNode? focusNode;

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
    final themeVm = context.watch<ThemeViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final expenseColor = themeVm.themeMode == ThemeMode.dark
        ? AppTheme.expenseLight
        : AppTheme.expenseDeep;
    final prepayColor = themeVm.themeMode == ThemeMode.dark
        ? AppTheme.prepayLight
        : AppTheme.prepayDeep;

    final amountColor = isPrepay ? prepayColor : expenseColor;

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
                    style: textTheme.titleLarge?.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedCurrencyConstants.code,
                    style: textTheme.labelSmall?.copyWith(
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
            labelText: t.common.label.amount,
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
                return t.error.message.zero(key: t.common.label.amount);
              }
              if (value < 0) {
                return t.error.message.invalid_amount;
              }

              //  執行外部驗證 (例如檢查餘額)
              if (externalValidator != null) {
                return externalValidator!(value);
              }

              return null;
            },
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
