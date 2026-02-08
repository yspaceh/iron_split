import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_indicator.dart';

/// 可展開的選擇卡片
class SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onToggle;
  final Widget child;
  final bool isRadio;

  const SelectionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
    required this.child,
    required this.isRadio,
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
                  SelectionIndicator(
                    isSelected: isSelected,
                    isRadio: isRadio, // 傳遞樣式
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: colorScheme.onSurface,
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
