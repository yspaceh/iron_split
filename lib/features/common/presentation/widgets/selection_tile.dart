// lib/features/common/presentation/widgets/selection_tile.dart

import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/circular_checkbox.dart';

class SelectionTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget leading;
  final String title;
  final Widget? trailing;
  final Color? backgroundColor;

  const SelectionTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.leading,
    required this.title,
    this.trailing,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // [修改] 統一為 16
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // [修改] 內距加大，符合卡片風格
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            // [修改] 跟隨 SelectionCard 的配色邏輯
            // 未選中是 Surface (實心)，選中是 SurfaceContainerLow (或依需求微調)
            // 如果原本想要選中時有顏色，可以改回 primaryContainer.withOpacity
            color: backgroundColor ??
                (isSelected
                    ? colorScheme.surfaceContainerLow
                    : colorScheme.surface),
            borderRadius: BorderRadius.circular(16), // [修改] 統一為 16
          ),
          child: Row(
            children: [
              // 圓形 Checkbox
              CircularCheckbox(isSelected: isSelected),
              const SizedBox(width: 8),
              leading,
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    // [修改] 使用 titleMedium 讓文字更有份量
                    // [修改] 選中時變色 (Primary Color)，與 SelectionCard 一致
                    color: colorScheme.onSurface,
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
