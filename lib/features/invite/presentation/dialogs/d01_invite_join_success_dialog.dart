import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D01_InviteJoin.Success
/// 職責：顯示加入成功訊息，並允許使用者更換一次頭像。
/// 邏輯：接收初始頭像，更換時從「未被連結」的動物池中隨機選取。
class D01InviteJoinSuccessDialog extends StatefulWidget {
  final String taskId;
  final String initialAvatar; // 進入前已確定的初始動物

  const D01InviteJoinSuccessDialog({
    super.key,
    required this.taskId,
    this.initialAvatar = "🦉", // 預設測試值
  });

  @override
  State<D01InviteJoinSuccessDialog> createState() => _D01InviteJoinSuccessDialogState();
}

class _D01InviteJoinSuccessDialogState extends State<D01InviteJoinSuccessDialog> {
  late String _currentAvatar;
  bool _hasRedrawn = false; // 紀錄是否已經重抽過

  // TODO: [MVP] 正式版應從 API 取得「該任務剩餘可用」的動物清單
  // 模擬可用動物池 (需排除任務中已被佔用的動物)
  final List<String> _availablePool = ["🦉", "🦊", "🐻", "🐨", "🦁", "🐯", "🐱", "🐶"];

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar;
  }

  /// 執行更換動物邏輯
  void _handleRedraw() {
    if (_hasRedrawn) return;

    setState(() {
      // 1. 從池中移除當前顯示的動物，確保不會抽到重複的
      final pool = List<String>.from(_availablePool)..remove(_currentAvatar);
      
      // 2. 隨機選取一個新動物 (模擬任務內唯一性)
      if (pool.isNotEmpty) {
        _currentAvatar = (pool..shuffle()).first;
      }
      
      _hasRedrawn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Text(
        t.D01_InviteJoin_Success.title,
        textAlign: TextAlign.center,
        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          // 顯示頭像
          CircleAvatar(
            radius: 50,
            backgroundColor: colorScheme.primaryContainer,
            child: Text(_currentAvatar, style: const TextStyle(fontSize: 48)),
          ),
          const SizedBox(height: 24),
          Text(t.D01_InviteJoin_Success.assigned_avatar, style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          
          // 更換按鈕：僅限一次
          if (!_hasRedrawn)
            OutlinedButton.icon(
              onPressed: _handleRedraw,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("換一個動物"),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
              ),
            )
          else
            Text(
              t.D01_InviteJoin_Success.avatar_note,
              style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
            ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // TODO: [MVP] 儲存最終選定的 _currentAvatar 到該任務的成員資料中
              Navigator.of(context).pop();
              context.go('/tasks'); 
            },
            child: Text(t.D01_InviteJoin_Success.action_continue),
          ),
        ),
      ],
    );
  }
}