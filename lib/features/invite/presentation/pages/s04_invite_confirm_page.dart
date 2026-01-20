import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/invite/presentation/dialogs/d02_invite_join_error_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S04_Invite.Confirm
/// 職責：
/// 1. 呼叫 previewInviteCode 顯示任務資訊
/// 2. 呼叫 joinByInviteCode 執行加入
/// 3. 若加入失敗，彈出 D02 Error Dialog
class S04InviteConfirmPage extends StatefulWidget {
  final String inviteCode;

  const S04InviteConfirmPage({
    super.key,
    required this.inviteCode,
  });

  @override
  State<S04InviteConfirmPage> createState() => _S04InviteConfirmPageState();
}

class _S04InviteConfirmPageState extends State<S04InviteConfirmPage> {
  bool _isLoading = true;
  bool _isJoining = false;
  Map<String, dynamic>? _taskData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _previewInvite();
  }

  /// 1. 預覽邀請碼 (取得任務名稱、隊長等資訊)
  Future<void> _previewInvite() async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('previewInviteCode');
      final res = await callable.call({'code': widget.inviteCode});

      if (mounted) {
        setState(() {
          _taskData = Map<String, dynamic>.from(res.data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _mapErrorMessage(e);
          _isLoading = false;
        });
        // 預覽失敗直接彈錯 (通常是無效連結)
        _showErrorDialog(_error!);
      }
    }
  }

  /// 2. 執行加入動作
  Future<void> _handleJoin() async {
    setState(() => _isJoining = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // 理論上 System Gatekeeper 會擋，但這裡做個雙重保險
        throw FirebaseFunctionsException(
            code: 'unauthenticated', message: 'AUTH_REQUIRED');
      }

      final callable =
          FirebaseFunctions.instance.httpsCallable('joinByInviteCode');

      // 呼叫後端加入 API
      final res = await callable.call({
        'code': widget.inviteCode,
        'displayName': user.displayName ?? 'New Member',
      });

      final data = Map<String, dynamic>.from(res.data);
      final taskId = data['taskId'];

      if (mounted) {
        // 加入成功 -> 前往 S06 Dashboard (會自動觸發 D01 Intro)
        context.go('/tasks/$taskId');
      }
    } catch (e) {
      if (mounted) {
        // ✅ 3. 錯誤處理邏輯：解析錯誤並顯示 D02 Dialog
        final errorMsg = _mapErrorMessage(e);
        _showErrorDialog(errorMsg);
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  /// 顯示 D02 錯誤彈窗
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => D02InviteJoinErrorDialog(
        errorMessage: message,
      ),
    );
  }

  /// 將後端 Error Code 轉換為 i18n 文字
  String _mapErrorMessage(dynamic e) {
    String code = 'UNKNOWN';

    if (e is FirebaseFunctionsException) {
      code = e.message ?? e.code;
    } else {
      code = e.toString();
    }

    // 依據 Bible 定義的 Error Codes 進行翻譯
    switch (code) {
      case 'TASK_FULL':
        return t.error.taskFull.message(limit: 15);
      case 'EXPIRED_CODE':
        return t.error.expiredCode.message(minutes: 15);
      case 'INVALID_CODE':
        return t.error.invalidCode.message;
      case 'AUTH_REQUIRED':
        return t.error.authRequired.message;
      case 'ALREADY_IN_TASK':
        return t.error.alreadyInTask.message;
      default:
        // 如果不是預定義的代碼，顯示通用錯誤
        return t.S04_Invite_Confirm.error_join_failed(message: code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 載入中畫面
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(t.S04_Invite_Confirm.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(t.S04_Invite_Confirm.loading_invite),
            ],
          ),
        ),
      );
    }

    // 預覽失敗畫面 (顯示錯誤 + 回首頁)
    if (_taskData == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.S04_Invite_Confirm.join_failed_title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_outlined,
                  size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                _error ?? t.error.unknown.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => context.go('/tasks'),
                child: Text(t.S04_Invite_Confirm.action_home),
              ),
            ],
          ),
        ),
      );
    }

    // 正常顯示：任務資訊卡片
    final taskName = _taskData!['name'] ?? 'Unknown Task';
    final captainName = _taskData!['captainName'] ?? 'Unknown Captain';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S04_Invite_Confirm.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/tasks'), // 取消則回首頁
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.S04_Invite_Confirm.subtitle, // "您受邀加入以下任務："
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),

            // 任務資訊卡片
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(Icons.airplane_ticket,
                        size: 48, color: colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      taskName,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Captain: $captainName",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // 加入按鈕
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _isJoining ? null : _handleJoin,
                child: _isJoining
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(t.S04_Invite_Confirm.action_confirm), // "加入"
              ),
            ),
            const SizedBox(height: 16),

            // 取消按鈕
            SizedBox(
              height: 56,
              child: TextButton(
                onPressed: () => context.go('/tasks'),
                child: Text(t.S04_Invite_Confirm.action_cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
