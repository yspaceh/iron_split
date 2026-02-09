import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData? icon;
  final Widget child;

  /// 背景顏色 (若不填則預設使用 surfaceContainer)
  final Color? backgroundColor;
  const InfoCard({
    super.key,
    this.icon,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 預設樣式邏輯
    final bgColor = backgroundColor ?? colorScheme.surface;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 讓 Icon 對齊文字頂部
        children: [
          // 1. 左側 Icon (隱私/安全相關)
          Icon(
            icon, // 或 verified_user_outlined
            size: 24,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8), // M3 標準間距

          // 2. 右側說明文字
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
