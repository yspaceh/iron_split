import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class RemainderBar extends StatelessWidget {
  final CurrencyConstants baseCurrency;
  final double baseRemainder;
  const RemainderBar({
    super.key,
    required this.baseCurrency,
    required this.baseRemainder,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.savings,
              color: theme.colorScheme.onTertiaryContainer, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.S15_Record_Edit.msg_leftover_pot(
                  amount:
                      "${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseRemainder, baseCurrency.code)}"),
              style: TextStyle(
                  fontSize: 12, color: theme.colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
