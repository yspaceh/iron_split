import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_layout.dart';

class SectionWrapper extends StatelessWidget {
  final List<Widget> children;
  final String? title;

  const SectionWrapper({
    super.key,
    required this.children,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || title != '') ...[
            Text(
              title ?? '',
              style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppLayout.spaceS),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ],
      ),
    );
  }
}
