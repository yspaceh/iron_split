import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/widgets/common_picker_field.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_item_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/task/presentation/widgets/record_card.dart';
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
  final CurrencyConstants baseCurrencyConstants;
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

  // 4. 接收支付狀態
  final String payerType;
  final String payerId;
  final bool hasPaymentError;

  // 5. 定義動作 (當使用者點擊時，通知 Parent 執行)
  final VoidCallback onDateTap;
  final VoidCallback onPaymentMethodTap;
  final VoidCallback onCategoryTap;
  final VoidCallback onCurrencyTap;
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
    required this.baseCurrencyConstants,
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
    required this.onDateTap,
    required this.onPaymentMethodTap,
    required this.onCategoryTap,
    required this.onCurrencyTap,
    required this.onFetchExchangeRate,
    required this.onShowRateInfo,
    required this.onBaseSplitConfigTap,
    required this.onAddItemTap,
    required this.onDetailEditTap,
    required this.poolBalancesByCurrency,
    required this.baseRawDetails,
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
    return t.S15_Record_Edit.val_member_paid(name: member['displayName']);
  }

  @override
  Widget build(BuildContext context) {
    // 1. 取得翻譯與主題
    final t = Translations.of(context); // 這裡定義 t
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 2. 準備顯示用變數
    final isForeign = selectedCurrencyConstants != baseCurrencyConstants;

    final rate = double.tryParse(exchangeRateController.text) ?? 1.0;
    double totalRemainder = 0.0;

    // A. 累加所有細項 (Details) 的零頭
    for (var detail in details) {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: detail.amount,
        exchangeRate: rate,
        splitMethod: detail.splitMethod,
        memberIds: detail.splitMemberIds,
        details: detail.splitDetails ?? {},
      );
      totalRemainder += result.remainder;
    }

    // B. 累加剩餘金額 (Base Remaining) 的零頭 (如果有剩)
    if (baseRemainingAmount > 0 || details.isEmpty) {
      final result = BalanceCalculator.calculateSplit(
        totalAmount: baseRemainingAmount,
        exchangeRate: rate,
        splitMethod: baseSplitMethod,
        memberIds: baseMemberIds,
        details: baseRawDetails, // [注意] 必須傳入 baseRawDetails 才能算準
      );
      totalRemainder += result.remainder;
    }

    debugPrint(
        'baseRemainingAmount.toString():${baseRemainingAmount.toString()}');

    // C. 消除浮點數誤差
    totalRemainder = double.parse(totalRemainder.toStringAsFixed(3));

    // 2. 貼上你原本的 ListView
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CommonPickerField(
          label: t.S15_Record_Edit.label_date,
          value: DateFormat('yyyy/MM/dd (E)').format(selectedDate),
          icon: Icons.calendar_today,
          onTap: onDateTap,
        ),
        const SizedBox(height: 16),
        CommonPickerField(
          label: t.S15_Record_Edit.label_payment_method,
          value: _getPayerDisplayName(t, payerType, payerId),
          icon: payerType == 'prepay'
              ? Icons.account_balance_wallet
              : Icons.person,
          onTap: onPaymentMethodTap,
          isError: hasPaymentError,
        ),
        // 若有錯誤顯示紅字提示 (加在欄位下方)
        if (hasPaymentError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              t.B07_PaymentMethod_Edit.err_balance_not_enough,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),
        const SizedBox(height: 16),
        TaskItemInput(
            onCategoryTap: onCategoryTap,
            titleController: titleController,
            selectedCategoryId: selectedCategoryId),
        const SizedBox(height: 16),
        TaskAmountInput(
            onCurrencyTap: onCurrencyTap,
            amountController: amountController,
            selectedCurrencyConstants: selectedCurrencyConstants),
        if (isForeign) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: exchangeRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_rate(
                  base: baseCurrencyConstants.code,
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
              final formattedAmount = CurrencyConstants.formatAmount(
                  converted, baseCurrencyConstants.code);

              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  t.S15_Record_Edit.val_converted_amount(
                      base: baseCurrencyConstants.code,
                      symbol: baseCurrencyConstants.symbol,
                      amount: formattedAmount),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        if (details.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(
              t.S15_Record_Edit.section_items,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
            // 只有基本卡片且有餘額時，顯示分拆按鈕
            showSplitAction: baseRemainingAmount > 0,
            onSplitTap: onAddItemTap,
          ),
        ],
        if (totalRemainder > 0)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InfoBar(
              text: Text(
                t.S15_Record_Edit.msg_leftover_pot(
                    amount:
                        "${baseCurrencyConstants.code}${baseCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(totalRemainder, baseCurrencyConstants.code)}"),
                style: TextStyle(
                    fontSize: 12, color: theme.colorScheme.onTertiaryContainer),
              ),
            ),
          ),
        const SizedBox(height: 16),
        TaskMemoInput(
          memoController: memoController,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
