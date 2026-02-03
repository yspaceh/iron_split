// lib/features/common/presentation/widgets/common_selection_tile.dart

import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/circular_checkbox.dart';

class CommonSelectionTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final Widget? trailing;

  const CommonSelectionTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.leading,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // 選取時背景微亮 (M3 容器感)
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected ? colorScheme.outlineVariant : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // 自製圓形 Checkbox
              CircularCheckbox(isSelected: isSelected),
              const SizedBox(width: 12),
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
