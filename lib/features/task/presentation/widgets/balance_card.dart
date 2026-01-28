import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this is imported for the update
import 'package:iron_split/features/common/presentation/bottom_sheets/remainder_rule_picker_sheet.dart'; // Import the new picker
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'dart:ui' as ui;

class BalanceCard extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic>? taskData;
  final Map<String, dynamic>? memberData;
  final List<QueryDocumentSnapshot> records;
  final double remainderBuffer;

  const BalanceCard({
    super.key,
    required this.taskId,
    required this.taskData,
    required this.memberData,
    required this.records,
    required this.remainderBuffer,
  });

  /// ! CRITICAL LAYOUT CONFIGURATION !
  /// Used by S13Page to calculate Sticky Header size.
  /// IF YOU UPDATE UI (Rows, Padding), YOU MUST UPDATE THIS VALUE MANUALLY.
  /// Breakdown:
  /// Pad Top: 16
  /// Header: 44
  /// Gap: 8
  /// Legend: 20
  /// Gap: 8
  /// Chart: 12 (Slim Visual Bar)
  /// Gap: 12
  /// Footer: 40
  /// Pad Bottom: 16
  /// TOTAL = 176.0
  static const double fixedHeight = 176.0;

  @override
  Widget build(BuildContext context) {
    if (taskData == null) return const SizedBox.shrink();

    final t = Translations.of(context);
    final theme = Theme.of(context);
    // 1. Data Parsing
    final String systemCurrency = NumberFormat.simpleCurrency(
                locale: Localizations.localeOf(context).toString())
            .currencyName ??
        '';

    final basrCurrency = taskData!['baseCurrency'] ??
        (systemCurrency.isNotEmpty
            ? systemCurrency
            : CurrencyOption.defaultCode);

    final baseCurrencyOption = CurrencyOption.getCurrencyOption(basrCurrency);

    // 2. 轉換為 Model
    final recordModels =
        records.map((doc) => RecordModel.fromFirestore(doc)).toList();

    final baseTotal = BalanceCalculator.calculateBaseTotals(recordModels,
        isBaseCurrency: true);
    final poolBalanceByBaseCurrency =
        BalanceCalculator.calculatePoolBalanceByBaseCurrency(recordModels);
    final poolBalancesByOriginalCurrency =
        BalanceCalculator.calculatePoolBalancesByOriginalCurrency(recordModels);

    final double totalIncomeBase = baseTotal.totalIncome;
    final double totalExpensesBase = baseTotal.totalExpense;

    // 3. 使用 Calculator 計算
    final double potRemainder =
        BalanceCalculator.calculateRemainderBuffer(recordModels);

    // 統計支出與收入 (用於圖表)
    double potIncome = 0.0;
    double totalExpenses = 0.0;

    final Map<String, double> expenseByCurrency = {};
    final Map<String, double> incomeByCurrency = {};

    for (var r in recordModels) {
      final recCurrency = r.originalCurrencyCode;
      if (r.type == 'income') {
        potIncome += r.originalAmount;
        incomeByCurrency.update(recCurrency, (val) => val + r.originalAmount,
            ifAbsent: () => r.originalAmount);
      } else {
        totalExpenses += r.originalAmount;
        expenseByCurrency.update(recCurrency, (val) => val + r.originalAmount,
            ifAbsent: () => r.originalAmount);
      }
    }

    // Chart Scaling
    final maxVal = (totalExpenses > potIncome) ? totalExpenses : potIncome;
    final scaleBase = maxVal == 0 ? 1.0 : maxVal;
    int getFlex(double val) => (val / scaleBase * 1000).toInt();

    String mapRuleName(String rule) {
      switch (rule) {
        case 'order':
          return t.S13_Task_Dashboard.rule_order;
        case 'member':
          return t.S13_Task_Dashboard.rule_member;
        case 'random':
        default:
          return t.S13_Task_Dashboard.rule_random;
      }
    }

    // Get current rule from taskData
    final balanceRule = taskData?['remainderRule'] ?? 'random';

    void showRulePicker() {
      RemainderRulePickerSheet.show(
        context: context,
        initialRule: balanceRule,
        onSelected: (selectedRule) {
          // Update Firestore
          FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskId)
              .update({'remainderRule': selectedRule});
        },
      );
    }

    void showBalanceDetails() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t.S13_Task_Dashboard.dialog_balance_detail),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.S13_Task_Dashboard.section_expense,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.error)),
              ...expenseByCurrency.entries.map((e) => Text(
                  "${e.key} ${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(e.value, baseCurrencyOption.code)}")),
              const Divider(),
              Text(t.S13_Task_Dashboard.section_income,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.green)),
              ...incomeByCurrency.entries.map((e) => Text(
                  "${e.key} ${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(e.value, baseCurrencyOption.code)}")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.close),
            ),
          ],
        ),
      );
    }

    void showPoolBreakdown() {
      // 過濾掉餘額為 0 的幣別
      final activeBalances = poolBalancesByOriginalCurrency.entries
          .where((e) => e.value.abs() > 0.01)
          .toList();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(t.S13_Task_Dashboard.dialog_balance_detail), // 或 "公款餘額明細"
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeBalances.isEmpty)
                Text(t.S13_Task_Dashboard.empty_records,
                    style: TextStyle(color: Colors.grey)),
              ...activeBalances.map((e) {
                final currency = CurrencyOption.getCurrencyOption(e.key);
                final amount = e.value;
                final isNegative = amount < 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // 可以加國旗或 Icon
                          Text(currency.code,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text(
                        "${currency.symbol} ${CurrencyOption.formatAmount(amount, currency.code)}",
                        style: TextStyle(
                          color: isNegative
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.common.close),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: fixedHeight, // STRICT HEIGHT ENFORCEMENT
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Pad Top: 16
            const SizedBox(height: 16.0),

            // --- Row 1: Header (44.0) ---
            SizedBox(
              height: 44.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: Currency Selector
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(baseCurrencyOption.code,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              )),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down,
                              size: 20, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  ),

                  // Right: Balance
                  InkWell(
                    onTap: showPoolBreakdown, // <--- 綁定事件
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(t.S13_Task_Dashboard.label_balance,
                            style: theme.textTheme.labelSmall),
                        Text.rich(
                          TextSpan(
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'RobotoMono',
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(poolBalanceByBaseCurrency.abs(), baseCurrencyOption.code)}",
                                style: TextStyle(
                                  color: poolBalanceByBaseCurrency > 0
                                      ? theme.colorScheme.tertiary
                                      : poolBalanceByBaseCurrency < 0
                                          ? theme.colorScheme.error
                                          : theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Gap: 8
            const SizedBox(height: 8.0),

            // --- Row 2: Legend (20.0) ---
            InkWell(
              onTap: showPoolBreakdown,
              child: SizedBox(
                height: 20.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${t.S13_Task_Dashboard.label_total_expense} : ${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(totalExpensesBase.abs(), baseCurrencyOption.code)}",
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${t.S13_Task_Dashboard.label_total_prepay} : ${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(totalIncomeBase.abs(), baseCurrencyOption.code)}",
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Gap: 8
            const SizedBox(height: 8.0),

            // --- Row 3: Chart (12.0) ---
            InkWell(
              onTap: showBalanceDetails,
              child: SizedBox(
                height: 12.0,
                child: (totalExpenses == 0 && potIncome == 0)
                    ? Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(t.S13_Task_Dashboard.empty_records,
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.outline,
                                fontSize: 10)),
                      )
                    : Row(
                        children: [
                          // Left Bar (Expenses - Red)
                          Expanded(
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: totalExpenses > 0
                                  ? Row(
                                      children: [
                                        if (getFlex(totalExpenses) > 0)
                                          Flexible(
                                            flex: getFlex(totalExpenses),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: theme
                                                    .colorScheme.errorContainer,
                                                borderRadius: const BorderRadius
                                                    .horizontal(
                                                    left: Radius.circular(6)),
                                              ),
                                            ),
                                          ),
                                        if ((1000 - getFlex(totalExpenses)) > 0)
                                          Spacer(
                                              flex: 1000 -
                                                  getFlex(totalExpenses)),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                          ),

                          Container(width: 2, color: theme.colorScheme.surface),

                          // Right Bar (Pot Income Only - Green)
                          Expanded(
                            child: potIncome > 0
                                ? Row(
                                    children: [
                                      if (getFlex(potIncome) > 0)
                                        Flexible(
                                          flex: getFlex(potIncome),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade400,
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(6)),
                                            ),
                                          ),
                                        ),
                                      if ((1000 - getFlex(potIncome)) > 0)
                                        Spacer(flex: 1000 - getFlex(potIncome)),
                                    ],
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
              ),
            ),

            // Gap: 12
            const SizedBox(height: 12.0),

            // --- Row 4: Footer (40.0) ---
            SizedBox(
              height: 40.0,
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.S13_Task_Dashboard.label_remainder_pot,
                          style: theme.textTheme.bodyMedium),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {},
                        child: Icon(Icons.info_outline,
                            size: 16, color: theme.colorScheme.outline),
                      ),
                      Text(" : ", style: theme.textTheme.bodyMedium),
                      Text(
                        "${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(potRemainder.abs(), baseCurrencyOption.code)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: potRemainder > 0
                              ? Colors.green // 剩餘資金 (正數)
                              : (potRemainder < 0
                                  ? Theme.of(context).colorScheme.error
                                  : Colors.grey), // 💡 套用顏色
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: showRulePicker,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mapRuleName(balanceRule),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pad Bottom: 16
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
