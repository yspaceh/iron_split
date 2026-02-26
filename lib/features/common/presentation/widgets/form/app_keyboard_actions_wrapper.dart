import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart'; // 引入翻譯

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
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

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
                final safeTextScaler =
                    MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2);
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: safeTextScaler),
                  child: Container(
                    alignment: Alignment.center, // 確保在工具列內絕對垂直置中
                    padding: EdgeInsets.only(right: horizontalMargin),
                    child: FilledButton(
                      onPressed: () => node.unfocus(),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(64, 32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppLayout.spaceL),
                        shape: const StadiumBorder(),
                        elevation: 2,
                      ),
                      child: Text(
                        t.common.buttons.done, // "完成"
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
