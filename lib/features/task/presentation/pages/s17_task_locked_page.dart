import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          taskName: vm.taskName,
          isCaptain: vm.isCaptain,
          balanceState: vm.balanceState!,
          pendingMembers: vm.pendingMembers,
          clearedMembers: vm.clearedMembers,
        );
        break;
      case LockedPageStatus.error:
        content = const Center(child: Text('Error loading task'));
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.taskName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          // S10 為 Dashboard，這是此流程的唯一出口
          onPressed: () => context.goNamed('S10'),
        ),
      ),
      body: content,
    );
  }
}
