import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskCurrencyInput extends StatelessWidget {
  const TaskCurrencyInput({
    super.key,
    required this.currency,
    required this.onCurrencyChanged,
    this.enabled = true,
  });

  final CurrencyOption currency;
  final ValueChanged<CurrencyOption> onCurrencyChanged;
  final bool enabled;

  void _showCurrencyPicker(BuildContext context) {
    CurrencyPickerSheet.show(
      context: context,
      initialCode: currency.code,
      onSelected: (currency) {
        onCurrencyChanged(currency);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildRowItem(
      context: context,
      icon: Icons.currency_exchange,
      label: t.S16_TaskCreate_Edit.field_currency,
      value: currency.code,
      onTap: enabled ? () => _showCurrencyPicker(context) : null,
      enabled: enabled,
    );
  }

  Widget _buildRowItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
    required bool enabled,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                size: 20, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
