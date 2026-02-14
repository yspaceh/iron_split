import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
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
        shareService: context.read<ShareService>(),
        exportService: context.read<ExportService>(),
        deepLinkService: context.read<DeepLinkService>(),
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
  late S17TaskLockedViewModel _vm;
  @override
  void initState() {
    super.initState();
    _vm = context.read<S17TaskLockedViewModel>();
    _vm.addListener(_onStateChanged);
    // 監聽未登入狀態並自動跳轉
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onStateChanged();
    });
  }

  @override
  void dispose() {
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    // 處理自動導航 (如未登入)
    if (_vm.initErrorCode == AppErrorCodes.unauthorized) {
      context.goNamed('S00');
    }

    if (_vm.initStatus == LoadStatus.success &&
        _vm.pageType == LockedPageType.settled &&
        !_vm.hasSeen) {
      context
          .pushReplacementNamed('S32', pathParameters: {'taskId': _vm.taskId});
    }
  }

  @override
  Widget build(BuildContext context) {
    // 監聽 VM 狀態
    final vm = context.watch<S17TaskLockedViewModel>();
    final t = Translations.of(context);

    Future<void> handleExport(
        BuildContext context, S17TaskLockedViewModel vm) async {
      final t = Translations.of(context);
      final l = t.S17_Task_Locked.export;

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
            'totalIncome': l.total_income,
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

    Future<void> handleShare(
        BuildContext context, S17TaskLockedViewModel vm) async {
      final t = Translations.of(context);
      // 1. UI 負責組裝字串 (包含 DeepLink)
      final message = t.common.share.settlement.message(
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

    Widget content = switch (vm.pageType) {
      LockedPageType.closed => const S17ClosedView(),
      LockedPageType.settled => S17SettledView(
          taskId: vm.taskId,
          task: vm.task,
          isCaptain: vm.isCaptain,
          balanceState: vm.balanceState!, // success 狀態下必有值
          pendingMembers: vm.pendingMembers,
          clearedMembers: vm.clearedMembers,
        ),
    };

    final leading = IconButton(
      icon: Icon(Icons.adaptive.arrow_back),
      // S10 為 Dashboard，這是此流程的唯一出口
      onPressed: () => context.goNamed('S10'),
    );

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: vm.taskName,
      leading: leading,
      child: Scaffold(
          appBar: AppBar(
            title: Text(vm.taskName),
            centerTitle: true,
            leading: leading,
          ),
          extendBody: true,
          bottomNavigationBar: Column(
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
                    onPressed: () => handleShare(context, vm),
                  ),
                  // 下載帳單
                  AppButton(
                    text: t.S17_Task_Locked.buttons.download,
                    type: AppButtonType.primary,
                    onPressed: () => handleExport(context, vm),
                  ),
                ],
              ),
            ],
          ),
          body: content),
    );
  }
}
