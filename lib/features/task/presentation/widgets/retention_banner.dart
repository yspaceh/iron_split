import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class RetentionBanner extends StatelessWidget {
  final int days;

  const RetentionBanner({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUrgent = days <= 7;
    final backgroundColor = isUrgent
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHigh;
    final textColor =
        isUrgent ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant;
    final iconColor =
        isUrgent ? colorScheme.error : colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: iconColor),
          const SizedBox(width: 8),
          Text(
            t.S17_Task_Locked.retention_notice(days: days),
            style: theme.textTheme.labelMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
