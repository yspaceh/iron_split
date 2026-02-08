import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
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
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.common.buttons.back,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          AppButton(
            text: t.S12_TaskClose_Notice.buttons.close,
            type: AppButtonType.primary,
            isLoading: vm.isProcessing,
            onPressed: () => _showConfirmDialog(context, vm),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            t.S12_TaskClose_Notice.content,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
