import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s12_task_close_notice_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S12TaskCloseNoticePage extends StatelessWidget {
  final String taskId;

  const S12TaskCloseNoticePage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S12TaskCloseNoticeViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
      ),
      child: const _S12Content(),
    );
  }
}

class _S12Content extends StatelessWidget {
  const _S12Content();

  Future<void> _handleClose(
      BuildContext context, S12TaskCloseNoticeViewModel vm) async {
    final success = await vm.closeTask();

    if (success && context.mounted) {
      // 導航回 S13
      // 使用 goNamed 清除堆疊，避免按上一頁回到 S12
      // 假設 Router 定義 S13 的 name 為 'S13' (請確認您的 router.dart 設定)
      context.goNamed(
        'S13',
        pathParameters: {'taskId': vm.taskId},
      );
    } else if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to close task")),
      );
    }
  }

  void _showConfirmDialog(
      BuildContext context, S12TaskCloseNoticeViewModel vm) {
    final t = Translations.of(context);
    CommonAlertDialog.show(
      context,
      title: t.D08_TaskClosed_Confirm.title,
      content: Text(t.D08_TaskClosed_Confirm.content),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.D08_TaskClosed_Confirm.buttons.confirm,
          type: AppButtonType.primary,
          onPressed: () => _handleClose(context, vm),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S12TaskCloseNoticeViewModel>();

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
                  onPressed: vm.isProcessing
                      ? null
                      : () => _showConfirmDialog(context, vm),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.error), // 紅色邊框
                    foregroundColor: theme.colorScheme.error, // 紅色文字/Icon
                  ),
                  icon: vm.isProcessing
                      ? const SizedBox.shrink()
                      : const Icon(Icons.lock_outline),
                  label: vm.isProcessing
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: theme.colorScheme.error, strokeWidth: 2),
                        )
                      : Text(t.S12_TaskClose_Notice.buttons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
