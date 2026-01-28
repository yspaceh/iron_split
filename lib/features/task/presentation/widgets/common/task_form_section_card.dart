import 'package:flutter/material.dart';

class TaskFormSectionCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final String? title;

  const TaskFormSectionCard({
    super.key,
    required this.children,
    this.padding,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null || title != '',
          child: Text(title ?? '',
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: colorScheme.primary)),
        ),
        Visibility(
          visible: title != null || title != '',
          child: const SizedBox(height: 8),
        ),
        Container(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ],
    );
  }
}
