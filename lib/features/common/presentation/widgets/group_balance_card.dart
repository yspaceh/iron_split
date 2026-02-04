import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'dart:ui' as ui;

class GroupBalanceCard extends StatelessWidget {
  // 唯一的資料來源
  final BalanceSummaryState state;
  // 事件回調
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onRuleTap;
  final double? fixedHeight;

  const GroupBalanceCard({
    super.key,
    required this.state,
    this.onCurrencyTap,
    this.onRuleTap,
    this.fixedHeight,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 透過 State 判斷是否鎖定 (若 onCurrencyTap 為空通常也代表鎖定，雙重確認)
    final bool isCurrencyTapLocked = onCurrencyTap == null;
    final bool isRuleTapLocked = onRuleTap == null;
    final double netBalance = state.totalIncome - state.totalExpense;

    String _getAmountWithSymbol(double amount, String currencyCode) {
      final currencyConstants =
          CurrencyConstants.getCurrencyConstants(currencyCode);
      return "${currencyConstants.symbol} ${CurrencyConstants.formatAmount(amount, currencyCode)}";
    }

    // Dialog 1: 收支明細
    // Dialog: 收支明細
    void showBalanceDetails() {
      CommonAlertDialog.show(context,
          title: t.S13_Task_Dashboard.dialog_balance_detail,
          actions: [
            AppButton(
              text: t.common.buttons.close,
              type: AppButtonType.primary,
              onPressed: () => context.pop(),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 支出區塊
              Text(t.S13_Task_Dashboard.section_expense,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: theme.colorScheme.error)),
              ...state.expenseDetail.entries.map(
                (e) => Text(
                  "${e.key} ${_getAmountWithSymbol(state.expenseDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                  style: TextStyle(fontFamily: 'RobotoMono'),
                ),
              ),

              const Divider(),

              // 收入區塊
              Text(t.S13_Task_Dashboard.section_income,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.green)),
              ...state.incomeDetail.entries.map(
                (e) => Text(
                  "${e.key} ${_getAmountWithSymbol(state.incomeDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                  style: TextStyle(fontFamily: 'RobotoMono'),
                ),
              ),

              const Divider(),

              // 預收款餘額 (庫存)
              Text(t.S13_Task_Dashboard.label_prepay_balance, // 使用 "餘額" 或類似的標題
                  style: theme.textTheme.titleSmall),
              ...state.poolDetail.entries.map(
                (e) => Text(
                  "${e.key} ${_getAmountWithSymbol(state.poolDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),

              // return Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 4),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(e.key,
              //           style: const TextStyle(fontWeight: FontWeight.bold)),
              //       Text(
              //         "$currencySymbol ${CurrencyConstants.formatAmount(amount, e.key)}",
              //         style: TextStyle(
              //           color: isNegative
              //               ? theme.colorScheme.error
              //               : theme.colorScheme.primary,
              //           fontWeight: FontWeight.bold,
              //           fontFamily: 'RobotoMono',
              //         ),
              //       ),
              //     ],
              //   ),
              // );
            ],
          ));
    }

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: showBalanceDetails,
        child: Container(
          height: fixedHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                // --- Row 1: Header (44.0) ---
                SizedBox(
                  height: 44.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Currency Selector
                      InkWell(
                        onTap: !isCurrencyTapLocked ? onCurrencyTap : null,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(state.currencyCode,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              )),
                        ),
                      ),

                      // Right: Balance
                      Column(
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
                                      "${netBalance < 0 ? "-" : ""} ${state.currencySymbol} ${CurrencyConstants.formatAmount(netBalance.abs(), state.currencyCode)}",
                                  style: TextStyle(
                                    color: netBalance > 0
                                        ? theme.colorScheme.tertiary
                                        : netBalance < 0
                                            ? theme.colorScheme.error
                                            : theme.colorScheme.outline,
                                  ),
                                ),
                              ],
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

                // Gap: 8
                const SizedBox(height: 4.0),

                // --- Row 3: Chart (12.0) ---
                InkWell(
                  onTap: showBalanceDetails,
                  child: SizedBox(
                    height: 20.0,
                    child: (state.expenseFlex == 0 && state.incomeFlex == 0)
                        ? Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(10),
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
                                                  color: theme.colorScheme
                                                      .errorContainer,
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                          left: Radius.circular(
                                                              10)),
                                                ),
                                              ),
                                            ),
                                            if ((1000 - state.expenseFlex) > 0)
                                              Spacer(
                                                  flex:
                                                      1000 - state.expenseFlex),
                                          ],
                                        )
                                      : const SizedBox(),
                                ),
                              ),

                              Container(
                                  width: 2, color: theme.colorScheme.surface),

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
                                                borderRadius: const BorderRadius
                                                    .horizontal(
                                                    right: Radius.circular(10)),
                                              ),
                                            ),
                                          ),
                                          if ((1000 - state.incomeFlex) > 0)
                                            Spacer(
                                                flex: 1000 - state.incomeFlex),
                                        ],
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                  ),
                ),

                // Gap: 12
                const SizedBox(height: 8.0),

                // --- Row 4: Footer (40.0) ---
                SizedBox(
                  height: 40.0,
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: isCurrencyTapLocked && isRuleTapLocked
                            ? null
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        t.S15_Record_Edit.msg_leftover_pot(
                                            amount:
                                                "${state.currencyCode}${state.currencySymbol} ${CurrencyConstants.formatAmount(state.remainder, state.currencyCode)}")),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.savings_outlined,
                                  size: 20, color: theme.colorScheme.secondary),
                              Text(" : ", style: theme.textTheme.bodyMedium),
                              Text(
                                "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.remainder, state.currencyCode)}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (state.isLocked &&
                                  state.absorbedBy != null) ...[
                                Text(
                                  t.S17_Task_Locked.label_remainder_absorbed_by(
                                    name: state.absorbedBy ?? "",
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
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
                              if (!isRuleTapLocked) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: theme.colorScheme.onSurfaceVariant),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
