import 'package:flutter/material.dart';

/// 用於全 App 統一顯示狀態圖示的元件
class StateVisual extends StatelessWidget {
  final String? assetPath; // 用於圖片 (PNG/SVG/Rive)

  const StateVisual({super.key, this.assetPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          // 統一的底色 (圖片載入前或透明圖的背景)
          color: theme.colorScheme.surfaceContainerLow,
          // 統一的圓角 (例如 24)
          borderRadius: BorderRadius.circular(24),
          // 統一的陰影 (增加立體感，選用)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // 裁切圖片以符合圓角
        clipBehavior: Clip.antiAlias,
        child: assetPath != null
            ? Image.asset(
                assetPath!,
                // [關鍵] 使用 cover 讓圖片填滿整個正方形，不留白邊
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : Container(
                // 預設佔位圖 (開發用)
                color: Colors.amber,
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }
}
