import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';

class DailyHeader extends StatelessWidget {
  final DateTime date;
  final VoidCallback? onAddTap;
  final bool? isEmpty;

  const DailyHeader(
      {super.key, required this.date, this.onAddTap, this.isEmpty});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dateStr = DateFormat('MM/dd').format(date);
    final weekStr = DateFormat('E').format(date).toUpperCase();

    return Column(
      children: [
        Divider(
          height: 1, // 佔用高度極小
          thickness: 1, // 線條厚度
          indent: 20, // 左側縮排 (讓線條懸浮)
          endIndent: 20, // 右側縮排
          // 使用極淡的顏色，若隱若現
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(dateStr,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.colorScheme.onSurface)),
                  const SizedBox(width: 4),
                  Text(weekStr,
                      style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  if (isToday)
                    Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text(t.common.today,
                            style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.bold))),
                ],
              ),
              if (isEmpty == true)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(t.S13_Task_Dashboard.empty.personal_records,
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w200,
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.8))),
                ),
              if (onAddTap != null)
                InkWell(
                  onTap: onAddTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(t.S13_Task_Dashboard.buttons.add,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w200,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.8))),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
