// lib/features/common/presentation/widgets/selection_tile.dart

import 'package:flutter/material.dart';

class NavTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? fillColor;
  final bool isDestructive;

  const NavTile({
    super.key,
    required this.onTap,
    required this.title,
    this.fillColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive
              ? colorScheme.error.withValues(alpha: 0.1)
              : fillColor ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: isDestructive ? colorScheme.error : null,
                    ))),
            Icon(Icons.keyboard_arrow_right_outlined,
                color: isDestructive
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
