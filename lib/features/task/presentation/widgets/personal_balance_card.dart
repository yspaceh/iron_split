// _PersonalBalanceCard 保持為 Stateless Widget
// 邏輯: UI 只負責顯示傳進來的 netBalance
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class PersonalBalanceCard extends StatelessWidget {
  final CurrencyConstants baseCurrency;
  final DualAmount netBalance; // 直接接收計算結果
  final DualAmount totalExpense; // 個人總支出
  final DualAmount totalPrepay; // 個人總預收
  final String uid;
  final TaskMember? memberData;
  final double? fixedHeight;

  const PersonalBalanceCard({
    super.key,
    required this.baseCurrency,
    required this.netBalance,
    required this.uid,
    required this.memberData,
    this.fixedHeight,
    required this.totalExpense,
    required this.totalPrepay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final t = Translations.of(context);

    final isPositive = netBalance.base >= 0;
    // 支出使用主色 (Iron Wine)
    final Color expenseColor = colorScheme.primary;
    // 收入使用第三色 (我們在 AppTheme 定義為 Forest Green)
    final Color prepayColor = colorScheme.tertiary;
    final Color neutralColor = colorScheme.outline;
    // Footer 背景色 (使用極淡的表面色變體)
    final Color footerBgColor =
        colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    // 邊框色
    final Color borderColor = colorScheme.outlineVariant.withValues(alpha: 0.5);
    final displayName = memberData?.displayName ??
        t.S53_TaskSettings_Members.member_default_name;

    final avatarSection = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppLayout.spaceM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonAvatar(
              avatarId: memberData?.avatar,
              name: displayName,
              radius: 48,
            ),
            const SizedBox(height: AppLayout.spaceXS),
            Text(
              displayName,
              style:
                  textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
          ],
        ),
      ),
    );

    final balanceSection = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.spaceS, vertical: AppLayout.spaceXS),
          decoration: BoxDecoration(
            color: footerBgColor, // 使用變數
            borderRadius: BorderRadius.circular(AppLayout.radiusL),
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
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppLayout.spaceM),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              isPositive
                  ? t.common.payment_status.refund
                  : t.common.payment_status.payable,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: baseCurrency.symbol,
                      style: textTheme.titleLarge?.copyWith(
                        // 使用變數判斷顏色
                        color: netBalance.base < 0
                            ? expenseColor
                            : (netBalance.base > 0
                                ? prepayColor
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
                                ? prepayColor
                                : neutralColor),
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppLayout.spaceXS),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${t.S13_Task_Dashboard.label.total_expense} ",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "${baseCurrency.symbol}${CurrencyConstants.formatAmount(totalExpense.base.abs(), baseCurrency.code)}",
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${t.S13_Task_Dashboard.label.total_prepay} ",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  "${baseCurrency.symbol}${CurrencyConstants.formatAmount(totalPrepay.base.abs(), baseCurrency.code)}",
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.surface, // [修改] 純白
        borderRadius: BorderRadius.circular(AppLayout.radiusXL),
        // [修改] 統一陰影
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
        child: Container(
          height: fixedHeight,
          padding: const EdgeInsets.all(AppLayout.spaceL),
          child: IntrinsicHeight(
            child: fixedHeight == null
                ? Column(
                    children: [
                      avatarSection,
                      const SizedBox(height: AppLayout.spaceL),
                      Divider(
                        thickness: 1,
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: AppLayout.spaceL),
                      balanceSection,
                    ],
                  )
                : Row(
                    children: [
                      avatarSection,
                      VerticalDivider(
                        thickness: 1,
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                      Expanded(child: balanceSection),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
