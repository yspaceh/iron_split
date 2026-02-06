import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/record/presentation/widgets/record_card.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15IncomeForm extends StatelessWidget {
  // 1. Controllers (接收外部控制器)
  final TextEditingController amountController;
  final TextEditingController memoController;
  final TextEditingController exchangeRateController;

  // 2. State (顯示用資料)
  final DateTime selectedDate;
  final CurrencyConstants selectedCurrencyConstants;
  final CurrencyConstants baseCurrency;
  final bool isRateLoading;

  // 3. Income Specific State (收入相關)
  final double baseRemainingAmount; // 這裡通常指總金額 (Total Amount)
  final String baseSplitMethod; // 分配方式
  final List<String> baseMemberIds; // 分配對象
  final List<Map<String, dynamic>> members; // 成員列表
  final Map<String, double> baseRawDetails;
  final double totalRemainder;

  // 4. Callbacks (動作)
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onFetchExchangeRate;
  final VoidCallback onShowRateInfo;
  final VoidCallback onBaseSplitConfigTap;

  const S15IncomeForm({
    super.key,
    required this.amountController,
    required this.memoController,
    required this.exchangeRateController,
    required this.selectedDate,
    required this.selectedCurrencyConstants,
    required this.baseCurrency,
    required this.isRateLoading,
    required this.members,
    required this.baseRemainingAmount,
    required this.baseSplitMethod,
    required this.baseMemberIds,
    required this.onFetchExchangeRate,
    required this.onShowRateInfo,
    required this.onBaseSplitConfigTap,
    required this.baseRawDetails,
    required this.totalRemainder,
    required this.onDateChanged,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 取得翻譯與主題
    final t = Translations.of(context); // 這裡定義 t
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 2. 準備顯示用變數
    final isForeign = selectedCurrencyConstants != baseCurrency;

    // 2. 貼上你原本的 ListView
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TaskDateInput(
          label: t.S15_Record_Edit.label.date,
          date: selectedDate,
          onDateChanged: onDateChanged,
        ),
        const SizedBox(height: 16),
        TaskAmountInput(
            onCurrencyChanged: onCurrencyChanged,
            amountController: amountController,
            selectedCurrencyConstants: selectedCurrencyConstants),
        if (isForeign) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: exchangeRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label.rate(
                  base: baseCurrency.code,
                  target: selectedCurrencyConstants.code),
              prefixIcon: IconButton(
                icon: const Icon(Icons.currency_exchange),
                onPressed: isRateLoading ? null : onFetchExchangeRate,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isRateLoading)
                    const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: onShowRateInfo,
                  ),
                ],
              ),
            ),
          ),
          Builder(
            builder: (context) {
              final amount = double.tryParse(amountController.text) ?? 0.0;
              final rate = double.tryParse(exchangeRateController.text) ?? 0.0;
              final converted = amount * rate;

              final formattedAmount =
                  CurrencyConstants.formatAmount(converted, baseCurrency.code);

              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  t.S15_Record_Edit.val.converted_amount(
                      base: baseCurrency.code,
                      symbol: baseCurrency.symbol,
                      amount: formattedAmount),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        if (baseRemainingAmount > 0) ...[
          RecordCard(
            t: t,
            selectedCurrencyConstants: selectedCurrencyConstants,
            members: members,
            amount: baseRemainingAmount,
            methodLabel: baseSplitMethod,
            memberIds: baseMemberIds,
            note: t.S15_Record_Edit.base_card_title_income,
            isBaseCard: true,
            onTap: onBaseSplitConfigTap,
            showSplitAction: false,
            onSplitTap: null,
          ),
          Builder(
            builder: (context) {
              if (totalRemainder > 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: InfoBar(
                    icon: Icons.savings_outlined,
                    text: Text(
                      t.S15_Record_Edit.msg_leftover_pot(
                          amount:
                              "${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(totalRemainder, baseCurrency.code)}"),
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onTertiaryContainer),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
        ],
        TaskMemoInput(
          memoController: memoController,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
