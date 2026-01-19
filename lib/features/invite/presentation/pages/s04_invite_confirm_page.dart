import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S04_Invite.Confirm
/// 職責：顯示任務邀請確認資訊。
class S04InviteConfirmPage extends StatefulWidget {
  /// 由 Deep Link 或路由參數傳入的邀請碼
  final String inviteCode;

  const S04InviteConfirmPage({
    super.key,
    required this.inviteCode,
  });

  @override
  State<S04InviteConfirmPage> createState() => _S04InviteConfirmPageState();
}

class _S04InviteConfirmPageState extends State<S04InviteConfirmPage> {
  // 頁面狀態
  bool _isLoading = true;
  bool _isJoining = false;
  String? _error;

  // 資料來源
  Map<String, dynamic>? _taskSummary;
  List<Map<String, dynamic>> _unlinkedMembers = [];

  // 使用者操作狀態
  String? _selectedMergeMemberId;

  @override
  void initState() {
    super.initState();
    _previewInvite();
  }

  Future<void> _previewInvite() async {
    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('previewInviteCode');
      final res = await callable.call({'code': widget.inviteCode});

      final data = Map<String, dynamic>.from(res.data);

      if (data['action'] == 'OPEN_TASK') {
        if (mounted) context.go('/tasks/${data['taskId']}');
        return;
      }

      final summary = Map<String, dynamic>.from(data['taskSummary']);
      final rawGhosts = data['unlinkedMembers'] as List<dynamic>? ?? [];
      final List<Map<String, dynamic>> ghosts = rawGhosts.map((e) {
        return Map<String, dynamic>.from(e);
      }).toList();

      if (mounted) {
        setState(() {
          _taskSummary = summary;
          _unlinkedMembers = ghosts;
          _isLoading = false;
        });
      }
    } on FirebaseFunctionsException catch (e) {
      _handleError('${t.S04_Invite_Confirm.loading_invite} (${e.code})');
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _error = message;
        _isLoading = false;
      });
    }
  }

  Future<void> _joinTask() async {
    if (_isJoining) return;
    setState(() => _isJoining = true);

    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? '新成員';

    try {
      final callable =
          FirebaseFunctions.instance.httpsCallable('joinByInviteCode');

      final res = await callable.call({
        'code': widget.inviteCode,
        'displayName': displayName,
        'mergeMemberId': _selectedMergeMemberId,
      });

      final data = Map<String, dynamic>.from(res.data);
      final taskId = data['taskId'];

      if (mounted) {
        // D01 的顯示邏輯將由 Dashboard 內部判斷 (hasSeenIntro)
        context.go('/tasks/$taskId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(t.S04_Invite_Confirm.error_generic(message: e.toString())),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() => _isJoining = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 1. 載入中
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(t.S04_Invite_Confirm.loading_invite,
                  style: textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    // 2. 錯誤
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
            title: Text(t.S04_Invite_Confirm.join_failed_title)), // "哎呀！無法加入任務"
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image_rounded,
                    size: 64, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  t.S04_Invite_Confirm.join_failed_title,
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                FilledButton.tonal(
                  onPressed: () => context.go('/tasks'),
                  child: Text(t.S04_Invite_Confirm.action_home), // "回首頁"
                ),
              ],
            ),
          ),
        ),
      );
    }

    final taskName = _taskSummary?['name'] ?? 'Task';
    final memberCount = _taskSummary?['memberCount'] ?? 0;
    final maxMembers = _taskSummary?['maxMembers'] ?? 0;
    final currency = _taskSummary?['baseCurrency'] ?? 'TWD';

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S04_Invite_Confirm.title), // "加入任務"
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // --- 任務資訊卡片 ---
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.airplane_ticket_rounded,
                                  size: 32,
                                  color: colorScheme.onPrimaryContainer),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              taskName,
                              textAlign: TextAlign.center,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.group_outlined,
                                    size: 16, color: colorScheme.outline),
                                const SizedBox(width: 4),
                                Text(
                                  '$memberCount / $maxMembers', // 數字不需要翻譯
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: colorScheme.outline),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.currency_exchange,
                                    size: 16, color: colorScheme.outline),
                                const SizedBox(width: 4),
                                Text(
                                  currency,
                                  style: textTheme.bodyMedium
                                      ?.copyWith(color: colorScheme.outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- 連結成員選單 ---
                    if (_unlinkedMembers.isNotEmpty) ...[
                      Text(
                        t.S04_Invite_Confirm
                            .identity_match_title, // "請問您是以下成員嗎？"
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.S04_Invite_Confirm
                            .identity_match_desc, // "此任務已預先建立了..."
                        style: textTheme.bodySmall
                            ?.copyWith(color: colorScheme.outline),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _unlinkedMembers.length,
                        separatorBuilder: (ctx, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (ctx, index) {
                          final member = _unlinkedMembers[index];
                          final memberId = member['id'];
                          final displayName = member['displayName'] as String;
                          final isSelected = _selectedMergeMemberId == memberId;
                          final initial = displayName.isNotEmpty
                              ? displayName.characters.first
                              : '?';

                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedMergeMemberId = null;
                                } else {
                                  _selectedMergeMemberId = memberId;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outlineVariant,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.surfaceContainerHighest,
                                    foregroundColor: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurfaceVariant,
                                    child: Text(initial),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      displayName,
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? colorScheme.onPrimaryContainer
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check_circle_rounded,
                                        color: colorScheme.primary)
                                  else
                                    Icon(Icons.radio_button_unchecked,
                                        color: colorScheme.outline),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                colorScheme.secondaryContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _selectedMergeMemberId != null
                                ? t.S04_Invite_Confirm
                                    .status_linking // "將以「連結帳號」方式加入"
                                : t.S04_Invite_Confirm
                                    .status_new_member, // "將以「新成員」身分加入"
                            style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSecondaryContainer),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // --- 底部按鈕 ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton.tonal(
                        onPressed:
                            _isJoining ? null : () => context.go('/tasks'),
                        child: Text(t.S04_Invite_Confirm.action_cancel), // "取消"
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: _isJoining ? null : _joinTask,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: _isJoining
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: colorScheme.onPrimary),
                              )
                            : Text(t.S04_Invite_Confirm.action_confirm), // "加入"
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
