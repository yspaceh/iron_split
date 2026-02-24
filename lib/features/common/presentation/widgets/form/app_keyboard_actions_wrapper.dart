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
    final colorScheme = theme.colorScheme;

    return KeyboardActions(
      // 1. 設定全域通用的樣式
      config: KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.transparent,
        keyboardBarElevation: 0,
        nextFocus: nextFocus,
        actions: focusNodes.map((node) {
          return KeyboardActionsItem(
            focusNode: node,
            toolbarAlignment: MainAxisAlignment.end,
            displayArrows: false,
            displayDoneButton: false,
            toolbarButtons: [
              // 2. 統一的「完成」按鈕
              (node) {
                return Padding(
                  // 使用 Padding 把膠囊往左上方推一點，讓它不要死貼著鍵盤和螢幕邊緣
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Material(
                    // 加上 Material 來產生優雅的陰影和背景色
                    elevation: 4.0,
                    shadowColor: Colors.black45,
                    borderRadius: BorderRadius.circular(24.0), // 圓角膠囊形狀
                    color: colorScheme.primary,

                    child: InkWell(
                      // 加上水波紋點擊效果
                      borderRadius: BorderRadius.circular(24.0),
                      onTap: () => node.unfocus(),
                      child: Padding(
                        // 膠囊內部的文字留白
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8.0),
                        child: Text(
                          t.common.buttons.done, // "完成"
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
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
