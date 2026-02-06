import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/presentation/widgets/retention_banner.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

// Services & Repos
import 'package:iron_split/features/task/data/task_repository.dart';

// VM
import 'package:iron_split/features/task/presentation/viewmodels/s17_task_locked_vm.dart';

// Views
import 'package:iron_split/features/task/presentation/views/s17_settled_pending_view.dart';
import 'package:iron_split/features/task/presentation/views/s17_status_view.dart';

/// Page Key: S17_Task.Locked
/// 負責：MVVM 綁定, 路由出口
class S17TaskLockedPage extends StatelessWidget {
  final String taskId;

  const S17TaskLockedPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => S17TaskLockedViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
      ),
      child: const _S17Content(),
    );
  }
}

class _S17Content extends StatelessWidget {
  const _S17Content();

  @override
  Widget build(BuildContext context) {
    // 監聽 VM 狀態
    final vm = context.watch<S17TaskLockedViewModel>();
    final t = Translations.of(context);

    void onDownload(BuildContext context) {
      // TODO: Implement Download Logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download (TODO)")),
      );
    }

    Future<void> onShareTap() async {
      try {
        if (context.mounted) {
          await TaskShareHelper.shareSettlement(
            context: context,
            taskId: vm.taskId,
            taskName: vm.taskName,
          );
        }
      } catch (e) {
        if (context.mounted) {
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(Translations.of(context)
                    .common
                    .error_prefix(message: e.toString()))),
          );
        }
      }
    }

    Widget content;
    switch (vm.status) {
      case LockedPageStatus.loading:
        content = const Center(child: CircularProgressIndicator());
        break;
      case LockedPageStatus.closed:
        content = const S17StatusView(pageStatus: LockedPageStatus.closed);
        break;
      case LockedPageStatus.cleared:
        content = const S17StatusView(pageStatus: LockedPageStatus.cleared);
        break;
      case LockedPageStatus.pending:
        // 將 VM 處理好的資料傳給 View
        // 注意：這裡我們確保 View 是 Dumb 的，它不需要知道 VM 的存在，只需要資料
        content = S17SettledPendingView(
          taskId: vm.taskId,
          task: vm.task,
          isCaptain: vm.isCaptain,
          balanceState: vm.balanceState!,
          pendingMembers: vm.pendingMembers,
          clearedMembers: vm.clearedMembers,
        );
        break;
      case LockedPageStatus.error:
        //TODO: Replace with Error View
        content = const Center(child: Text('Error loading task'));
        break;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(vm.taskName),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.adaptive.arrow_back),
            // S10 為 Dashboard，這是此流程的唯一出口
            onPressed: () => context.goNamed('S10'),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: vm.status == LockedPageStatus.loading ||
                vm.status == LockedPageStatus.error
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RetentionBanner(days: vm.remainingDays!),
                  StickyBottomActionBar(
                    isSheetMode: false,
                    children: [
                      // 通知成員
                      AppButton(
                        text: t.S17_Task_Locked.buttons.notify_members,
                        type: AppButtonType.secondary,
                        onPressed: onShareTap,
                      ),
                      // 下載帳單
                      AppButton(
                        text: t.S17_Task_Locked.buttons.download,
                        type: AppButtonType.primary,
                        onPressed: () => onDownload(context),
                      ),
                    ],
                  ),
                ],
              ),
        body: content);
  }
}
