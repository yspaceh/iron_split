import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:iron_split/gen/strings.g.dart'; // 引入翻譯

class AppKeyboardActionsWrapper extends StatelessWidget {
  final Widget child;
  final List<FocusNode> focusNodes;
  final bool nextFocus; // 是否顯示「下一個」箭頭

  const AppKeyboardActionsWrapper({
    super.key,
    required this.child,
    required this.focusNodes,
    this.nextFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return KeyboardActions(
      // 1. 設定全域通用的樣式
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1E1E1E) // 深色模式鍵盤色
            : const Color(0xFFF8F8F8),
        keyboardBarElevation: 0,
        nextFocus: nextFocus,
        actions: focusNodes.map((node) {
          return KeyboardActionsItem(
            focusNode: node,
            toolbarAlignment: MainAxisAlignment.end,
            toolbarButtons: [
              // 2. 統一的「完成」按鈕
              (node) {
                return GestureDetector(
                  onTap: () => node.unfocus(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      t.common.buttons.done, // "完成"
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }
            ],
          );
        }).toList(),
      ),
      // 3. 內建點擊外部關閉功能
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      disableScroll: true, // 避免與內部的 ScrollView 衝突
      child: child,
    );
  }
}
