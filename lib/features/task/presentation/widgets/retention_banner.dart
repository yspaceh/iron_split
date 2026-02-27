import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppLayout.spaceS, horizontal: horizontalMargin),
      color: colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, size: iconSize, color: color),
          const SizedBox(width: AppLayout.spaceXS),
          Expanded(
            child: Text(
              t.s17_task_locked.retention_notice(days: days),
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
