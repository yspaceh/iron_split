import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s13_task_dashboard_vm.dart';
import 'package:iron_split/features/task/presentation/views/s13_group_view.dart';
import 'package:iron_split/features/task/presentation/views/s13_personal_view.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

class S13TaskDashboardPage extends StatelessWidget {
  final String taskId;

  const S13TaskDashboardPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    // 1. 注入 ViewModel
    return ChangeNotifierProvider(
      create: (_) => S13TaskDashboardViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        authRepo: context.read<AuthRepository>(),
        service: context.read<DashboardService>(),
      )..init(),
      child: const _S13Content(),
    );
  }
}

class _S13Content extends StatefulWidget {
  const _S13Content();

  @override
  State<_S13Content> createState() => _S13ContentState();
}

class _S13ContentState extends State<_S13Content> {
  late S13TaskDashboardViewModel _vm;
  @override
  void initState() {
    super.initState();
    _vm = context.read<S13TaskDashboardViewModel>();
    _vm.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onStateChanged();
    });
  }

  @override
  void dispose() {
    // 記得移除監聽
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;

    // 自動轉向 S00 (未登入)
    if (_vm.initErrorCode == AppErrorCodes.unauthorized) {
      context.goNamed('S00');
      return;
    }

    // 處理結算自動跳轉
    if (_vm.shouldNavigateToS17) {
      context
          .pushReplacementNamed('S17', pathParameters: {'taskId': _vm.taskId});
      return; // 跳轉了就不用管後面的
    }

    // 2. 處理 Intro 彈窗 (VM 會判斷 hasSeenRoleIntro)
    if (_vm.shouldShowIntro) {
      final memberData = _vm.task!.members[_vm.currentUserId];
      if (memberData == null) return;

      // 顯示彈窗
      D01MemberRoleIntroDialog.show(context,
          taskId: _vm.taskId,
          initialAvatar: memberData['avatar'] ?? AvatarConstants.defaultAvatar,
          canReroll: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    // 監聽 ViewModel
    final vm = context.watch<S13TaskDashboardViewModel>();

    // 3. Data Preparation (從 VM 獲取)
    final isCaptain = vm.isCaptain;
    final poolBalances = vm.poolBalances;
    final baseCurrency = vm.baseCurrency;
    final leading = IconButton(
      icon: Icon(Icons.adaptive.arrow_back), // 沒有上一頁時，顯示「回首頁」
      onPressed: () {
        context.goNamed('S10');
      },
    );
    final actions = [
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () {
          context.pushNamed('S14', pathParameters: {'taskId': vm.taskId});
        },
      ),
    ];

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: vm.task?.name ?? t.S13_Task_Dashboard.title,
      leading: leading,
      actions: actions,
      child: Scaffold(
        appBar: AppBar(
          title: Text(vm.task?.name ?? t.S13_Task_Dashboard.title),
          centerTitle: true,
          leading: leading,
          actions: actions,
        ),
        extendBody: true,
        bottomNavigationBar: StickyBottomActionBar(
          isSheetMode: false,
          children: [
            if (isCaptain) ...[
              AppButton(
                  text: t.S13_Task_Dashboard.buttons.settlement,
                  type: AppButtonType.secondary,
                  onPressed: () async {
                    try {
                      await vm.lockTaskAndStartSettlement();
                      if (context.mounted) {
                        // 2. 成功後才跳轉 S30
                        context.pushNamed(
                          'S30',
                          pathParameters: {'taskId': vm.taskId},
                        );
                      }
                    } on AppErrorCodes catch (code) {
                      if (!context.mounted) return;

                      final msg = ErrorMapper.map(context, code: code);

                      AppToast.showError(context, msg);
                    }
                    // 1. 先鎖定
                  }),
            ],
            AppButton(
              text: t.S13_Task_Dashboard.buttons.record,
              type: AppButtonType.primary,
              icon: Icons.add,
              onPressed: () => context.pushNamed(
                'S15',
                pathParameters: {'taskId': vm.taskId},
                extra: {
                  'poolBalancesByCurrency': poolBalances,
                  'baseCurrency': baseCurrency,
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Segmented Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // [修正] 改用 CustomSlidingSegment
              child: CustomSlidingSegment<int>(
                selectedValue: vm.currentTabIndex,
                onValueChanged: (val) => vm.setTabIndex(val),
                segments: {
                  0: t.S13_Task_Dashboard.tab.group,
                  1: t.S13_Task_Dashboard.tab.personal,
                },
              ),
            ),

            // Content Switcher
            Expanded(
              child: vm.currentTabIndex == 0
                  // S13GroupView (重構後不需傳參數，直接吃 Provider)
                  ? const S13GroupView()
                  // S13PersonalView (重構後不需傳參數，直接吃 Provider)
                  : const S13PersonalView(),
            ),
          ],
        ),
      ),
    );
  }
}
