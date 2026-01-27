import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

class DailyHeader extends StatelessWidget {
  final DateTime date;
  final double total;
  final CurrencyOption currency;
  final bool isPersonal;

  const DailyHeader(
      {super.key,
      required this.date,
      required this.total,
      required this.currency,
      this.isPersonal = false});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dateStr = DateFormat('MM/dd (E)').format(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isToday)
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(t.common.today,
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: theme.colorScheme.onPrimary))),
              Text(dateStr,
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          Text(
              isPersonal
                  ? "${t.S13_Task_Dashboard.personal_daily_total}: ${currency.code}${currency.symbol} ${CurrencyOption.formatAmount(total, currency.code)}"
                  : "${t.S13_Task_Dashboard.daily_expense_label}: ${currency.code}${currency.symbol} ${CurrencyOption.formatAmount(total, currency.code)}",
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
