import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_picker_field.dart';
import 'package:iron_split/features/task/presentation/widgets/record_card.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15IncomeForm extends StatelessWidget {
  // 1. Controllers (接收外部控制器)
  final TextEditingController amountController;
  final TextEditingController memoController;
  final TextEditingController exchangeRateController;

  // 2. State (顯示用資料)
  final DateTime selectedDate;
  final CurrencyOption selectedCurrencyOption;
  final CurrencyOption baseCurrencyOption;
  final bool isRateLoading;

  // 3. Income Specific State (收入相關)
  final double baseRemainingAmount; // 這裡通常指總金額 (Total Amount)
  final String baseSplitMethod; // 分配方式
  final List<String> baseMemberIds; // 分配對象
  final List<Map<String, dynamic>> members; // 成員列表

  // 4. Callbacks (動作)
  final VoidCallback onDateTap;
  final VoidCallback onCurrencyTap;
  final VoidCallback onFetchExchangeRate;
  final VoidCallback onShowRateInfo;
  final VoidCallback onBaseSplitConfigTap;

  const S15IncomeForm({
    super.key,
    required this.amountController,
    required this.memoController,
    required this.exchangeRateController,
    required this.selectedDate,
    required this.selectedCurrencyOption,
    required this.baseCurrencyOption,
    required this.isRateLoading,
    required this.members,
    required this.baseRemainingAmount,
    required this.baseSplitMethod,
    required this.baseMemberIds,
    required this.onDateTap,
    required this.onCurrencyTap,
    required this.onFetchExchangeRate,
    required this.onShowRateInfo,
    required this.onBaseSplitConfigTap,
  });

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onCurrencyTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedCurrencyOption.symbol,
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900),
                    ),
                    Text(
                      selectedCurrencyOption.code,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: t.S15_Record_Edit.label_amount,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (v) =>
                    (double.tryParse(v ?? '') ?? 0) <= 0 ? "Invalid" : null,
              ),
            ),
          ],
        ),
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
        RecordCard(
          t: t,
          selectedCurrencyOption: selectedCurrencyOption,
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
        const SizedBox(height: 16),
        TextFormField(
          controller: memoController,
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: t.S15_Record_Edit.label_memo,
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
