import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

class InfoBar extends StatelessWidget {
  final IconData icon;
  final Text text;

  //  允許外部覆寫顏色，增加彈性
  // 預設使用淡灰色風格 (SurfaceContainerLow)
  final Color? backgroundColor;
  final Color? contentColor;

  const InfoBar({
    super.key,
    required this.text,
    required this.icon,
    this.backgroundColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    // 定義預設顏色：淡灰底 + 深灰字
    final effectiveBgColor = backgroundColor ?? colorScheme.surfaceContainerLow;
    final effectiveContentColor = contentColor ?? colorScheme.onSurfaceVariant;

    return Container(
      // 內距維持舒適
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius:
            BorderRadius.circular(AppLayout.radiusM), // 稍微圓潤一點，符合整體 16 的風格
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 垂直置中
        children: [
          Icon(icon, color: effectiveContentColor, size: iconSize),
          const SizedBox(width: 8),
          Expanded(
            // 強制讓傳入的 Text 使用我們定義的顏色 (如果 Text 本身沒設 style)
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: effectiveContentColor,
                fontSize: 12, // 保持小字
                fontWeight: FontWeight.w500, // 微粗體，增加可讀性
              ),
              child: text,
            ),
          ),
        ],
      ),
    );
  }
}
