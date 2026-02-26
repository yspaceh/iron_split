import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b04_payment_merge_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/step_dots.dart';
import 'package:provider/provider.dart';

// Core & Models
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/gen/strings.g.dart';

// Repos & Services
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';

// ViewModels
import 'package:iron_split/features/settlement/presentation/viewmodels/s30_settlement_confirm_vm.dart';

// Widgets - Common
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';

// Widgets - Feature Specific
import 'package:iron_split/features/task/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';

class S30SettlementConfirmPage extends StatelessWidget {
  final String taskId;

  const S30SettlementConfirmPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => S30SettlementConfirmViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        authRepo: context.read<AuthRepository>(),
        dashboardService: context.read<DashboardService>(),
        settlementService: context.read<SettlementService>(),
      )..init(),
      child: const _S30Content(),
    );
  }
}

class _S30Content extends StatelessWidget {
  const _S30Content();

  // 呼叫 D09 (與 S13 邏輯一致)
  void _showCurrencyPicker(BuildContext context,
      S30SettlementConfirmViewModel vm, double horizontalMargin) {
    if (vm.task == null) return;

    CurrencyPickerSheet.show(
      context: context,
      initialCode: vm.task!.baseCurrency,
      onSelected: (selected) async {
        if (selected.code == vm.task!.baseCurrency) return;
        // 延遲一點讓 Sheet 關閉動畫跑完
        await Future.delayed(const Duration(milliseconds: 300));

        if (!context.mounted) return;
        D09TaskSettingsCurrencyConfirmDialog.show(context,
            taskId: vm.task!.id, newCurrency: selected);
      },
    );
  }

  Future<void> _showRemainderRuleChangeBottomSheet(
      BuildContext context, S30SettlementConfirmViewModel vm) async {
    final task = vm.task;
    if (task == null) return;
    final result = await B01BalanceRuleEditBottomSheet.show(
      context,
      initialRule: task.remainderRule,
      initialMemberId: task.remainderAbsorberId,
      members: task.sortedMembersList,
      currentRemainder: vm.balanceState.remainder,
      baseCurrency: vm.baseCurrency,
    );
    if (result != null && context.mounted) {
      await _handleRemainderRuleChange(context, vm, result);
    }
  }

