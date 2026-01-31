// _PersonalBalanceCard 保持為 Stateless Widget
// 邏輯: UI 只負責顯示傳進來的 netBalance
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class PersonalBalanceCard extends StatelessWidget {
  final CurrencyOption baseCurrencyOption;
  final double netBalance; // 直接接收計算結果
  final String uid;
  final Map<String, dynamic>? memberData;

  const PersonalBalanceCard({
    super.key,
    required this.baseCurrencyOption,
    required this.netBalance,
    required this.uid,
    required this.memberData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    final isPositive = netBalance >= 0;
    final statusColor = isPositive ? Colors.green : theme.colorScheme.error;
    final displayName = memberData?['displayName'] ?? '';

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CommonAvatar(
              avatarId: memberData?['avatar'],
              name: displayName,
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isPositive
                      ? t.S13_Task_Dashboard.personal_to_receive
                      : t.S13_Task_Dashboard.personal_to_pay,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '${baseCurrencyOption.code}${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(netBalance.abs(), baseCurrencyOption.code)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
