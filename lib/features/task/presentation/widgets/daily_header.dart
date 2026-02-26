import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final String locale = Localizations.localeOf(context).toString();
    final dateStr = DateFormat('MM/dd').format(date);
    final weekStr = DateFormat('E', locale).format(date).toUpperCase();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    return Column(
      children: [
        Divider(
          height: 1, // 佔用高度極小
          thickness: 1, // 線條厚度
          indent: 20, // 左側縮排 (讓線條懸浮)
          endIndent: 20, // 右側縮排
          // 使用極淡的顏色，若隱若現
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: AppLayout.spaceM, horizontal: horizontalMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(dateStr,
                      style: textTheme.titleSmall
                          ?.copyWith(color: colorScheme.onSurface)),
                  const SizedBox(width: AppLayout.spaceXS),
                  Text(weekStr,
                      style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  if (isToday)
                    Container(
                        margin: const EdgeInsets.only(left: AppLayout.spaceS),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(AppLayout.radiusS)),
                        child: Text(t.common.today,
                            style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                                fontWeight: FontWeight.bold))),
                ],
              ),
              if (isEmpty == true)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppLayout.spaceXS,
                      horizontal: AppLayout.spaceS),
                  child: Text(t.S13_Task_Dashboard.empty.personal_records,
                      style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w200,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.8))),
                ),
              if (onAddTap != null)
                InkWell(
                  onTap: onAddTap,
                  borderRadius: BorderRadius.circular(AppLayout.radiusM),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: AppLayout.spaceS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppLayout.radiusM),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: iconSize,
                          color: colorScheme.onSurfaceVariant
                              .withValues(alpha: 0.8),
                        ),
                        const SizedBox(width: AppLayout.spaceXS),
                        Text(t.S13_Task_Dashboard.buttons.add,
                            style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w200,
                                color: colorScheme.onSurfaceVariant
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
