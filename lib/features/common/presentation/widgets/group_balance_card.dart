import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';

class GroupBalanceCard extends StatelessWidget {
  // 唯一的資料來源
  final BalanceSummaryState state;
  // 事件回調
  final VoidCallback? onCurrencyTap;
  final VoidCallback? onRuleTap;
  final double? fixedHeight;
  final bool? isSettlement;

  const GroupBalanceCard({
    super.key,
    required this.state,
    this.onCurrencyTap,
    this.onRuleTap,
    this.fixedHeight,
    this.isSettlement = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    // 透過 State 判斷是否鎖定 (若 onCurrencyTap 為空通常也代表鎖定，雙重確認)
    final bool isCurrencyTapLocked = onCurrencyTap == null;
    final bool isRuleTapLocked = onRuleTap == null;
    final double netBalance = state.totalIncome - state.totalExpense;
    // --- 1. 統一管理顏色變數 (從 Theme 取得) ---
    // 支出使用主色 (Iron Wine)
    final Color expenseColor = theme.colorScheme.primary;
    // 收入使用第三色 (我們在 AppTheme 定義為 Forest Green)
    final Color incomeColor = theme.colorScheme.tertiary;
    // 中性色/零值
    final Color neutralColor = theme.colorScheme.outline;
    // Footer 背景色 (使用極淡的表面色變體)
    final Color footerBgColor =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    // 邊框色
    final Color borderColor =
        theme.colorScheme.outlineVariant.withValues(alpha: 0.5);

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
              Text(t.S13_Task_Dashboard.section.expense,
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
              Text(t.S13_Task_Dashboard.section.income,
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
              Text(
                  t.S13_Task_Dashboard.section.prepay_balance, // 使用 "餘額" 或類似的標題
                  style: theme.textTheme.titleSmall),
              ...state.poolDetail.entries.map(
                (e) => Text(
                  "${e.key} ${_getAmountWithSymbol(state.poolDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ),
            ],
          ));
    }

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white, // [修改] 統一使用純白
        borderRadius: BorderRadius.circular(20), // 大卡片維持 20 的圓角，比較大氣
        // [修改] 加入與 MemberItem 一致的極淡陰影
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: showBalanceDetails,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: fixedHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Top Content ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    children: [
                      // (A) Header: Currency Chip
                      Row(
                        children: [
                          const Spacer(),
                          InkWell(
                            onTap: isCurrencyTapLocked ? null : onCurrencyTap,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: footerBgColor, // 使用變數
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: borderColor, // 使用變數
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.currencyCode,
                                    style:
                                        theme.textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  if (!isCurrencyTapLocked) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: 14,
                                        color: theme.colorScheme.onSurface),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // (B) Core: Big Number (Net Balance)
                      Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: state.currencySymbol,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  // 使用變數判斷顏色
                                  color: netBalance < 0
                                      ? expenseColor
                                      : (netBalance > 0
                                          ? incomeColor
                                          : neutralColor),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: " "),
                              TextSpan(
                                text: CurrencyConstants.formatAmount(
                                    netBalance.abs(), state.currencyCode),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontFamily: 'RobotoMono',
                                  fontWeight: FontWeight.w700,
                                  // 使用變數判斷顏色
                                  color: netBalance < 0
                                      ? expenseColor
                                      : (netBalance > 0
                                          ? incomeColor
                                          : neutralColor),
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${t.S13_Task_Dashboard.label.total_expense} ",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            "${state.currencySymbol}${CurrencyConstants.formatAmount(state.totalExpense.abs(), state.currencyCode)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "|",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${t.S13_Task_Dashboard.label.total_prepay} ",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            "${state.currencySymbol}${CurrencyConstants.formatAmount(state.totalIncome.abs(), state.currencyCode)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (fixedHeight != null)
                  const Spacer()
                else
                  const SizedBox(height: 16),

                // --- Bottom Footer ---
                InkWell(
                  onTap: onRuleTap,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface, // 使用變數
                      border: Border(
                        top: BorderSide(
                          color: borderColor, // 使用變數
                          width: 1,
                        ),
                      ),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.savings_outlined,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.remainder, state.currencyCode)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFamily: 'RobotoMono',
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (isSettlement == false && state.remainder != 0) ...[
                          if (state.isLocked && state.absorbedBy != null)
                            Text(
                              t.S17_Task_Locked.label_remainder_absorbed_by(
                                  name: state.absorbedBy ?? ""),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              RemainderRuleConstants.getLabel(
                                  context, state.ruleKey),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          if (!isRuleTapLocked) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant),
                          ],
                        ],
                      ],
                    ),
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
