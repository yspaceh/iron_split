import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/circular_checkbox.dart';

/// 可展開的選擇卡片
class SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onToggle;
  final Widget child;

  const SelectionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color:
            isSelected ? colorScheme.surfaceContainerLow : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: isSelected ? colorScheme.primary : colorScheme.outlineVariant,
        //   width: 1.5,
        // ),
      ),
      child: Column(
        children: [
          // Header (Always visible)
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircularCheckbox(isSelected: isSelected),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded Body
          if (isSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 8),
                  child,
                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
