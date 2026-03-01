import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/dialogs/d11_random_result_dialog.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/presentation/widgets/retention_banner.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s17_task_locked_vm.dart';
import 'package:iron_split/features/task/presentation/views/s17_settled_view.dart';
import 'package:iron_split/features/task/presentation/views/s17_closed_view.dart';

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
        recordRepo: context.read<RecordRepository>(),
        authRepo: context.read<AuthRepository>(),
        taskService: context.read<TaskService>(),
        shareService: context.read<ShareService>(),
        exportService: context.read<ExportService>(),
        deepLinkService: context.read<DeepLinkService>(),
        settlementService: context.read<SettlementService>(),
      )..init(),
      child: const _S17Content(),
    );
  }
}

class _S17Content extends StatefulWidget {
  const _S17Content();

  @override
  State<_S17Content> createState() => _S17ContentState();
}

class _S17ContentState extends State<_S17Content> {
  bool _dialogTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = context.watch<S17TaskLockedViewModel>();

    // 👈 如果發現狀態是「任務未結算」，則發動跳轉
    if (vm.initErrorCode == AppErrorCodes.taskStatusError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 跳轉到普通的任務 Dashboard (S13)
        context.goNamed('S13', pathParameters: {'taskId': vm.taskId});
      });
    }
  }

  void _checkAndTriggerDialog(S17TaskLockedViewModel vm) {
    if (_dialogTriggered ||
        vm.initStatus != LoadStatus.success ||
        vm.task == null) {
      return; // 資料還沒好
    }

    _dialogTriggered = true; // 標記已觸發

    if (vm.shouldShowRoulette) {
      _dialogTriggered = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showRouletteDialog(vm);
      });
    }
  }

  Future<void> _showRouletteDialog(S17TaskLockedViewModel vm) async {
    // 稍微延遲，讓畫面先 Render 出來
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // 呼叫 D11
    await D11RandomResultDialog.show(
      context,
      members: vm.allMembers, // 從 VM 取得重建後的列表
      winnerId: vm.remainderWinnerId!,
    );

    // Dialog 關閉後，揭曉結果
    if (!mounted) return;
    await vm.markCurrentUserAsSeen();
  }

  Future<void> _handleExport(
      BuildContext context, S17TaskLockedViewModel vm, Translations t) async {
    final l = t.s17_task_locked.export;

    try {
      await vm.exportSettlementRecord(
        fileName:
            "${vm.taskName}_Settlement_Report_${DateTime.now().toIso8601String().split('T').first}.csv",
        subject: '${vm.taskName} Settlement Report',
        labels: {
          'reportInfo': l.report_info,
          'taskName': l.task_name,
          'exportTime': l.export_time,
          'baseCurrency': l.base_currency,
          'settlementSummary': l.settlement_summary,
          'member': l.member,
          'role': l.role,
          'netAmount': l.net_amount,
          'status': l.status,
          'receiver': l.receiver,
          'payer': l.payer,
          'cleared': l.cleared,
          'pending': l.pending,
          'fundAnalysis': l.fund_analysis,
          'totalExpense': l.total_expense,
          'totalPrepay': l.total_prepay,
          'remainderBuffer': l.remainder_buffer,
          'remainderAbsorbedBy': l.remainder_absorbed_by,
          'transactionDetails': l.transaction_details,
          'date': l.date,
          'title': l.title,
          'type': l.type,
          'origAmt': l.original_amount,
          'currency': l.currency,
          'rate': l.rate,
          'baseAmt': l.base_amount,
          'netRemainder': l.net_remainder,
          'pool': l.pool,
          'mixed': l.mixed,
        },
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleShare(
      BuildContext context, S17TaskLockedViewModel vm, Translations t) async {
    // 1. UI 負責組裝字串 (包含 DeepLink)
    final message = t.common.share.settlement.content(
      taskName: vm.taskName,
      link: vm.link,
    );

    try {
      // 2. 委派 VM 執行
      await vm.notifyMembers(
        message: message,
        subject: t.common.share.settlement.subject,
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleToggleMemberStatus(BuildContext context,
      S17TaskLockedViewModel vm, String memberId, bool isCleared) async {
    try {
      await vm.toggleMemberStatus(memberId, isCleared);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _redirectToTaskList(BuildContext context) {
    context.goNamed('S10');
  }

  void _redirectToTaskSettings(
      BuildContext context, S17TaskLockedViewModel vm) {
    context.pushNamed('S14', pathParameters: {'taskId': vm.taskId});
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 VM 狀態
    final vm = context.watch<S17TaskLockedViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final t = Translations.of(context);

    // 每次 build 都檢查是否需要觸發 Dialog
    _checkAndTriggerDialog(vm);

    Widget? content;
    if (vm.initStatus == LoadStatus.success) {
      content = switch (vm.pageType) {
        LockedPageType.closed => const S17ClosedView(),
        LockedPageType.settled => S17SettledView(
            task: vm.task,
            isCaptain: vm.isCaptain,
            balanceState: vm.balanceState!, // success 狀態下必有值
            pendingMembers: vm.pendingMembers,
            clearedMembers: vm.clearedMembers,
            onUpdateMemberStatusTap: (memberId, isCleared) =>
                _handleToggleMemberStatus(context, vm, memberId, isCleared),
          ),
      };
    }

    final leading = IconButton(
      icon: Icon(Icons.adaptive.arrow_back),
      onPressed: () => _redirectToTaskList(context),
    );

    final actions = [
      IconButton(
        icon: const Icon(Icons.settings_outlined),
        onPressed: () => _redirectToTaskSettings(context, vm),
      ),
    ];

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: vm.taskName,
      leading: leading,
      actions: actions,
      child: vm.initStatus != LoadStatus.success
          ? const SizedBox.shrink()
          : Scaffold(
              appBar: AppBar(
                title: Text(vm.taskName),
                centerTitle: true,
                leading: leading,
                actions: actions,
              ),
              extendBody: true,
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  vm.remainingDays == null
                      ? const SizedBox.shrink()
                      : RetentionBanner(days: vm.remainingDays!),
                  StickyBottomActionBar(
                    isSheetMode: false,
                    children: [
                      // 通知成員
                      AppButton(
                        text: t.s17_task_locked.buttons.notify_members,
                        type: AppButtonType.secondary,
                        isLoading: vm.shareStatus == LoadStatus.loading,
                        onPressed: () => _handleShare(context, vm, t),
                      ),
                      // 下載帳單
                      AppButton(
                        text: t.common.buttons.download,
                        type: AppButtonType.primary,
                        isLoading: vm.exportStatus == LoadStatus.loading,
                        onPressed: () => _handleExport(context, vm, t),
                      ),
                    ],
                  ),
                ],
              ),
              body: SafeArea(
                  child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                child: content,
              ))),
    );
  }
}
