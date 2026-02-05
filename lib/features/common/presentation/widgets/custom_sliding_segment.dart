// lib/features/common/presentation/widgets/custom_sliding_segment.dart

import 'package:flutter/material.dart';

class CustomSlidingSegment<T> extends StatelessWidget {
  final Map<T, String> segments; // Key: Value (e.g., 0: "進行中")
  final Map<T, IconData>? icons; // Key: Icon
  final T selectedValue;
  final ValueChanged<T> onValueChanged;

  const CustomSlidingSegment({
    super.key,
    required this.segments,
    this.icons,
    required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 將 Map 轉為 List 以便透過 Index 操作
    final keys = segments.keys.toList();
    final selectedIndex = keys.indexOf(selectedValue);

    final backgroundColor = colorScheme.surfaceContainerHighest;

    return Container(
      height: 46, // 固定高度，符合手指點擊範圍
      padding: const EdgeInsets.all(4), // 內縮，讓白色卡片有懸浮感
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // 1. 白色滑動卡片 (背景層)
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            // 計算 Alignment: -1 是最左，1 是最右
            alignment: Alignment(
              -1.0 + (selectedIndex * 2.0 / (keys.length - 1)),
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / keys.length, // 根據選項數量均分寬度
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface, // 純白
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. 文字與圖示 (前景層)
          Row(
            children: keys.map((key) {
              final isSelected = key == selectedValue;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onValueChanged(key),
                  child: Container(
                    color: Colors.transparent, // 確保空白處也能點擊
                    alignment: Alignment.center,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: theme.textTheme.labelLarge!.copyWith(
                        // [視覺優化]
                        // 選中時：用深灰色 (比酒紅更沈穩，因為白色底已經夠亮了)
                        // 未選時：用冷灰色
                        color: isSelected
                            ? colorScheme.onSurface // 深黑灰
                            : colorScheme.onSurfaceVariant, // 冷灰
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14, // 精緻的小字
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // 關鍵：讓 Row 寬度收縮，只包住內容
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (icons != null && icons!.isNotEmpty)
                            Icon(
                              icons![key],
                              size: 18,
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          const SizedBox(width: 8),
                          Text(segments[key]!),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
