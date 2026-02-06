import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_exchange_rate_input.dart';
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
        const SizedBox(height: 8),
        TaskAmountInput(
          onCurrencyChanged: onCurrencyChanged,
          amountController: amountController,
          selectedCurrencyConstants: selectedCurrencyConstants,
          isIncome: true,
        ),
        if (isForeign) ...[
          const SizedBox(height: 8),
          TaskExchangeRateInput(
            controller: exchangeRateController,
            baseCurrency: baseCurrency,
            targetCurrency: selectedCurrencyConstants,
            amountController: amountController,
            isRateLoading: isRateLoading,
            onFetchRate: onFetchExchangeRate,
            onShowRateInfo: onShowRateInfo,
            isIncome: true,
          ),
        ],
        const SizedBox(height: 8),
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
            isIncome: true,
          ),
          Builder(
            builder: (context) {
              if (totalRemainder > 0) {
                return InfoBar(
                  icon: Icons.savings_outlined,
                  text: Text(
                    t.S15_Record_Edit.msg_leftover_pot(
                        amount:
                            "${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(totalRemainder, baseCurrency.code)}"),
                    style: TextStyle(fontSize: 12),
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
