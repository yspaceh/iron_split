import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_exchange_rate_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_item_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/record/presentation/widgets/record_card.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15ExpenseForm extends StatelessWidget {
  // 1. 接收控制器 (讓 Parent 可以讀取輸入值)
  final TextEditingController amountController;
  final TextEditingController titleController;
  final TextEditingController memoController;
  final TextEditingController exchangeRateController;

  // 2. 接收狀態資料 (顯示用)
  final DateTime selectedDate;
  final CurrencyConstants selectedCurrencyConstants;
  final CurrencyConstants baseCurrency;
  final String selectedCategoryId;
  final bool isRateLoading;

  final Map<String, double> poolBalancesByCurrency;

  // 3. 接收複雜邏輯資料
  final List<Map<String, dynamic>> members; // 從 parent 傳入 members
  final List<RecordDetail> details; // 從 parent 傳入 _details
  final double baseRemainingAmount;
  final String baseSplitMethod;
  final List<String> baseMemberIds;
  final Map<String, double> baseRawDetails;
  final double totalRemainder;

  // 4. 接收支付狀態
  final String payerType;
  final String payerId;
  final bool hasPaymentError;

  // 5. 定義動作 (當使用者點擊時，通知 Parent 執行)
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onCurrencyChanged;
  final VoidCallback onPaymentMethodTap;
  final VoidCallback onFetchExchangeRate;
  final VoidCallback onShowRateInfo;
  final VoidCallback onBaseSplitConfigTap; // 點擊剩餘金額卡片時
  final VoidCallback onAddItemTap; // 點擊新增細項時
  final Function(RecordDetail) onDetailEditTap; // 點擊既有細項時

  const S15ExpenseForm({
    super.key,
    required this.amountController,
    required this.titleController,
    required this.memoController,
    required this.exchangeRateController,
    required this.selectedDate,
    required this.selectedCurrencyConstants,
    required this.baseCurrency,
    required this.selectedCategoryId,
    required this.isRateLoading,
    required this.members,
    required this.details,
    required this.baseRemainingAmount,
    required this.baseSplitMethod,
    required this.baseMemberIds,
    required this.payerType,
    required this.payerId,
    required this.hasPaymentError,
    required this.onDateChanged,
    required this.onPaymentMethodTap,
    required this.onFetchExchangeRate,
    required this.onShowRateInfo,
    required this.onBaseSplitConfigTap,
    required this.onAddItemTap,
    required this.onDetailEditTap,
    required this.poolBalancesByCurrency,
    required this.baseRawDetails,
    required this.totalRemainder,
    required this.onCategoryChanged,
    required this.onCurrencyChanged,
  });

  // 支援多種支付型態顯示
  String _getPayerDisplayName(Translations t, String type, String id) {
    if (type == 'prepay') {
      // 1. 取得當前選擇幣別的公款餘額
      final currentCode = selectedCurrencyConstants.code;
      final balance = poolBalancesByCurrency[currentCode] ?? 0.0;

      // 2. 智慧顯示：直接顯示該幣別的餘額 (例如: JPY 30,000)
      // 不再強制換算回 Base Currency，這樣更符合物理錢包直覺
      return "${selectedCurrencyConstants.code} ${t.B07_PaymentMethod_Edit.type_prepay} (${selectedCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(balance, currentCode)})";
    }

    // ... (混合支付與成員代墊的邏輯保持不變)
    if (type == 'mixed') {
      return t.B07_PaymentMethod_Edit.type_mixed;
    }
    if (id == 'multiple') {
      return t.B07_PaymentMethod_Edit.type_member;
    }

    final member = members.firstWhere(
      (m) => m['id'] == id,
      orElse: () => {'displayName': '?'},
    );
    return t.S15_Record_Edit.val.member_paid(name: member['displayName']);
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
        // 2. 支付方式 (保留外部邏輯，因為邏輯太複雜不適合封裝)
        AppSelectField(
          labelText: t.S15_Record_Edit.label.payment_method,
          text: _getPayerDisplayName(t, payerType, payerId),
          onTap: baseRemainingAmount <= 0 ? () {} : onPaymentMethodTap,
          errorText: hasPaymentError
              ? t.B07_PaymentMethod_Edit.err_balance_not_enough
              : null,
        ),
        const SizedBox(height: 8),
        TaskItemInput(
            onCategoryChanged: onCategoryChanged,
            titleController: titleController,
            selectedCategoryId: selectedCategoryId),
        const SizedBox(height: 8),
        TaskAmountInput(
          onCurrencyChanged: onCurrencyChanged,
          amountController: amountController,
          selectedCurrencyConstants: selectedCurrencyConstants,
          isIncome: false,
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
            isIncome: false,
          ),
        ],
        const SizedBox(height: 8),
        if (details.isNotEmpty) ...[
          ...details.map(
            (detail) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: RecordCard(
                t: t,
                selectedCurrencyConstants: selectedCurrencyConstants,
                members: members,
                amount: detail.amount,
                methodLabel: detail.splitMethod,
                memberIds: detail.splitMemberIds,
                note: detail.name,
                isBaseCard: false,
                onTap: () => onDetailEditTap(detail),
                isIncome: false,
              ),
            ),
          ),
        ],
        if (baseRemainingAmount > 0 ||
            (details.isEmpty && baseRemainingAmount != 0)) ...[
          RecordCard(
            t: t,
            selectedCurrencyConstants: selectedCurrencyConstants,
            members: members,
            amount: baseRemainingAmount,
            methodLabel: baseSplitMethod,
            memberIds: baseMemberIds,
            note: null,
            isBaseCard: true,
            onTap: () => onBaseSplitConfigTap(),
            showSplitAction: baseRemainingAmount > 0,
            onSplitTap: onAddItemTap,
            isIncome: false,
          ),
        ],
        if (totalRemainder > 0)
          InfoBar(
            icon: Icons.savings_outlined,
            text: Text(
              t.S15_Record_Edit.msg_leftover_pot(
                  amount:
                      "${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(totalRemainder, baseCurrency.code)}"),
              style: TextStyle(fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        TaskMemoInput(
          memoController: memoController,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
