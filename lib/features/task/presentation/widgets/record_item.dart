import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

class RecordItem extends StatelessWidget {
  final RecordModel record;
  final double displayAmount;
  final CurrencyConstants baseCurrency;
  final VoidCallback? onTap;
  final Future<void> Function(BuildContext context)? onDelete;

  const RecordItem({
    super.key,
    required this.record,
    required this.displayAmount,
    required this.baseCurrency,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isIncome = record.type == 'income';
    final originalCurrencyConstants = CurrencyConstants.getCurrencyConstants(
        record.currencyCode); // 注意這裡用 currencyCode
    final exchangeRate = record.exchangeRate;

    // UI 顯示邏輯 (Icon, Color, Title) 可以保留在 View 層
    final category = CategoryConstant.getCategoryById(record.categoryId);
    final title =
        (record.title.isNotEmpty) ? record.title : category.getName(t);
    final icon = isIncome ? Icons.savings_outlined : category.icon;

    final color =
        isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error;
    final bgColor = isIncome
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.errorContainer;
    final iconColor = isIncome
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.primary;

    final amountText =
        "${originalCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(displayAmount, originalCurrencyConstants.code)}";
    return Dismissible(
      key: Key(record.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (onDelete == null) return false;

        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (context) => D10RecordDeleteConfirmDialog(
            title: title,
            amount: amountText,
            onConfirm: () {
              confirmed = true;
            },
          ),
        );
        return confirmed;
      },
      onDismissed: (direction) {
        if (onDelete != null) {
          onDelete!(context);
        }
      },
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: bgColor,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amountText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (originalCurrencyConstants != baseCurrency)
              Text(
                "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(displayAmount * exchangeRate, baseCurrency.code)}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
