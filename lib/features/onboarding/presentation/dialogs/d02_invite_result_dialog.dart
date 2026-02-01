import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D02_Invite.Result
/// 職責：顯示邀請加入的結果（目前主要用於顯示失敗錯誤）
/// 架構：Pure UI Widget (Dumb Component)
/// 未來規劃：頂部 Icon 區域將替換為 Lottie 或 Rive 動畫
class D02InviteResultDialog extends StatelessWidget {
  final String errorCode; // e.g., 'INVALID_CODE', 'TASK_FULL'
  final VoidCallback? onConfirm; // 點擊按鈕後的動作 (由 Caller 決定路由)

  const D02InviteResultDialog({
    super.key,
    required this.errorCode,
    this.onConfirm,
  });

  String _getErrorMessage(BuildContext context) {
    final t = Translations.of(context);
    // 根據 Error Code 映射到 i18n
    switch (errorCode) {
      case 'INVALID_CODE':
        return t.D02_Invite_Result.error_INVALID_CODE;
      case 'EXPIRED_CODE':
        return t.D02_Invite_Result.error_EXPIRED_CODE;
      case 'TASK_FULL':
        return t.D02_Invite_Result.error_TASK_FULL;
      case 'AUTH_REQUIRED':
        return t.D02_Invite_Result.error_AUTH_REQUIRED;
      case 'unauthenticated':
        return t.D02_Invite_Result.error_AUTH_REQUIRED;
      default:
        return t.D02_Invite_Result.error_UNKNOWN;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    // 定義顏色樣式 (錯誤狀態：紅底白字)
    final backgroundColor = theme.colorScheme.errorContainer;
    final onBackgroundColor = theme.colorScheme.onErrorContainer;

    return PopScope(
      canPop: false, // 強制使用者必須點擊按鈕才能關閉
      child: Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. 動畫佔位區 (還原您的原始設計)
              Builder(
                builder: (context) {
                  // TODO: 之後會換成 Lottie 或 Rive
                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: onBackgroundColor.withValues(
                          alpha: 0.1), // 調整為與背景對比的半透明色
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sentiment_dissatisfied_outlined, // 暫時用 icon
                      size: 80,
                      color: onBackgroundColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 2. 標題
              Text(
                t.D02_Invite_Result.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: onBackgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 3. 錯誤訊息
              Text(
                _getErrorMessage(context),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: onBackgroundColor,
                ),
              ),
              const SizedBox(height: 32),

              // 4. 按鈕 (Callback)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error, // 按鈕本體深紅色
                    foregroundColor: theme.colorScheme.onError, // 按鈕文字白色
                  ),
                  onPressed: () {
                    if (onConfirm != null) {
                      onConfirm!();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(t.D02_Invite_Result.buttons.back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
