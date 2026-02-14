import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
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
  final RemainderDetail remainderDetail;

  // 4. Callbacks (動作)
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onFetchExchangeRate;
  final VoidCallback onShowRateInfo;
  final VoidCallback onBaseSplitConfigTap;

  final FocusNode amountFocusNode;
  final FocusNode rateFocusNode;
  final FocusNode memoFocusNode;

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
    required this.remainderDetail,
    required this.onDateChanged,
    required this.onCurrencyChanged,
    required this.amountFocusNode,
    required this.rateFocusNode,
    required this.memoFocusNode,
  });

  Widget buildRemainderInfo() {
    final symbol = "${baseCurrency.code}${baseCurrency.symbol}";

    // 情況 A: 發生抵銷 (Consumer 有值，但 Net 為 0)
    if (remainderDetail.consumer != 0 && remainderDetail.net == 0) {
      return InfoBar(
        icon: Icons.info_outline_rounded,
        text: Text(
          t.common.remainder_rule.message_zero_balance(
              amount:
                  "$symbol ${CurrencyConstants.formatAmount(remainderDetail.consumer, baseCurrency.code)}"),
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    // 情況 B: 一般零頭 (Net != 0)
    if (remainderDetail.net != 0) {
      return InfoBar(
        icon: Icons.savings_outlined,
        text: Text(
          t.common.remainder_rule.message_remainder(
              amount:
                  "$symbol ${CurrencyConstants.formatAmount(remainderDetail.net, baseCurrency.code)}"),
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    return const SizedBox.shrink();
  }

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
          focusNode: amountFocusNode,
          isIncome: true,
        ),
        if (isForeign) ...[
          const SizedBox(height: 8),
          TaskExchangeRateInput(
            controller: exchangeRateController,
            baseCurrency: baseCurrency,
            targetCurrency: selectedCurrencyConstants,
            amountController: amountController,
            focusNode: rateFocusNode,
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
              return buildRemainderInfo();
            },
          ),
          const SizedBox(height: 16),
        ],
        TaskMemoInput(
          memoController: memoController,
          focusNode: memoFocusNode,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
