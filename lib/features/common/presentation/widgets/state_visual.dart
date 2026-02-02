import 'package:flutter/material.dart';

/// 用於全 App 統一顯示狀態圖示的元件
class StateVisual extends StatelessWidget {
  final String? assetPath; // 用於圖片 (PNG/SVG/Rive)

  const StateVisual({super.key, this.assetPath});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Center(
          child: assetPath != null
              ? Image.asset(
                  assetPath!,
                  fit: BoxFit.contain,
                )
              : Container(
                  color: Colors.amber,
                )),
    );
  }
}
