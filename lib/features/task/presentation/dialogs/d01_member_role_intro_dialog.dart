import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D01_MemberRole.Intro
/// 職責：成員(含隊長)初次進入任務時，顯示角色與隨機分配的頭像。
class D01MemberRoleIntroDialog extends StatefulWidget {
  final String taskId;
  final String initialAvatar;
  final bool canReroll;

  const D01MemberRoleIntroDialog({
    super.key,
    required this.taskId,
    required this.initialAvatar,
    this.canReroll = true,
  });

  @override
  State<D01MemberRoleIntroDialog> createState() =>
      _D01MemberRoleIntroDialogState();
}

class _D01MemberRoleIntroDialogState extends State<D01MemberRoleIntroDialog> {
  late String _currentAvatar;
  late bool _canReroll;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar;
    _canReroll = widget.canReroll;
  }

  // 呼叫後端重抽頭像
  Future<void> _handleReroll() async {
    setState(() => _isProcessing = true);
    try {
      // 呼叫 Cloud Function: rerollAvatar
      // 若後端尚未部署，這裡會報錯。開發階段可暫時用前端隨機模擬。
      final callable = FirebaseFunctions.instance.httpsCallable('rerollAvatar');
      final res = await callable.call({'taskId': widget.taskId});
      final data = Map<String, dynamic>.from(res.data);

      setState(() {
        _currentAvatar = data['newAvatar'];
        _canReroll = false; // 只能抽一次
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('重抽失敗: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // 完成並關閉：更新 DB 狀態
  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 更新 Firestore: 標記已看過 Intro
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .collection('members')
          .doc(uid)
          .update({'hasSeenIntro': true});

      if (mounted) {
        Navigator.of(context).pop(); // 關閉 Dialog
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false, // 強制必須點按鈕才能離開
      child: AlertDialog(
        title: Text(t.D01_InviteJoin_Success.title), // "成功加入任務！"
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.D01_InviteJoin_Success.assigned_avatar),
            const SizedBox(height: 16),

            // 頭像顯示區 (這裡暫時用 Icon 代替，實際請換成 Image Asset)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _currentAvatar.substring(0, 1).toUpperCase(), // 顯示首字母
                  style: theme.textTheme.displayMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(_currentAvatar, style: theme.textTheme.titleMedium), // 顯示動物 ID

            const SizedBox(height: 16),
            if (_canReroll)
              TextButton.icon(
                onPressed: _isProcessing ? null : _handleReroll,
                icon: const Icon(Icons.refresh),
                label: const Text('不喜歡？重抽一次'),
              )
            else
              Text(
                t.D01_InviteJoin_Success.avatar_note, // "註：頭像僅能重抽一次。"
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: _isProcessing ? null : _handleConfirm,
            child: Text(t.D01_InviteJoin_Success.action_continue), // "開始記帳"
          ),
        ],
      ),
    );
  }
}
