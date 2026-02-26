// lib/features/common/presentation/widgets/custom_sliding_segment.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class CustomSlidingSegment<T> extends StatelessWidget {
  final Map<T, String> segments; // Key: Value (e.g., 0: "進行中")
  final Map<T, IconData>? icons; // Key: Icon
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final bool isSheetMode;

  const CustomSlidingSegment({
    super.key,
    required this.segments,
    this.icons,
    required this.selectedValue,
    required this.onValueChanged,
    this.isSheetMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    // 將 Map 轉為 List 以便透過 Index 操作
    final keys = segments.keys.toList();
    final selectedIndex = keys.indexOf(selectedValue);
    final isDark = theme.brightness == Brightness.dark;

    final trackColor = isDark
        ? isSheetMode
            ? colorScheme.surfaceContainerLow
            : colorScheme.surface.withValues(alpha: 0.5)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final thumbColor =
        isDark ? AppTheme.darkGray.withValues(alpha: 0.5) : colorScheme.surface;

    final double segmentVerticalPadding =
        isEnlarged ? AppLayout.spaceM : AppLayout.spaceS;

    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    return Container(
      padding: const EdgeInsets.all(AppLayout.spaceXS), // 內縮，讓白色卡片有懸浮感
      decoration: ShapeDecoration(
        color: trackColor,
        shape: const StadiumBorder(),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        // 防呆：萬一外層沒有給予寬度限制，退回使用螢幕寬度
        final totalWidth = constraints.maxWidth == double.infinity
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth;

        // 計算每個按鈕實體的 Pixel 寬度
        final segmentWidth = totalWidth / keys.length;

        return Stack(
          children: [
            // 1. 白色滑動卡片 (背景層)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              top: 0, // 緊貼 Stack 頂部
              bottom: 0, // 緊貼 Stack 底部 (高度會自動跟隨文字層)
              left: selectedIndex * segmentWidth, // 精確位移
              width: segmentWidth,
              child: Container(
                decoration: ShapeDecoration(
                  color: thumbColor, // 純白
                  shape: const StadiumBorder(),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
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
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        vertical: segmentVerticalPadding,
                        horizontal: AppLayout.spaceXS,
                      ),
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: textTheme.labelLarge!.copyWith(
                          color: isSelected
                              ? colorScheme.onSurface // 深黑灰
                              : colorScheme.onSurfaceVariant, // 冷灰
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icons != null && icons!.isNotEmpty) ...[
                              Icon(
                                icons![key],
                                size: iconSize,
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppLayout.spaceS),
                            ],
                            Flexible(
                              // 防止文字超長溢出
                              child: Text(
                                segments[key]!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }),
    );
  }
}
