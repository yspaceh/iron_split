import 'package:flutter/material.dart';
import 'package:iron_split/core/theme/app_theme.dart';

class StickyBottomActionBar extends StatelessWidget {
  final List<Widget> children;

  const StickyBottomActionBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // [M3 修正]: 使用 surfaceContainer (或 surfaceContainerLow)
      // M3 傾向用顏色層級區分，而非深色陰影。若需要陰影可保留極淡的 shadow。
      decoration: BoxDecoration(
        color: AppTheme.surface,
        // 雖然 M3 少用陰影，但在 Sticky Bar 這種浮動層，加上極淡陰影可增加對比
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // 非常淡
            blurRadius: 3,
            offset: const Offset(0, -1),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: children.map((child) {
            return Expanded(
              child: Padding(
                // 按鈕間距
                padding: EdgeInsets.only(
                  right: child == children.last ? 0 : 12.0,
                ),
                child: child,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
