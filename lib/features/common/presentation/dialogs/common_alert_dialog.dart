import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<Widget>? actions;

  const CommonAlertDialog({
    super.key,
    required this.title,
    this.content,
    this.actions,
  });

  /// Helper static method
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    Widget? content,
    List<Widget>? actions,
  }) {
    return showDialog(
      context: context,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double standardPadding = AppLayout.spaceXL;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusXXL),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      insetPadding: EdgeInsets.symmetric(
          horizontal: standardPadding, vertical: standardPadding),
      child: Padding(
        padding: const EdgeInsets.all(standardPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 高度隨內容自動緊縮
          crossAxisAlignment: CrossAxisAlignment.stretch, // 水平拉滿
          children: [
            // --- 1. 標題區 ---
            Text(
              title,
              style: textTheme.titleLarge,
            ),

            // --- 2. 內容區 ---
            if (content != null) ...[
              const SizedBox(height: AppLayout.spaceL),
              Flexible(child: content!),
            ],

            // --- 3. 按鈕區 (完全客製化排版) ---
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: AppLayout.spaceXL),
              isEnlarged
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: actions!.map((child) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                child == actions!.last ? 0 : AppLayout.spaceM,
                          ),
                          child: child,
                        );
                      }).toList(),
                    )
                  : Row(
                      children: actions!.map((child) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  child == actions!.last ? 0 : AppLayout.spaceM,
                            ),
                            child: child,
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ],
        ),
      ), // 對話框與螢幕邊緣的安全距離
    );
  }
}
