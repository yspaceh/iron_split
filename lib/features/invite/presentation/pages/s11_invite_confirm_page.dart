import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/invite/presentation/dialogs/d02_invite_result_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S11_Invite.Confirm
/// 職責：
/// 1. 呼叫 previewInviteCode 顯示任務資訊
/// 2. 呼叫 joinByInviteCode 執行加入
/// 3. 若預覽或加入失敗，統一彈出 D02 Error Dialog
class S11InviteConfirmPage extends StatefulWidget {
  final String inviteCode;

  const S11InviteConfirmPage({
    super.key,
    required this.inviteCode,
  });

  @override
  State<S11InviteConfirmPage> createState() => _S11InviteConfirmPageState();
}

class _S11InviteConfirmPageState extends State<S11InviteConfirmPage> {
  bool _isLoading = true; // 預覽載入中
  bool _isJoining = false; // 加入動作執行中
  Map<String, dynamic>? _taskData;

  // 錯誤狀態移除，改用 Dialog 處理

  @override
  void initState() {
    super.initState();
    _previewInvite();
  }

  /// 1. 預覽邀請碼
  Future<void> _previewInvite() async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('previewInviteCode');
      final res = await callable.call({'code': widget.inviteCode});

      if (mounted) {
        setState(() {
          _taskData = res.data as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } on FirebaseFunctionsException catch (e) {
      _handleError(e.code, e.message, e.details);
    } catch (e) {
      _handleError('UNKNOWN', e.toString(), null);
    }
  }

  /// 2. 執行加入
  Future<void> _handleJoin() async {
    setState(() => _isJoining = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null)
        throw FirebaseFunctionsException(
            code: 'unauthenticated', message: 'Auth Required');

      final callable =
          FirebaseFunctions.instance.httpsCallable('joinByInviteCode');

      // 呼叫 Cloud Function
      final res = await callable.call({
        'code': widget.inviteCode,
        'displayName': user.displayName ?? 'Guest', // 使用者名稱
        // 'mergeMemberId': ... // 若有 Ghost Member 綁定邏輯可在此擴充
      });

      final taskId = res.data['taskId'];

      if (mounted) {
        // 加入成功，前往任務主頁
        // context.go 會清除 stack，避免按上一頁回到邀請確認頁
        context.go('/tasks/$taskId');
      }
    } on FirebaseFunctionsException catch (e) {
      // 捕捉後端定義的錯誤 (TASK_FULL, EXPIRED_CODE 等)
      // 通常 error details 會包含我們自定義的 code
      final customCode = e.details?['code'] ?? e.message ?? 'UNKNOWN';
      _handleError(customCode, e.message, e.details);
    } catch (e) {
      _handleError('UNKNOWN', e.toString(), null);
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  /// 3. 統一錯誤處理 -> D02
  void _handleError(String code, String? message, dynamic details) {
    // 解析後端傳回的 Error Code (優先使用 details['code'])
    String errorCode = 'UNKNOWN';

    if (details is Map && details['code'] != null) {
      errorCode = details['code'];
    } else if (message != null) {
      // 部分情況下錯誤碼可能直接在 message (視 Cloud Function 實作而定)
      if (message.contains('TASK_FULL'))
        errorCode = 'TASK_FULL';
      else if (message.contains('EXPIRED'))
        errorCode = 'EXPIRED_CODE';
      else if (message.contains('INVALID')) errorCode = 'INVALID_CODE';
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => D02InviteResultDialog(errorCode: errorCode),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 載入中畫面
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 雖然 _previewInvite 失敗會彈 Dialog，但底層畫面仍需渲染
    // 若無資料 (預覽失敗)，顯示空白或簡單背景即可，等待 Dialog 引導離開
    if (_taskData == null) {
      return const Scaffold();
    }

    final taskName = _taskData!['taskName'] ?? 'Unknown Task';
    final captainName = _taskData!['captainName'] ?? 'Unknown';
    // final memberCount = _taskData!['memberCount'] ?? 0;
    // final maxMembers = _taskData!['maxMembers'] ?? 15;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S11_Invite_Confirm.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // 任務資訊卡片
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Column(
                    children: [
                      Icon(Icons.airplane_ticket,
                          size: 64, color: colorScheme.primary),
                      const SizedBox(height: 24),
                      Text(
                        taskName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Chip(
                        avatar: const Icon(Icons.star, size: 16),
                        label: Text("Captain: $captainName"),
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
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Text(t.S11_Invite_Confirm.action_confirm,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),

              // 取消按鈕
              SizedBox(
                height: 56,
                child: TextButton(
                  onPressed: () => context.go('/tasks'), // 回首頁
                  child: Text(t.S11_Invite_Confirm.action_cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
