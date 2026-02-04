import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    // 1. 注入 ViewModel
    return ChangeNotifierProvider(
      create: (_) => S13TaskDashboardViewModel(
        taskId: taskId,
        currentUserId: user.uid,
        taskRepo: TaskRepository(),
        recordRepo: RecordRepository(),
        service: DashboardService(),
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
  bool _isShowingIntro = false;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 監聽 ViewModel
    final vm = context.watch<S13TaskDashboardViewModel>();

    // 取得當前 Tab Index
    final int currentTabIndex = vm.currentTabIndex;

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.task == null) {
      return const Scaffold(body: Center(child: Text("Task not found")));
    }

    // 2. Intro Logic (移植)
    // 檢查 VM 狀態，決定是否顯示彈窗
    if (vm.shouldShowIntro && !_isShowingIntro) {
      _isShowingIntro = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        // 取得當前成員資料傳給 Dialog
        final memberData = vm.task!.members[vm.currentUserId];
        if (memberData == null) return;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => D01MemberRoleIntroDialog(
            taskId: vm.taskId,
            initialAvatar: memberData['avatar'] ?? 'cow',
            canReroll: true,
          ),
        );
        if (mounted) {
          setState(() => _isShowingIntro = false);
        }
      });
    }

    // 3. Data Preparation (從 VM 獲取)
    final taskName = vm.task!.name;
    final isCaptain = vm.isCaptain;
    final poolBalances = vm.poolBalances;
    final baseCurrency = vm.baseCurrency;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
            taskName.isNotEmpty ? taskName : t.S13_Task_Dashboard.title_active),
        // 新增：智慧導航按鈕
        leading: Navigator.of(context).canPop()
            ? null // null 代表使用預設的「返回箭頭」 (因為有上一頁)
            : IconButton(
                icon: Icon(Icons.adaptive.arrow_back), // 沒有上一頁時，顯示「回首頁」
                onPressed: () {
                  context.goNamed('S10');
                },
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.pushNamed('S14', pathParameters: {'taskId': vm.taskId});
            },
          ),
        ],
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          Visibility(
            visible: isCaptain,
            child: AppButton(
                text: t.S13_Task_Dashboard.buttons.settlement,
                type: AppButtonType.secondary,
                onPressed: () async {
                  // 1. 先鎖定
                  final success = await vm.lockTaskAndStartSettlement();

                  if (success && context.mounted) {
                    // 2. 成功後才跳轉 S30
                    context.pushNamed(
                      'S30',
                      pathParameters: {'taskId': vm.taskId},
                    );
                  }
                }),
          ),
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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: [
                  ButtonSegment(
                      value: 0,
                      label: Text(t.S13_Task_Dashboard.tab_group),
                      icon: const Icon(Icons.groups)),
                  ButtonSegment(
                      value: 1,
                      label: Text(t.S13_Task_Dashboard.tab_personal),
                      icon: const Icon(Icons.person)),
                ],
                selected: {currentTabIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  // 通知 VM 切換，VM 會負責更新 currentTabIndex 並觸發自動捲動檢查
                  vm.setTabIndex(newSelection.first);
                },
                showSelectedIcon: false,
              ),
            ),
          ),

          // Content Switcher
          Expanded(
            child: currentTabIndex == 0
                // S13GroupView (重構後不需傳參數，直接吃 Provider)
                ? const S13GroupView()
                // S13PersonalView (重構後不需傳參數，直接吃 Provider)
                : const S13PersonalView(),
          ),
        ],
      ),
    );
  }
}
