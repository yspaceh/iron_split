import 'dart:math';

import 'package:flutter/material.dart';

/// 用於全 App 統一顯示狀態圖示的元件
class ImageAssetWrapper extends StatelessWidget {
  final String? assetPath; // 用於圖片 (PNG/SVG/Rive)

  const ImageAssetWrapper({super.key, this.assetPath});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final width = MediaQuery.of(context).size.width;
    final double size = min(width * 0.25, 120);

    return SizedBox(
      width: size,
      height: size,
      child: assetPath != null
          ? Image.asset(
              assetPath!,
              // [關鍵] 使用 cover 讓圖片填滿整個正方形，不留白邊
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            )
          : Container(
              // 預設佔位圖 (開發用)
              color: colorScheme.primary,
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
    );
  }
}
