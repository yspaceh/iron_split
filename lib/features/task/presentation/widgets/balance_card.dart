import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class BalanceCard extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic>? taskData;
  final Map<String, dynamic>? memberData;
  final List<QueryDocumentSnapshot> records;

  const BalanceCard({
    super.key,
    required this.taskId,
    required this.taskData,
    required this.memberData,
    required this.records,
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
    final currency = taskData!['baseCurrency'] ?? 'TWD';
    final balanceRule = taskData!['balanceRule'] ?? 'random';

    // 2. Calculation Logic
    double totalExpenses = 0.0;
    double potIncome = 0.0;
    double potRemainder = 0.0;

    // Grouping for Dialog
    final Map<String, double> expenseByCurrency = {};
    final Map<String, double> incomeByCurrency = {};

    for (var doc in records) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      final type = data['type'] as String?;
      final recCurrency = data['currency'] as String? ?? currency;

      // A. Pot Remainder
      double allocated = 0.0;
      if (data.containsKey('splitDetails')) {
        final splits = data['splitDetails'] as Map<String, dynamic>;
        splits.forEach((_, val) => allocated += (val as num).toDouble());
      }
      potRemainder += (amount - allocated);

      // B. Fund & Expense
      if (type == 'income') {
        potIncome += amount;
        incomeByCurrency.update(recCurrency, (val) => val + amount,
            ifAbsent: () => amount);
      } else {
        totalExpenses += amount;
        expenseByCurrency.update(recCurrency, (val) => val + amount,
            ifAbsent: () => amount);
      }
    }

    final netBalance = potIncome - totalExpenses;

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

    void _showRulePicker() {
      showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 250,
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(t.common.confirm),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 32,
                  onSelectedItemChanged: (int index) {
                    final newRule = ['random', 'order', 'member'][index];
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(taskId)
                        .update({'balanceRule': newRule});
                  },
                  children: [
                    Text(t.S13_Task_Dashboard.rule_random),
                    Text(t.S13_Task_Dashboard.rule_order),
                    Text(t.S13_Task_Dashboard.rule_member),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    void _showBalanceDetails() {
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
              ...expenseByCurrency.entries.map(
                  (e) => Text("${e.key} \$ ${e.value.toStringAsFixed(1)}")),
              const Divider(),
              Text(t.S13_Task_Dashboard.section_income,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.green)),
              ...incomeByCurrency.entries.map(
                  (e) => Text("${e.key} \$ ${e.value.toStringAsFixed(1)}")),
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
                          Text(currency,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.S13_Task_Dashboard.label_balance,
                          style: theme.textTheme.labelSmall),
                      Text(
                        '${netBalance >= 0 ? "+" : ""}${netBalance.toStringAsFixed(0)}',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: netBalance >= 0
                              ? Colors.green
                              : theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Gap: 8
            const SizedBox(height: 8.0),

            // --- Row 2: Legend (20.0) ---
            SizedBox(
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
                        "${t.S13_Task_Dashboard.label_total_expense} : \$ ${totalExpenses.toStringAsFixed(0)}",
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
                        "${t.S13_Task_Dashboard.label_total_prepay} : \$ ${potIncome.toStringAsFixed(0)}",
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Gap: 8
            const SizedBox(height: 8.0),

            // --- Row 3: Chart (12.0) ---
            InkWell(
              onTap: _showBalanceDetails,
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
                              textDirection: TextDirection.rtl,
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
                      const SizedBox(width: 4),
                      Text(" : ", style: theme.textTheme.bodyMedium),
                      Text(
                        potRemainder.toStringAsFixed(2),
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: _showRulePicker,
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
