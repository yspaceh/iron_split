import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'dart:ui' as ui;

class GroupBalanceCard extends StatelessWidget {
  // 唯一的資料來源
  final BalanceSummaryState state;

  // 事件回調
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onRuleTap;

  const GroupBalanceCard({
    super.key,
    required this.state,
    this.onCurrencyTap,
    this.onRuleTap,
  });

  /// ! CRITICAL LAYOUT CONFIGURATION !
  /// Used by S13Page to calculate Sticky Header size.
  static const double fixedHeight = 176.0;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    // 透過 State 判斷是否鎖定 (若 onCurrencyTap 為空通常也代表鎖定，雙重確認)
    final bool isLocked = state.isLocked;

    // Dialog 1: 收支明細
    void showBalanceDetails() {
      CommonAlertDialog.show(context,
          title: t.S13_Task_Dashboard.dialog_balance_detail,
          showCancel: false, // 純資訊顯示，不用取消按鈕
          confirmText: t.common.close, // 按鈕改叫「關閉」
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 支出區塊
              Text(t.S13_Task_Dashboard.section_expense,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.error)),
              if (state.expenseDetail.isEmpty)
                Text(t.S13_Task_Dashboard.empty_records,
                    style: const TextStyle(color: Colors.grey)),
              ...state.expenseDetail.entries.map((e) => Text(
                  "${e.key} ${state.currencySymbol} ${CurrencyConstants.formatAmount(e.value, state.currencyCode)}")),

              const Divider(),

              // 收入區塊
              Text(t.S13_Task_Dashboard.section_income,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.green)),
              if (state.incomeDetail.isEmpty)
                Text(t.S13_Task_Dashboard.empty_records,
                    style: const TextStyle(color: Colors.grey)),
              ...state.incomeDetail.entries.map((e) => Text(
                  "${e.key} ${state.currencySymbol} ${CurrencyConstants.formatAmount(e.value, state.currencyCode)}")),
            ],
          ));
    }

    // Dialog 2: 餘額組成
    void showPoolBreakdown() {
      final activeBalances =
          state.poolDetail.entries.where((e) => e.value.abs() > 0.01).toList();
      CommonAlertDialog.show(context,
          title: t.S13_Task_Dashboard.dialog_balance_detail,
          showCancel: false,
          confirmText: t.common.close,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeBalances.isEmpty)
                Text(t.S13_Task_Dashboard.empty_records,
                    style: const TextStyle(color: Colors.grey)),
              ...activeBalances.map((e) {
                final amount = e.value;
                final isNegative = amount < 0;
                // 注意：這裡假設 State 裡的 Key 就是 CurrencyCode
                final currencySymbol =
                    CurrencyConstants.getCurrencyConstants(e.key).symbol;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        "$currencySymbol ${CurrencyConstants.formatAmount(amount, e.key)}",
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
          ));
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: fixedHeight,
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
                    onTap: onCurrencyTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.currencyCode,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              )),
                          Visibility(
                            visible: !isLocked,
                            child: const SizedBox(width: 4),
                          ),
                          Visibility(
                            visible: !isLocked,
                            child: Icon(Icons.keyboard_arrow_down,
                                size: 20, color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right: Balance
                  InkWell(
                    onTap: showPoolBreakdown,
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
                                    "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.poolBalance.abs(), state.currencyCode)}",
                                style: TextStyle(
                                  color: state.poolBalance > 0
                                      ? theme.colorScheme.tertiary
                                      : state.poolBalance < 0
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
                          "${t.S13_Task_Dashboard.label_total_expense} : ${state.currencySymbol} ${CurrencyConstants.formatAmount(state.totalExpense.abs(), state.currencyCode)}",
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
                          "${t.S13_Task_Dashboard.label_total_prepay} : ${state.currencySymbol} ${CurrencyConstants.formatAmount(state.totalIncome.abs(), state.currencyCode)}",
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
                child: (state.expenseFlex == 0 && state.incomeFlex == 0)
                    ? Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      )
                    : Row(
                        children: [
                          // Left Bar (Expenses - Red)
                          Expanded(
                            child: Directionality(
                              textDirection: ui.TextDirection.rtl,
                              child: state.expenseFlex > 0
                                  ? Row(
                                      children: [
                                        Flexible(
                                          flex: state.expenseFlex,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme
                                                  .colorScheme.errorContainer,
                                              borderRadius:
                                                  const BorderRadius.horizontal(
                                                      left: Radius.circular(6)),
                                            ),
                                          ),
                                        ),
                                        if ((1000 - state.expenseFlex) > 0)
                                          Spacer(
                                              flex: 1000 - state.expenseFlex),
                                      ],
                                    )
                                  : const SizedBox(),
                            ),
                          ),

                          Container(width: 2, color: theme.colorScheme.surface),

                          // Right Bar (Pot Income Only - Green)
                          Expanded(
                            child: state.incomeFlex > 0
                                ? Row(
                                    children: [
                                      Flexible(
                                        flex: state.incomeFlex,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade400,
                                            borderRadius:
                                                const BorderRadius.horizontal(
                                                    right: Radius.circular(6)),
                                          ),
                                        ),
                                      ),
                                      if ((1000 - state.incomeFlex) > 0)
                                        Spacer(flex: 1000 - state.incomeFlex),
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
                        "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.remainder.abs(), state.currencyCode)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: state.remainder > 0
                              ? Colors.green
                              : (state.remainder < 0
                                  ? theme.colorScheme.error
                                  : Colors.grey),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onRuleTap,
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
                            RemainderRuleConstants.getLabel(
                                context, state.ruleKey),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: !isLocked,
                            child: const SizedBox(width: 4),
                          ),
                          Visibility(
                            visible: !isLocked,
                            child: Icon(Icons.keyboard_arrow_down,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // S17 Locked View Specific (Absorbed By)
            Visibility(
              visible: state.isLocked && state.absorbedBy != null,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8.0), // slightly adjusted for flow
                child: Text(
                  // 使用 S17 的 i18n
                  t.S17_Task_Locked.label_remainder_absorbed_by(
                    amount:
                        "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.absorbedAmount ?? 0, state.currencyCode)}",
                    name: state.absorbedBy ?? "",
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ),

            // Pad Bottom: 16 (preserved)
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
