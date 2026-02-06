import 'dart:ui';

import 'package:flutter/material.dart';

class StickyBottomActionBar extends StatelessWidget {
  final List<Widget> children;
  final bool useSafeArea;

  /// 是否為 BottomSheet 模式
  /// - false (Page): 全寬度陰影，強調底座感
  /// - true (Sheet): 內縮分隔線 (Inset Divider)，強調卡片感
  final bool isSheetMode;

  const StickyBottomActionBar({
    super.key,
    required this.children,
    this.useSafeArea = true,
    this.isSheetMode = false, // 預設為 Page Mode
  });

  /// 專門給 BottomSheet 使用的建構子
  const StickyBottomActionBar.sheet({
    super.key,
    required this.children,
    this.useSafeArea = true,
  }) : isSheetMode = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 內容本體 (按鈕列)
    Widget content = SafeArea(
      top: false,
      bottom: useSafeArea,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: children.map((child) {
            return Expanded(
              child: Padding(
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

    // 根據模式決定外框裝飾
    if (isSheetMode) {
      // --- Sheet Mode: 內縮分隔線 (Inset Divider) ---
      return Container(
        color: colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min, // 緊縮高度
          children: [
            // 這一條就是您要的「內縮細線」
            Divider(
              height: 1, // 佔用高度
              thickness: 1, // 線條粗細
              indent: 16, // 左邊留白
              endIndent: 16, // 右邊留白
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            content,
          ],
        ),
      );
    } else {
      final backgroundColor = colorScheme.surface.withValues(alpha: 0.85);
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: content,
          ),
        ),
      );
    }
  }
}
