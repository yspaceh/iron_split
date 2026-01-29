import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/services/calculation_service.dart';
import 'package:iron_split/features/common/presentation/widgets/common_picker_field.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_item_input.dart';
import 'package:iron_split/features/task/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/task/presentation/widgets/record_card.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15ExpenseForm extends StatelessWidget {
  // 建議改成 StatelessWidget，因為狀態都在外面
  // 1. 接收控制器 (讓 Parent 可以讀取輸入值)
  final TextEditingController amountController;
  final TextEditingController titleController;
  final TextEditingController memoController;
  final TextEditingController exchangeRateController;

  // 2. 接收狀態資料 (顯示用)
  final DateTime selectedDate;
  final CurrencyOption selectedCurrencyOption;
  final CurrencyOption baseCurrencyOption;
  final String selectedCategoryId;
  final bool isRateLoading;

  final Map<String, double> poolBalancesByCurrency;

  // 3. 接收複雜邏輯資料
  final List<Map<String, dynamic>> members; // 從 parent 傳入 members
  final List<RecordItem> items; // 從 parent 傳入 _items
  final double baseRemainingAmount;
  final String baseSplitMethod;
  final List<String> baseMemberIds;

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
  final Function(RecordItem) onItemEditTap; // 點擊既有細項時

  const S15ExpenseForm({
    super.key,
    required this.amountController,
    required this.titleController,
    required this.memoController,
    required this.exchangeRateController,
    required this.selectedDate,
    required this.selectedCurrencyOption,
    required this.baseCurrencyOption,
    required this.selectedCategoryId,
    required this.isRateLoading,
    required this.members,
    required this.items,
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
    required this.onItemEditTap,
    required this.poolBalancesByCurrency,
  });

  // 支援多種支付型態顯示
  String _getPayerDisplayName(Translations t, String type, String id) {
    if (type == 'prepay') {
      // 1. 取得當前選擇幣別的公款餘額
      final currentCode = selectedCurrencyOption.code;
      final balance = poolBalancesByCurrency[currentCode] ?? 0.0;

      // 2. 智慧顯示：直接顯示該幣別的餘額 (例如: JPY 30,000)
      // 不再強制換算回 Base Currency，這樣更符合物理錢包直覺
      return "${selectedCurrencyOption.code} ${t.B07_PaymentMethod_Edit.type_prepay} (${selectedCurrencyOption.symbol} ${CurrencyOption.formatAmount(balance, currentCode)})";
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
      orElse: () => {'name': '?'},
    );
    return t.S15_Record_Edit.val_member_paid(name: member['name']);
  }

  @override
  Widget build(BuildContext context) {
    // 1. 取得翻譯與主題
    final t = Translations.of(context); // 這裡定義 t
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 2. 準備顯示用變數
    final isForeign = selectedCurrencyOption != baseCurrencyOption;

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
            selectedCurrencyOption: selectedCurrencyOption),
        if (isForeign) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: exchangeRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_rate(
                  base: baseCurrencyOption.code,
                  target: selectedCurrencyOption.code),
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
              final formattedAmount = CurrencyOption.formatAmount(
                  converted, baseCurrencyOption.code);

              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Text(
                  t.S15_Record_Edit.val_converted_amount(
                      base: baseCurrencyOption.code,
                      symbol: baseCurrencyOption.symbol,
                      amount: formattedAmount),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              );
            },
          ),
        ],
        const SizedBox(height: 12),
        if (items.isNotEmpty) ...[
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
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RecordCard(
                  t: t,
                  selectedCurrencyOption: selectedCurrencyOption,
                  members: members,
                  amount: item.amount,
                  methodLabel: item.splitMethod,
                  memberIds: item.splitMemberIds,
                  note: item.name,
                  isBaseCard: false,
                  onTap: () => onItemEditTap(item),
                ),
              )),
        ],
        if (baseRemainingAmount > 0 || items.isEmpty) ...[
          RecordCard(
            t: t,
            selectedCurrencyOption: selectedCurrencyOption,
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
          if (baseSplitMethod == 'even' && baseMemberIds.isNotEmpty)
            Builder(
              builder: (context) {
                final rate =
                    double.tryParse(exchangeRateController.text) ?? 1.0;
                final baseTotal = CalculationService.calculateBaseTotal(
                    baseRemainingAmount, rate);
                final split = CalculationService.calculateEvenSplit(
                    baseTotal, baseMemberIds.length);
                if (split.remainder > 0) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      t.S13_Task_Dashboard.label_remainder(
                          amount:
                              "${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(split.remainder, baseCurrencyOption.code)}"),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.outline),
                      textAlign: TextAlign.end,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
        const SizedBox(height: 16),
        TaskMemoInput(
          memoController: memoController,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
