import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

class AppToast {
  AppToast._();

  // 1. 一般訊息 -> 使用 inverseSurface (自動對應到 _darkGrey #333333)
  static void show(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    _showSnackBar(
      context,
      message,
      colorScheme,
      backgroundColor: colorScheme.inverseSurface,
      icon: Icons.info_outline_rounded,
    );
  }

  // 2. 錯誤訊息 -> 使用 error (自動對應到 _orangeRed #FF3B30)
  static void showError(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    _showSnackBar(
      context,
      message,
      colorScheme,
      backgroundColor: colorScheme.error,
      icon: Icons.error_outline_rounded,
    );
  }

  // 3. 成功訊息 -> 使用 tertiary (自動對應到 _incomeGreen #2E7D32)
  static void showSuccess(BuildContext context, String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    _showSnackBar(
      context,
      message,
      colorScheme,
      backgroundColor: colorScheme.tertiary,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  // 底層實作：統一的圓角懸浮風格
  static void _showSnackBar(
    BuildContext context,
    String message,
    ColorScheme colorScheme, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    final isEnlarged = context.read<DisplayState>().isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    // 先隱藏舊的，避免堆疊
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // [風格設定]
        behavior: SnackBarBehavior.floating, // 懸浮
        backgroundColor: backgroundColor,
        elevation: 4,

        // 圓角：配合您的 Input Border (16px)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusL),
        ),

        // 留白：讓它浮在內容之上
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin, vertical: AppLayout.spaceL),

        // 內容佈局
        content: Row(
          children: [
            Icon(icon, color: colorScheme.surface, size: iconSize),
            const SizedBox(width: AppLayout.spaceM),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.surface, // 白字配深底/紅底最清晰
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isEnlarged ? null : 2,
                overflow: isEnlarged ? null : TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
