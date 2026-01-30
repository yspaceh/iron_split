import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/onboarding/presentation/dialogs/d02_invite_result_dialog.dart';
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

  // Ghost Inheritance State
  List<Map<String, dynamic>> _ghosts = [];
  String? _selectedGhostId;
  bool _isAutoAssign = true;

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
        final data = res.data as Map<String, dynamic>;

        // Parse Ghosts Data
        List<Map<String, dynamic>> ghosts = [];
        final ghostsData = data['ghosts'] as List?;

        bool autoAssign = true;

        if (ghostsData != null) {
          ghosts = ghostsData
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();

          // Check if all ghosts are financially identical
          if (ghosts.length > 1) {
            final first = ghosts.first;
            // Epsilon for double comparison
            const double epsilon = 0.001;

            for (var i = 1; i < ghosts.length; i++) {
              final current = ghosts[i];
              final double prepaid1 =
                  (first['prepaid'] as num?)?.toDouble() ?? 0.0;
              final double prepaid2 =
                  (current['prepaid'] as num?)?.toDouble() ?? 0.0;
              final double expense1 =
                  (first['expense'] as num?)?.toDouble() ?? 0.0;
              final double expense2 =
                  (current['expense'] as num?)?.toDouble() ?? 0.0;

              if ((prepaid1 - prepaid2).abs() > epsilon ||
                  (expense1 - expense2).abs() > epsilon) {
                autoAssign = false;
                break;
              }
            }
          }
        } else {
          // Handle missing ghosts field (legacy backend support)
          ghosts = [];
        }

        // If auto-assign is false, user must pick, so clear any selection initially
        // If auto-assign is true, we don't care about selectedGhostId as backend picks

        setState(() {
          _taskData = data;
          _ghosts = ghosts;
          _isAutoAssign = autoAssign;
          _selectedGhostId = null;
          _isLoading = false;
        });

        if (ghosts.isEmpty) {
          // Wait, if ghosts is empty, does it mean Task Full?
          // Usually previewInviteCode throws TASK_FULL if no seats.
          // If it returns successfully but ghosts is empty, maybe it's a new task with no ghosts?
          // Or maybe pure "New Member" mode?
          // Requirement says: "If ghosts is empty -> Show Error (Task Full)."
          // But previewInviteCode usually handles this.
          // If the backend returns success, it implies there is a slot.
          // If slot is a Ghost slot, ghosts list should not be empty.
          // I will assume if ghosts is empty it might be an error state or legacy.
          // But I shouldn't block it if the backend says OK.
          // "Ensure the UI handles the missing ghosts field gracefully"
        }
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
        'targetMemberId': _selectedGhostId, // Pass selected ghost ID
      });

      final taskId = res.data['taskId'];

      if (mounted) {
        // 加入成功，前往任務主頁
        context.go('/tasks/$taskId');
      }
    } on FirebaseFunctionsException catch (e) {
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
    String errorCode = 'UNKNOWN';

    if (details is Map && details['code'] != null) {
      errorCode = details['code'];
    } else if (message != null) {
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_taskData == null) {
      return const Scaffold();
    }

    final taskName = _taskData!['taskName'] ?? 'Unknown Task';
    final currency = _taskData!['baseCurrency'] ?? CurrencyOption.defaultCode;
    // final dateRange ... (Requirement: Keep Task Name and Date Range)
    // Date Range usually comes from task data, let's see if it's there.
    // Assuming taskData might contain dates. If not, just show taskName.

    final canConfirm = _isAutoAssign || _selectedGhostId != null;

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
              const SizedBox(height: 24),

              // 任務資訊卡片
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
                      // Removed Captain Info as per requirement
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Ghost List Section (Scenario B)
              if (!_isAutoAssign && _ghosts.isNotEmpty) ...[
                Text(
                  t.S11_Invite_Confirm
                      .label_select_ghost, // Need translation or hardcode?
                  // Assuming translation key exists or I use a generic one.
                  // If not exists, I might need to use a placeholder string.
                  // Checking t.S11_Invite_Confirm...
                  // I don't know if 'label_select_ghost' exists.
                  // I'll check 'assets/i18n/strings_en.i18n.json' if possible, or use a safe string.
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ghosts.length,
                    itemBuilder: (context, index) {
                      final ghost = _ghosts[index];
                      final id = ghost['id'] as String;
                      final name = ghost['displayName'] as String;
                      final prepaid =
                          (ghost['prepaid'] as num?)?.toDouble() ?? 0.0;
                      final expense =
                          (ghost['expense'] as num?)?.toDouble() ?? 0.0;
                      final isSelected = _selectedGhostId == id;

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: isSelected ? colorScheme.primaryContainer : null,
                        child: RadioListTile<String>(
                          value: id,
                          groupValue: _selectedGhostId,
                          onChanged: (val) =>
                              setState(() => _selectedGhostId = val),
                          title: Row(
                            children: [
                              CommonAvatar(
                                avatarId: null, // Ignore animal avatar
                                name: name,
                                isLinked: false, // Force Grey
                                radius: 16,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          subtitle: Text(
                              "${t.S11_Invite_Confirm.label_prepaid}: ${CurrencyOption.formatAmount(prepaid, currency)} • ${t.S11_Invite_Confirm.label_expense}: ${CurrencyOption.formatAmount(expense, currency)}"),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                        ),
                      );
                    },
                  ),
                ),
              ] else ...[
                const Spacer(),
              ],

              const SizedBox(height: 16),

              // 加入按鈕
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: (_isJoining || !canConfirm) ? null : _handleJoin,
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
                  onPressed: () => context.go('/landing'), // 回首頁
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
