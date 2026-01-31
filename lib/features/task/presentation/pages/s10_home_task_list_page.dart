import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s10_task_list_vm.dart';
import 'package:iron_split/features/task/presentation/widgets/task_list_item.dart';
import 'package:iron_split/gen/strings.g.dart';

class S10HomeTaskListPage extends StatelessWidget {
  const S10HomeTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S10TaskListViewModel(
        repo: TaskRepository(),
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
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: Text(t.S16_TaskCreate_Edit.title), // 使用 S16 的標題 '建立任務'
        shape: const StadiumBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // 1. 頂部裝飾區塊 (Mascot & SegmentedButton)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: colorScheme.surface,
            child: Column(
              children: [
                // Mascot 區塊 (還原)
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.catching_pokemon,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.S10_Home_TaskList.mascot_preparing, // "鐵公雞準備中..."
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.outline),
                      )
                    ],
                  ),
                ),

                // Segmented Button (還原 Icon)
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: [
                      ButtonSegment(
                        value: 0,
                        label: Text(t.S10_Home_TaskList.tab_in_progress),
                        icon: const Icon(Icons.directions_run), // 還原 Icon
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text(t.S10_Home_TaskList.tab_completed),
                        icon: const Icon(Icons.done_all), // 還原 Icon
                      ),
                    ],
                    selected: {vm.filterIndex},
                    onSelectionChanged: (newSelection) {
                      vm.setFilter(newSelection.first);
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

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
                        padding: const EdgeInsets.fromLTRB(
                            16, 16, 16, 80), // 底部留白給 FAB
                        itemCount: vm.displayTasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = vm.displayTasks[index];

                          // 使用 TaskListItem (已修正邏輯)
                          return TaskListItem(
                            task: task,
                            currentUserId: vm.currentUserId, // 傳入 uid 找頭像
                            isCaptain: vm.isCaptain(task),
                            onTap: () => context.push('/tasks/${task.id}'),
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
