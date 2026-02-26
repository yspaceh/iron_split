import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
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
        taskRepo: context.read<TaskRepository>(),
        authRepo: context.read<AuthRepository>(),
        service: context.read<TaskService>(),
      )..init(),
      child: const _S10Content(),
    );
  }
}

class _S10Content extends StatelessWidget {
  const _S10Content();

  void _handleSwitchSegmentedIndex(S10TaskListViewModel vm, int index) {
    vm.setSegmentedIndex(index);
  }

  void _redirectToTask(
      BuildContext context, S10TaskListViewModel vm, TaskModel task) {
    final nav = vm.getNavigationInfo(task);
    context.pushNamed(nav.routeName, pathParameters: nav.params);
  }

  void _redirectToJoinTask(BuildContext context) {
    context.pushNamed('S18');
  }

  void _redirectToCreateTask(BuildContext context) {
    context.pushNamed('S16');
  }

  void _redirectToSystemSettings(BuildContext context) {
    context.pushNamed('S70');
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S10TaskListViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.S10_Home_TaskList.title;
    final actions = [
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => _redirectToSystemSettings(context),
      ),
    ];

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      actions: actions,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: actions,
        ),
        bottomNavigationBar: StickyBottomActionBar(
          isSheetMode: false,
          children: [
            AppButton(
              text: t.S10_Home_TaskList.buttons.join_task,
              type: AppButtonType.secondary,
              onPressed: () => _redirectToJoinTask(context),
            ),
            AppButton(
              text: t.S10_Home_TaskList.buttons.add_task,
              type: AppButtonType.primary,
              onPressed: () => _redirectToCreateTask(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Column(
              children: [
                // 1. 頂部裝飾區塊 (Mascot & SegmentedButton)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppLayout.spaceS),
                  // [修正] 改用 CustomSlidingSegment
                  child: CustomSlidingSegment<int>(
                    selectedValue: vm.segmentedIndex,
                    onValueChanged: (val) =>
                        _handleSwitchSegmentedIndex(vm, val),
                    segments: {
                      0: t.S10_Home_TaskList.tab.in_progress,
                      1: t.S10_Home_TaskList.tab.completed,
                    },
                  ),
                ),

                // 2. 任務列表
                Expanded(
                  child: vm.displayTasks.isEmpty
                      ? Center(
                          child: Text(
                            vm.segmentedIndex == 0
                                ? t.S10_Home_TaskList.empty.in_progress
                                : t.S10_Home_TaskList.empty.completed,
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                              top: AppLayout.spaceS, bottom: 32),
                          itemCount: vm.displayTasks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppLayout.spaceXS),
                          itemBuilder: (context, index) {
                            final task = vm.displayTasks[index];
                            return TaskListItem(
                              task: task,
                              currentUserId: vm.currentUserId, // 傳入 uid 找頭像
                              isCaptain: vm.isCaptain(task),
                              onTap: () => _redirectToTask(context, vm, task),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
