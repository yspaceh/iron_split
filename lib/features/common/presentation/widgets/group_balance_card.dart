import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
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
  final bool isEnlarged;

  const GroupBalanceCard({
    super.key,
    required this.state,
    this.onCurrencyTap,
    this.onRuleTap,
    this.fixedHeight,
    this.isSettlement = false,
    required this.isEnlarged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    // 透過 State 判斷是否鎖定 (若 onCurrencyTap 為空通常也代表鎖定，雙重確認)
    final bool isCurrencyTapLocked = onCurrencyTap == null;
    final bool isRuleTapLocked = onRuleTap == null;
    final CurrencyConstants currencyConstants =
        CurrencyConstants.getCurrencyConstants(state.currencyCode);
    final totalPrepay = BalanceCalculator.roundToPrecision(
        state.totalPrepay, currencyConstants);
    final totalExpense = BalanceCalculator.roundToPrecision(
        state.totalExpense, currencyConstants);
    final double netBalance = totalPrepay - totalExpense;
    // --- 1. 統一管理顏色變數 (從 Theme 取得) ---
    // 支出使用主色 (Iron Wine)
    final Color expenseColor = colorScheme.primary;
    // 收入使用第三色 (我們在 AppTheme 定義為 Forest Green)
    final Color prepayColor = colorScheme.tertiary;
    // 中性色/零值
    final Color neutralColor = colorScheme.outline;
    // Footer 背景色 (使用極淡的表面色變體)
    final Color footerBgColor =
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    // 邊框色
    final Color borderColor = colorScheme.outlineVariant.withValues(alpha: 0.5);

    String getAmountWithSymbol(double amount, String currencyCode) {
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
                  style: textTheme.titleSmall?.copyWith(color: expenseColor)),
              if (state.expenseDetail.entries.isEmpty) ...[
                Text(
                  t.S13_Task_Dashboard.section.no_data,
                  style:
                      textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                ),
              ] else ...[
                ...state.expenseDetail.entries.map(
                  (e) => Text(
                    "${e.key} ${getAmountWithSymbol(state.expenseDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                    style:
                        textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                  ),
                ),
              ],

              const Divider(),

              // 收入區塊
              Text(t.S13_Task_Dashboard.section.prepay,
                  style: textTheme.titleSmall?.copyWith(color: prepayColor)),
              if (state.prepayDetail.entries.isEmpty) ...[
                Text(
                  t.S13_Task_Dashboard.section.no_data,
                  style:
                      textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                ),
              ] else ...[
                ...state.prepayDetail.entries.map(
                  (e) => Text(
                    "${e.key} ${getAmountWithSymbol(state.prepayDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                    style:
                        textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                  ),
                ),
              ],
              const Divider(),

              // 預收款餘額 (庫存)
              Text(
                  t.S13_Task_Dashboard.section.prepay_balance, // 使用 "餘額" 或類似的標題
                  style: textTheme.titleSmall),
              if (state.poolDetail.entries.isEmpty) ...[
                Text(
                  t.S13_Task_Dashboard.section.no_data,
                  style:
                      textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                ),
              ] else ...[
                ...state.poolDetail.entries.map(
                  (e) => Text(
                    "${e.key} ${getAmountWithSymbol(state.poolDetail.isEmpty ? 0 : e.value.abs(), e.key)}",
                    style:
                        textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                  ),
                ),
              ],
            ],
          ));
    }

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusXL),
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
        borderRadius: BorderRadius.circular(AppLayout.radiusXL),
        child: InkWell(
          onTap: showBalanceDetails,
          borderRadius: BorderRadius.circular(AppLayout.radiusXL),
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
                            customBorder: const StadiumBorder(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: ShapeDecoration(
                                color: footerBgColor,
                                shape: StadiumBorder(
                                  side: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.currencyCode,
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  if (!isCurrencyTapLocked) ...[
                                    const SizedBox(width: AppLayout.spaceXS),
                                    Icon(Icons.keyboard_arrow_down,
                                        size: iconSize,
                                        color: colorScheme.onSurface),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // (B) Core: Big Number (Net Balance)
                      Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: state.currencySymbol,
                                  style: textTheme.titleLarge?.copyWith(
                                    // 使用變數判斷顏色
                                    color: netBalance < 0
                                        ? expenseColor
                                        : (netBalance > 0
                                            ? prepayColor
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
                                    height: 1,
                                    fontFamily: 'RobotoMono',
                                    fontWeight: FontWeight.w700,
                                    // 使用變數判斷顏色
                                    color: netBalance < 0
                                        ? expenseColor
                                        : (netBalance > 0
                                            ? prepayColor
                                            : neutralColor),
                                    letterSpacing: -1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppLayout.spaceS),
                      if (isEnlarged) ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${t.S13_Task_Dashboard.label.total_expense} ",
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                "${state.currencySymbol}${CurrencyConstants.formatAmount(totalExpense.abs(), state.currencyCode)}",
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ]),
                        const SizedBox(height: AppLayout.spaceS),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${t.S13_Task_Dashboard.label.total_prepay} ",
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                "${state.currencySymbol}${CurrencyConstants.formatAmount(totalPrepay.abs(), state.currencyCode)}",
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${t.S13_Task_Dashboard.label.total_expense} ",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "${state.currencySymbol}${CurrencyConstants.formatAmount(totalExpense.abs(), state.currencyCode)}",
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "|",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${t.S13_Task_Dashboard.label.total_prepay} ",
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "${state.currencySymbol}${CurrencyConstants.formatAmount(totalPrepay.abs(), state.currencyCode)}",
                              style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                if (fixedHeight != null)
                  const Spacer()
                else
                  const SizedBox(height: AppLayout.spaceL),

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
                      color: colorScheme.surface, // 使用變數
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
                            size: iconSize,
                            color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                        Text(
                          "${state.currencySymbol} ${CurrencyConstants.formatAmount(state.remainder, state.currencyCode)}",
                          style: textTheme.bodySmall?.copyWith(
                            fontFamily: 'RobotoMono',
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (state.remainder.abs() > 0.001) ...[
                          if (state.isLocked && state.absorbedBy != null)
                            Text(
                              t.S17_Task_Locked.remainder_absorbed_by(
                                  name: state.absorbedBy ?? ""),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              RemainderRuleConstants.getLabel(
                                  context, state.ruleKey),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          if (!isRuleTapLocked) ...[
                            const SizedBox(width: AppLayout.spaceXS),
                            Icon(Icons.keyboard_arrow_right_outlined,
                                size: iconSize,
                                color: colorScheme.onSurfaceVariant),
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
