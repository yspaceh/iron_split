import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';

class SummaryRow extends StatelessWidget {
  final String label;
  final double amount;
  final CurrencyConstants currencyConstants;
  final Color? labelColor;
  final Color? valueColor;
  final bool hideAmount;
  final String? customValueText;

  const SummaryRow({
    super.key,
    required this.label,
    required this.amount,
    required this.currencyConstants,
    this.valueColor,
    this.hideAmount = false,
    this.customValueText,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: labelColor ?? colorScheme.onSurface,
            ),
          ),
          Text(
            customValueText ??
                CurrencyConstants.formatAmount(amount, currencyConstants.code),
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? colorScheme.onSurface,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
