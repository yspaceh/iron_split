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

    return KeyboardActions(
      // 1. 設定全域通用的樣式
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: nextFocus,
        actions: focusNodes.map((node) {
          return KeyboardActionsItem(
            focusNode: node,
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