  Future<void> _handleRemainderRuleChange(BuildContext context,
      S30SettlementConfirmViewModel vm, Map<String, dynamic> result) async {
    try {
      await vm.updateRemainderRule(result['rule'], result['memberId']);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleUnlock(
      BuildContext context, S30SettlementConfirmViewModel vm) async {
    try {
      await vm.unlockTask();
      if (!context.mounted) return;
      context.pop();
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleMergeMembers(
      BuildContext context,
      S30SettlementConfirmViewModel vm,
      SettlementMember head,
      List<String> result) async {
    try {
      vm.mergeMembers(head.memberData.id, result);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleUnmergeMembers(BuildContext context,
      S30SettlementConfirmViewModel vm, SettlementMember head) async {
    try {
      vm.unmergeMembers(head.memberData.id);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  // B04 合併設定邏輯實作
  Future<void> _showMergeSettings(
    BuildContext context,
    S30SettlementConfirmViewModel vm,
    SettlementMember head,
  ) async {
    // 1. 過濾候選名單
    final candidates = vm.getMergeCandidates(head);

    // 2. 取得目前已經合併在該 Head 底下的 ID
    final initialMergedIds = vm.currentMergeMap[head.memberData.id] ?? [];

    // 3. 開啟 B04
    final result = await B04PaymentMergeBottomSheet.show(
      context,
      headMember: head,
      candidateMembers: candidates,
      initialMergedIds: initialMergedIds,
      baseCurrency: vm.baseCurrency,
    );

    // 4. 處理回傳結果
    if (result == null || !context.mounted) return;
    if (result.isEmpty) {
      _handleUnmergeMembers(context, vm, head);
    } else {
      _handleMergeMembers(context, vm, head, result);
    }
  }

  void _redirectToPaymentInfo(
      BuildContext context, S30SettlementConfirmViewModel vm) {
    context.pushNamed(
      'S31',
      pathParameters: {'taskId': vm.taskId},
      extra: {
        "checkPointPoolBalance": vm.checkPointPoolBalance,
        "mergeMap": vm.currentMergeMap,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S30SettlementConfirmViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.S30_settlement_confirm.title;
    final headerSection = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GroupBalanceCard(
          isSettlement: true,
          state: vm.balanceState,
          onCurrencyTap: () =>
              _showCurrencyPicker(context, vm, horizontalMargin),
          onRuleTap: vm.balanceState.remainder > 0
              ? () => _showRemainderRuleChangeBottomSheet(context, vm)
              : null,
          isEnlarged: isEnlarged,
        ),
        vm.balanceState.poolBalance != 0
            ? InfoBar(
                icon: Icons.wallet_outlined,
                text: Text(
                  "${t.S13_Task_Dashboard.section.prepay_balance}: ${CurrencyConstants.formatAmount(vm.balanceState.poolBalance, vm.baseCurrency.code)}",
                ),
              )
            : vm.remainderRule == RemainderRuleConstants.random &&
                    vm.balanceState.remainder.abs() > 0
                ? Container()
                : const SizedBox(height: AppLayout.spaceL),
        vm.remainderRule == RemainderRuleConstants.random &&
                vm.balanceState.remainder.abs() > 0
            ? InfoBar(
                icon: Icons.savings_outlined,
                text: Text(
                  t.S30_settlement_confirm.warning.random_reveal,
                ),
              )
            : const SizedBox(height: AppLayout.spaceL)
      ],
    );

    return PopScope(
      canPop: false, // 禁止直接返回，我們要自己處理
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return; // 如果系統已經處理了返回 (例如 canPop 為 true)，這裡就不重複執行
        _handleUnlock(context, vm);
      },
      child: CommonStateView(
        status: vm.initStatus,
        errorCode: vm.initErrorCode,
        title: title,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: [
              StepDots(
                currentStep: 1,
                isEnlarged: isEnlarged,
              ),
              const SizedBox(width: AppLayout.spaceXXL),
            ],
          ),
          body: isEnlarged
              ? ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  children: [
                    headerSection,
                    // 把 List 直接展開塞進去
                    ...vm.settlementMembers.map((member) {
                      final candidates = vm.getMergeCandidates(member);
                      final bool canMerge = candidates.isNotEmpty;
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: isEnlarged
                                ? AppLayout.spaceL
                                : AppLayout.spaceS),
                        child: SettlementMemberItem(
                          member: member,
                          baseCurrency: vm.baseCurrency,
                          isActionEnabled: canMerge,
                          onActionTap: () =>
                              _showMergeSettings(context, vm, member),
                        ),
                      );
                    }),
                    const SizedBox(height: AppLayout.spaceXXL),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  child: Column(
                    children: [
                      headerSection,
                      // 4. 成員列表
                      Expanded(
                        child: ListView.separated(
                          // 底部留白讓最後一個項目不會被 BottomBar 擋住
                          padding:
                              const EdgeInsets.only(bottom: AppLayout.spaceXXL),
                          itemCount: vm.settlementMembers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppLayout.spaceS),
                          itemBuilder: (context, index) {
                            final member = vm.settlementMembers[index];

                            //  檢查是否有候選人
                            final candidates = vm.getMergeCandidates(member);
                            final bool canMerge = candidates.isNotEmpty;
                            return SettlementMemberItem(
                              member: member,
                              baseCurrency: vm.baseCurrency,
                              isActionEnabled: canMerge,
                              onActionTap: () =>
                                  _showMergeSettings(context, vm, member),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: StickyBottomActionBar(
            children: [
              // 左邊：取消 (次要按鈕)
              AppButton(
                text: t.common.buttons.cancel,
                type: AppButtonType.secondary,
                onPressed: () => _handleUnlock(context, vm),
              ),

              // 右邊：下一步 (主要按鈕)
              AppButton(
                text: t.S30_settlement_confirm.buttons.set_payment_info,
                type: AppButtonType.primary,
                onPressed: () => _redirectToPaymentInfo(context, vm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
