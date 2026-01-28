import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemberCountInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const TaskMemberCountInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 15,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.groups_outlined, color: colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              t.S16_TaskCreate_Edit.field_member_count,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          // Stepper Container
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Decrease Button
                IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 18,
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                ),
                // Value Text
                SizedBox(
                  width: 24,
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Increase Button
                IconButton(
                  icon: const Icon(Icons.add),
                  iconSize: 18,
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                  style: IconButton.styleFrom(
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
