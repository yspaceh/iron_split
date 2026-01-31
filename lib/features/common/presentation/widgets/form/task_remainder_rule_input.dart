import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskRemainderRuleInput extends StatelessWidget {
  const TaskRemainderRuleInput({
    super.key,
    required this.rule,
    required this.onTap,
    this.enabled = true,
  });

  final String rule;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _buildRowItem(
      context: context,
      icon: Icons.calculate_outlined,
      label: t.remainder_rule.title,
      value: rule,
      onTap: enabled ? onTap : null,
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
