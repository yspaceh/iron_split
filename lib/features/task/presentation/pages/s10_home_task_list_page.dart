import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s10_task_list_vm.dart';
import 'package:iron_split/features/task/presentation/widgets/task_list_item.dart';
import 'package:iron_split/gen/strings.g.dart';

class S10HomeTaskListPage extends StatelessWidget {
  const S10HomeTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }
    return ChangeNotifierProvider(
      create: (_) => S10TaskListViewModel(
        repo: TaskRepository(),
        currentUserId: user.uid,
      )..init(),
      child: const _S10Content(),
    );
  }
}

class _S10Content extends StatelessWidget {
  const _S10Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<S10TaskListViewModel>();

    if (vm.currentUserId.isEmpty) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S10_Home_TaskList.title),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings/tos'),
          ),
        ],
      ),
      // 還原 FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('S16'),
        icon: const Icon(Icons.add),
        label: Text(t.S16_TaskCreate_Edit.title), // 使用 S16 的標題 '建立任務'
        shape: const StadiumBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // 1. 頂部裝飾區塊 (Mascot & SegmentedButton)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // [修正] 改用 CustomSlidingSegment
            child: CustomSlidingSegment<int>(
              selectedValue: vm.filterIndex,
              onValueChanged: (val) => vm.setFilter(val),
              segments: {
                0: t.S10_Home_TaskList.tab_in_progress,
                1: t.S10_Home_TaskList.tab_completed,
              },
            ),
          ),

          // 2. 任務列表
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : vm.displayTasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assignment_outlined,
                                size: 48, color: colorScheme.outlineVariant),
                            const SizedBox(height: 16),
                            Text(
                              vm.filterIndex == 0
                                  ? t.S10_Home_TaskList.empty_in_progress
                                  : t.S10_Home_TaskList.empty_completed,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 80), // 底部留白給 FAB
                        itemCount: vm.displayTasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final task = vm.displayTasks[index];
                          // 使用 TaskListItem (已修正邏輯)
                          return TaskListItem(
                            task: task,
                            currentUserId: vm.currentUserId, // 傳入 uid 找頭像
                            isCaptain: vm.isCaptain(task),
                            onTap: () {
                              switch (task.status) {
                                case 'ongoing':
                                case 'pending':
                                  context.pushNamed('S13', pathParameters: {
                                    'taskId': task.id,
                                  });
                                  break;
                                case 'settled':
                                case 'closed':
                                  context.pushNamed('S17', pathParameters: {
                                    'taskId': task.id,
                                  });
                                  break;
                                default:
                              }
                            },
                            onDelete: () => vm.deleteTask(task.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
