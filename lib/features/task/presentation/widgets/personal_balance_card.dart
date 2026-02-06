// _PersonalBalanceCard 保持為 Stateless Widget
// 邏輯: UI 只負責顯示傳進來的 netBalance
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';

class PersonalBalanceCard extends StatelessWidget {
  final CurrencyConstants baseCurrency;
  final DualAmount netBalance; // 直接接收計算結果
  final DualAmount totalExpense; // 個人總支出
  final DualAmount totalIncome; // 個人總預收
  final String uid;
  final Map<String, dynamic>? memberData;
  final double? fixedHeight;

  const PersonalBalanceCard({
    super.key,
    required this.baseCurrency,
    required this.netBalance,
    required this.uid,
    required this.memberData,
    this.fixedHeight,
    required this.totalExpense,
    required this.totalIncome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    final isPositive = netBalance.base >= 0;
    // 支出使用主色 (Iron Wine)
    final Color expenseColor = theme.colorScheme.primary;
    // 收入使用第三色 (我們在 AppTheme 定義為 Forest Green)
    final Color incomeColor = theme.colorScheme.tertiary;
    final Color neutralColor = theme.colorScheme.outline;
    // Footer 背景色 (使用極淡的表面色變體)
    final Color footerBgColor =
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    // 邊框色
    final Color borderColor =
        theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final displayName = memberData?['displayName'] ??
        t.S53_TaskSettings_Members.member_default_name;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        height: fixedHeight,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonAvatar(
                      avatarId: memberData?['avatar'],
                      name: displayName,
                      radius: 48,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayName,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: double.infinity,
              thickness: 1, // 線條厚度
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          baseCurrency.code,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isPositive
                              ? t.S13_Task_Dashboard.personal_to_receive
                              : t.S13_Task_Dashboard.personal_to_pay,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: baseCurrency.symbol,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  // 使用變數判斷顏色
                                  color: netBalance.base < 0
                                      ? expenseColor
                                      : (netBalance.base > 0
                                          ? incomeColor
                                          : neutralColor),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: " "),
                              TextSpan(
                                text: CurrencyConstants.formatAmount(
                                    netBalance.base.abs(), baseCurrency.code),
                                style: TextStyle(
                                  fontSize: 36,
                                  fontFamily: 'RobotoMono',
                                  fontWeight: FontWeight.w700,
                                  // 使用變數判斷顏色
                                  color: netBalance.base < 0
                                      ? expenseColor
                                      : (netBalance.base > 0
                                          ? incomeColor
                                          : neutralColor),
                                  letterSpacing: -1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${t.S13_Task_Dashboard.label_total_expense} ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "${baseCurrency.symbol}${CurrencyConstants.formatAmount(totalExpense.base.abs(), baseCurrency.code)}",
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
                              "${t.S13_Task_Dashboard.label_total_prepay} ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "${baseCurrency.symbol}${CurrencyConstants.formatAmount(totalIncome.base.abs(), baseCurrency.code)}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Row(
                  //   children: [
                  //     const SizedBox(width: 16),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Text(
                  //             displayName,
                  //             style: theme.textTheme.titleMedium
                  //                 ?.copyWith(fontWeight: FontWeight.bold),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
