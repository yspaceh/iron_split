import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskAmountInput extends StatelessWidget {
  const TaskAmountInput({
    super.key,
    required this.onCurrencyTap,
    required this.amountController,
    required this.selectedCurrencyOption,
  });

  final VoidCallback onCurrencyTap;
  final TextEditingController amountController;
  final CurrencyOption selectedCurrencyOption;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onCurrencyTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 50,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedCurrencyOption.symbol,
                  style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary, fontWeight: FontWeight.w900),
                ),
                Text(
                  selectedCurrencyOption.code,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: t.S15_Record_Edit.label_amount,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            validator: (v) =>
                (double.tryParse(v ?? '') ?? 0) <= 0 ? "Invalid" : null,
          ),
        ),
      ],
    );
  }
}
