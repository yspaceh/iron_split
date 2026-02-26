import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

class CommonBottomSheet extends StatelessWidget {
  /// 標題文字
  final String title;

  /// 內容區域
  final Widget children;

  /// 底部的 Sticky Action Bar
  final Widget? bottomActionBar;

  /// 標題列右側的動作按鈕
  final List<Widget>? actions;

  /// 自定義返回/關閉行為
  final VoidCallback? onBackPressed;

  const CommonBottomSheet({
    super.key,
    required this.title,
    required this.children,
    this.bottomActionBar,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    // 1. 裁切頂部圓角
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
        child: Container(
          color: colorScheme.surface, // 底色填滿
          // 2. [關鍵修正] 強制避開頂部相機區域 (Status Bar)
          child: SafeArea(
            top: true,
            bottom: false, // 底部交給 StickyBottomActionBar 自行處理
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: colorScheme.surface,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                toolbarHeight: 64, // 稍微增高以容納 Drag Handle
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Drag Handle (拖曳手柄)
                    Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12, top: 8),
                      decoration: BoxDecoration(
                        color:
                            colorScheme.outlineVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // 標題
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                centerTitle: true,
                backgroundColor: colorScheme.surface,
                elevation: 0,
                scrolledUnderElevation: 0,

                // 左上角關閉按鈕
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, size: iconSize),
                      onPressed: onBackPressed ?? () => Navigator.pop(context),
                    ),
                  ],
                ),

                // 右上角按鈕
                actions: actions != null
                    ? [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!,
                        )
                      ]
                    : null,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                child: children,
              ),
              bottomNavigationBar: bottomActionBar,
            ),
          ),
        ),
      ),
    );
  }
}
