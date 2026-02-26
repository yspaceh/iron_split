// lib/features/common/presentation/widgets/selection_tile.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

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
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final iconSize = AppLayout.inlineIconSize(isEnlarged);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppLayout.radiusL),
      child: Container(
        constraints: const BoxConstraints(minHeight: 56.0),
        padding: const EdgeInsets.all(AppLayout.spaceL),
        decoration: BoxDecoration(
          color: isDestructive
              ? colorScheme.error.withValues(alpha: 0.1)
              : fillColor ?? colorScheme.surface,
          borderRadius: BorderRadius.circular(AppLayout.radiusL),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: isDestructive ? colorScheme.error : null,
                    ))),
            Icon(Icons.keyboard_arrow_right_outlined,
                size: iconSize,
                color: isDestructive
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
