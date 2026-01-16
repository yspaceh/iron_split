import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:qr_flutter/qr_flutter.dart'; 
import 'package:share_plus/share_plus.dart'; 

/// Page Key: D03_TaskCreate.Confirm
/// 職責：隊長建立任務成功的確認彈窗，提供邀請碼 QR Code 與原生分享功能。
class D03TaskCreateConfirmDialog extends StatefulWidget {
  final String? taskId;
  final String taskName;
  final String? inviteCode;

  const D03TaskCreateConfirmDialog({
    super.key,
    this.taskId,
    this.taskName = 'New Task', // 預設值保留英文或設為空，實際顯示會依賴傳入值
    this.inviteCode,
  });

  @override
  State<D03TaskCreateConfirmDialog> createState() => _D03TaskCreateConfirmDialogState();
}

class _D03TaskCreateConfirmDialogState extends State<D03TaskCreateConfirmDialog> {
  // final _memberCountCtrl = TextEditingController(text: '1'); // 保留註解：若未來需要可恢復
  // final _maxMembersCtrl = TextEditingController(text: '15');
  bool busy = false;
  String? _inviteCode;
  DateTime? _expiresAt;
  String? _status;

  @override
  void initState() {
    super.initState();
    _inviteCode = widget.inviteCode;
    // 若沒有預先傳入 code 但有 taskId，自動觸發產生（優化體驗）
    if (_inviteCode == null && widget.taskId != null) {
      _createInviteCode();
    }
  }

  @override
  void dispose() {
    // _memberCountCtrl.dispose();
    // _maxMembersCtrl.dispose();
    super.dispose();
  }

  String get _taskName => widget.taskName;
  String? get _taskId => widget.taskId;
  
  // 產生 Deep Link (用於 QR Code 與分享連結)
  // 格式依據聖經 4.2 B: iron-split://join?code=XXXXXXXX
  String get _inviteLink => 'iron-split://join?code=${_inviteCode ?? ""}';

  /* Future<void> _setTaskCounts() async {
    // ... (保留原始邏輯結構備查) ...
  } 
  */

  Future<void> _createInviteCode() async {
    final taskId = _taskId;
    if (taskId == null || taskId.isEmpty) return;

    setState(() {
      busy = true;
      _status = null;
    });

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('createInviteCode');
      final res = await callable.call({'taskId': taskId});
      final data = Map<String, dynamic>.from(res.data);

      final code = (data['code'] ?? '').toString();
      final expiresAtRaw = data['expiresAt'];

      DateTime? expiresAt;
      if (expiresAtRaw is String) {
        expiresAt = DateTime.tryParse(expiresAtRaw);
      } else if (expiresAtRaw is int) {
        expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresAtRaw);
      }

      if (code.isNotEmpty) {
        setState(() {
          _inviteCode = code;
          _expiresAt = expiresAt;
          _status = null; // 成功產生就不顯示多餘文字
        });
      }
    } catch (e) {
      // 使用 i18n 錯誤訊息
      setState(() => _status = t.D03_TaskCreate_Confirm.error_create_failed(message: e.toString()));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _switchToNewAnonymousUser() async {
    // ... (維持原有切換使用者邏輯，方便測試用) ...
    try {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInAnonymously();
      setState(() => _status = t.D03_TaskCreate_Confirm.debug_switched);
    } catch (e) {
      setState(() => _status = t.D03_TaskCreate_Confirm.debug_switch_fail(message: e.toString()));
    }
  }

  // 實作：喚起原生分享介面
  void _handleShare(BuildContext context) {
    if (_inviteCode == null) return;
    
    // 使用 i18n 組合分享文字
    final String shareText = t.D03_TaskCreate_Confirm.share_text(
      taskName: _taskName,
      inviteCode: _inviteCode!,
      link: _inviteLink,
    );

    // ✅ 保留 Debug Print
    debugPrint('🚀 [Share Debug] 準備分享內容：\n$shareText');

    // 使用 share_plus 喚起原生分享
    Share.share(
      shareText, 
      subject: t.D03_TaskCreate_Confirm.share_subject(taskName: _taskName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final displayedCode = _inviteCode ?? '...';
    final isCodeReady = _inviteCode != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題區
            Icon(Icons.qr_code_2_rounded, color: colorScheme.primary, size: 48),
            const SizedBox(height: 16),
            Text(
              t.D03_TaskCreate_Confirm.title, // "邀請成員"
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _taskName,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // QR Code 核心顯示區
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: isCodeReady
                  ? Center(
                      child: QrImageView(
                        data: _inviteLink, // 掃描後直接獲得連結
                        version: QrVersions.auto,
                        size: 180.0,
                        backgroundColor: Colors.white,
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            
            const SizedBox(height: 16),

            // 邀請碼文字顯示 (輔助用，萬一掃不到)
            InkWell(
              onTap: isCodeReady
                  ? () {
                      Clipboard.setData(ClipboardData(text: _inviteCode!));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(t.D03_TaskCreate_Confirm.copy_toast)));
                    }
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayedCode,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.copy_rounded, size: 16, color: colorScheme.primary),
                  ],
                ),
              ),
            ),
            
            // TTL 倒數提示
            if (isCodeReady && _expiresAt != null) ...[
              const SizedBox(height: 8),
              Text(
                t.D03_TaskCreate_Confirm.expires_hint(
                  time: '${_expiresAt!.hour.toString().padLeft(2,'0')}:${_expiresAt!.minute.toString().padLeft(2,'0')}'
                ),
                style: textTheme.labelSmall?.copyWith(color: colorScheme.error),
              ),
            ],

            // 錯誤訊息
            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(
                _status!,
                style: textTheme.labelSmall?.copyWith(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
            
            // Debug 面板 (保留給你測試用)
            if (kDebugMode) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text('Debug 工具', style: TextStyle(fontSize: 12)),
                children: [
                  TextButton(
                    onPressed: _switchToNewAnonymousUser,
                    child: Text(t.D03_TaskCreate_Confirm.debug_switch_user),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        // 主要動作按鈕
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: isCodeReady ? () => _handleShare(context) : null,
              icon: const Icon(Icons.ios_share_rounded), // iOS 風格分享圖示
              label: Text(t.D03_TaskCreate_Confirm.share_btn), // "分享邀請連結"
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/tasks');
              },
              child: Text(t.D03_TaskCreate_Confirm.done_btn), // "完成"
            ),
          ],
        ),
      ],
    );
  }
}