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
    final textTheme = theme.textTheme;
    final isUrgent = days <= 7;
    final color = isUrgent ? colorScheme.error : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              t.S17_Task_Locked.retention_notice(days: days),
              style: textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: isUrgent ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
