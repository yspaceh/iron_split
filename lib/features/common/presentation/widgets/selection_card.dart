import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_indicator.dart';

/// 可展開的選擇卡片
class SelectionCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onToggle;
  final Widget child;
  final bool isRadio;
  final Color? backgroundColor;
  final Color? isSelectedBackgroundColor;

  const SelectionCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onToggle,
    required this.child,
    required this.isRadio,
    this.backgroundColor,
    this.isSelectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected
            ? isSelectedBackgroundColor ?? colorScheme.surfaceContainerLow
            : backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
