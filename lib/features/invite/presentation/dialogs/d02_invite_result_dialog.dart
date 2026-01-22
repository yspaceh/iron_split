import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D02_Invite.Result
class D02InviteResultDialog extends StatelessWidget {
  final String errorCode; // e.g., 'INVALID_CODE', 'TASK_FULL'

  const D02InviteResultDialog({
    super.key,
    required this.errorCode,
  });

  String _getErrorMessage() {
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
      default:
        return t.D02_Invite_Result.error_UNKNOWN;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 錯誤動畫佔位符 (鐵公雞哭泣)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Icon(
                      Icons.sentiment_dissatisfied_outlined, // 暫時用 icon
                      size: 80,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              Text(
                t.D02_Invite_Result.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                _getErrorMessage(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 32),

              // Action: 回首頁
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.onErrorContainer,
                    foregroundColor: theme.colorScheme.errorContainer,
                  ),
                  onPressed: () {
                    context.goNamed('S10'); // 回到任務列表首頁
                  },
                  child: Text(t.D02_Invite_Result.action_back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
