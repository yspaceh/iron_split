import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:iron_split/features/task/domain/services/activity_log_service.dart';
import 'package:iron_split/gen/strings.g.dart';

class S12TaskCloseNoticePage extends StatefulWidget {
  final String taskId;

  const S12TaskCloseNoticePage({super.key, required this.taskId});

  @override
  State<S12TaskCloseNoticePage> createState() => _S12TaskCloseNoticePageState();
}

class _S12TaskCloseNoticePageState extends State<S12TaskCloseNoticePage> {
  bool _isProcessing = false;

  /// 執行結束任務邏輯 (D08 確認後觸發)
  Future<void> _executeCloseTask() async {
    setState(() => _isProcessing = true);
    try {
      // 1. 更新 Firestore 狀態
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'status': 'closed',
        'closedAt': FieldValue.serverTimestamp(),
      });

      // 2. 寫入 Log
      await ActivityLogService.log(
        taskId: widget.taskId,
        action: LogAction.updateSettings, // 或新增一個 closeTask 類型
        details: {'info': 'Task Closed'},
      );

      if (!mounted) return;

      // 3. 導航回 S13 (因為 S13 會自動偵測 status=closed 切換畫面)
      // 使用 go 而不是 push，清除堆疊避免回到 S12
      context.goNamed(
        'task_dashboard', // 請確認您的 Router name
        pathParameters: {'taskId': widget.taskId},
      );
    } catch (e) {
      debugPrint("Close task failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  /// 顯示 D08 確認對話框
  void _showConfirmDialog() {
    final t = Translations.of(context);
    CommonAlertDialog.show(
      context,
      title: t.D08_TaskClosed_Confirm.title,
      content: t.D08_TaskClosed_Confirm.content,
      confirmText: t.D08_TaskClosed_Confirm.action_confirm,
      isDestructive: true, // 啟用紅色警示
      showCancel: true, // 強制顯示取消按鈕
      onConfirm: _executeCloseTask,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S12_TaskClose_Notice.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // 警示 Icon
              Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 24),

              // 標題
              Text(
                t.S12_TaskClose_Notice.title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 內文說明
              Text(
                t.S12_TaskClose_Notice.content,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // 結束按鈕
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isProcessing ? null : _showConfirmDialog,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.error), // 紅色邊框
                    foregroundColor: theme.colorScheme.error, // 紅色文字/Icon
                  ),
                  icon: _isProcessing
                      ? const SizedBox.shrink()
                      : const Icon(Icons.lock_outline),
                  label: _isProcessing
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: theme.colorScheme.error, strokeWidth: 2),
                        )
                      : Text(t.S12_TaskClose_Notice.action_close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
