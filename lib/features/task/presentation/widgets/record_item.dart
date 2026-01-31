import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/services/record_service.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

class RecordItem extends StatelessWidget {
  final String taskId;
  final RecordModel record;
  final Map<String, double> poolBalancesByCurrency;
  final CurrencyOption baseCurrencyOption;
  final String? uid; // 個人用

  const RecordItem({
    super.key,
    required this.taskId,
    required this.record,
    required this.poolBalancesByCurrency,
    required this.baseCurrencyOption,
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isIncome = record.type == 'income';
    final originalAmount = uid != null
        ? isIncome
            ? BalanceCalculator.calculatePersonalCredit(record, uid ?? '',
                isBaseCurrency: false)
            : BalanceCalculator.calculatePersonalDebit(record, uid ?? '',
                isBaseCurrency: false)
        : record.originalAmount;

    final originalCurrencyOption =
        CurrencyOption.getCurrencyOption(record.originalCurrencyCode);

    final exchangeRate = record.exchangeRate;
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
        : theme.colorScheme.onError;

    final amountText =
        "${originalCurrencyOption.symbol} ${CurrencyOption.formatAmount(originalAmount, originalCurrencyOption.code)}";

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
        RecordService.deleteRecord(taskId, record.id ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.D10_RecordDelete_Confirm.deleted_success)),
        );
      },
      child: ListTile(
        onTap: () => context.pushNamed(
          'S15',
          pathParameters: {'taskId': taskId},
          queryParameters: {'id': record.id},
          extra: {
            'poolBalancesByCurrency': poolBalancesByCurrency,
            'baseCurrencyOption': baseCurrencyOption,
            'record': record,
          },
        ),
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
            if (originalCurrencyOption != baseCurrencyOption)
              Text(
                "≈ ${baseCurrencyOption.code}${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(originalAmount * exchangeRate, baseCurrencyOption.code)}",
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
