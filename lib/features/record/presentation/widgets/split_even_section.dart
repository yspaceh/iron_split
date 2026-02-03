// lib/features/record/presentation/widgets/split_even_section.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/commonSelectionTile.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/gen/strings.g.dart';

class SplitEvenSection extends StatelessWidget {
  final List<Map<String, dynamic>> allMembers;
  final List<String> selectedMemberIds;
  final SplitResult splitResult;
  final CurrencyConstants selectedCurrency;
  final CurrencyConstants baseCurrency;
  final double exchangeRate;
  final Function(String id, bool isSelected) onMemberToggle;

  const SplitEvenSection({
    super.key,
    required this.allMembers,
    required this.selectedMemberIds,
    required this.splitResult,
    required this.selectedCurrency,
    required this.baseCurrency,
    required this.exchangeRate,
    required this.onMemberToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. 說明文字
        Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 4),
          child: Text(t.B03_SplitMethod_Edit.desc_even,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ),

        // 2. 成員選取列表 (現代化風格)
        ...allMembers.map((m) {
          final id = m['id'];
          final isSelected = selectedMemberIds.contains(id);
          final amount = splitResult.sourceAmounts[id] ?? 0.0;
          final baseAmount = splitResult.baseAmounts[id] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CommonSelectionTile(
              isSelected: isSelected,
              onTap: () => onMemberToggle(id, isSelected),
              leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false,
                radius: 18,
              ),
              title: m['displayName'],
              trailing: isSelected
                  ? _buildAmountTrailing(theme, amount, baseAmount)
                  : null,
            ),
          );
        }),

        // 3. 餘額提示 (Remainder Bar)
        if (splitResult.remainder > 0)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: InfoBar(
              icon: Icons.savings_outlined,
              text: Text(
                t.S15_Record_Edit.msg_leftover_pot(
                    amount:
                        "${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(splitResult.remainder, baseCurrency.code)}"),
                style: TextStyle(
                    fontSize: 12, color: theme.colorScheme.onTertiaryContainer),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAmountTrailing(
      ThemeData theme, double amount, double baseAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, selectedCurrency.code)}",
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (exchangeRate != 1.0)
          Text(
            "≈ ${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
            style: theme.textTheme.labelSmall
                ?.copyWith(color: Colors.grey, fontSize: 10),
          ),
      ],
    );
  }
}
