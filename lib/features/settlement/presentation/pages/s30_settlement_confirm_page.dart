import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
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
    // 取得當前使用者 ID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    return ChangeNotifierProvider(
      create: (context) => S30SettlementConfirmViewModel(
        taskId: taskId,
        currentUserId: user.uid,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        dashboardService: context.read<DashboardService>(),
        settlementService: context.read<SettlementService>(),
      )..init(),
      child: const _S30Content(),
    );
  }
}

class _S30Content extends StatelessWidget {
  const _S30Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    // 使用 watch 監聽變化
    final vm = context.watch<S30SettlementConfirmViewModel>();

    // 呼叫 D09 (與 S13 邏輯一致)
    void showCurrencyPicker(
        BuildContext context, S30SettlementConfirmViewModel vm) {
      if (vm.task == null) return;

      CurrencyPickerSheet.show(
        context: context,
        initialCode: vm.task!.baseCurrency,
        onSelected: (selected) async {
          if (selected.code == vm.task!.baseCurrency) return;
          // 延遲一點讓 Sheet 關閉動畫跑完
          await Future.delayed(const Duration(milliseconds: 300));

          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
                taskId: vm.task!.id,
                newCurrency: selected,
              ),
            );
          }
        },
      );
    }

    Future<void> onRemainderRuleChange(S30SettlementConfirmViewModel vm) async {
      final task = vm.task;
      if (task == null) return;

      final List<Map<String, dynamic>> membersList =
          vm.task!.members.entries.map((e) {
        final m = e.value as Map<String, dynamic>;
        return <String, dynamic>{...m, 'id': e.key};
      }).toList();

      final result = await B01BalanceRuleEditBottomSheet.show(
        context,
        initialRule: task.remainderRule,
        initialMemberId: task.remainderAbsorberId,
        members: membersList,
        currentRemainder: vm.balanceState.remainder,
        baseCurrency: vm.baseCurrency,
      );

      if (result != null && context.mounted) {
        await vm.updateRemainderRule(result['rule'], result['memberId']);
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
      final initialMergedIds = vm.currentMergeMap[head.id] ?? [];

      // 3. 開啟 B04
      final result = await B04PaymentMergeBottomSheet.show(
        context,
        headMember: head,
        candidateMembers: candidates,
        initialMergedIds: initialMergedIds,
        baseCurrency: vm.baseCurrency,
      );

      // 4. 處理回傳結果
      if (result != null && context.mounted) {
        if (result.isEmpty) {
          vm.unmergeMembers(head.id);
        } else {
          vm.mergeMembers(head.id, result);
        }
      }
    }

    return PopScope(
      canPop: false, // 禁止直接返回，我們要自己處理
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return; // 如果系統已經處理了返回 (例如 canPop 為 true)，這裡就不重複執行

        // 1. 使用者按了實體返回鍵 -> 執行解鎖 (pending -> ongoing)
        await vm.unlockTask();

        // 2. 解鎖完成後，手動執行返回 S13
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.S30_settlement_confirm.title),
          centerTitle: true,
          // [M3]: AppBar 預設背景透明，捲動時自動染色 (Surface Tint)
          // 若要全白可設 scrolledUnderElevation: 0
          actions: [
            StepDots(currentStep: 1),
            const SizedBox(width: 24),
          ],
        ),
        body: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // [M3]: 調整 Padding 和背景，讓 Card 浮在 Surface 上
                    GroupBalanceCard(
                      isSettlement: true,
                      state: vm.balanceState,
                      onCurrencyTap: () => showCurrencyPicker(context, vm),
                      onRuleTap: vm.balanceState.remainder > 0
                          ? () => onRemainderRuleChange(vm)
                          : null,
                    ),

                    // 3. 隨機模式提示
                    if (vm.balanceState.poolBalance != 0) ...[
                      InfoBar(
                        icon: Icons.wallet_outlined,
                        text: Text(
                          "${t.S13_Task_Dashboard.section.prepay_balance}: ${CurrencyConstants.formatAmount(vm.balanceState.poolBalance, vm.baseCurrency.code)}",
                        ),
                      ),
                    ] else if (vm.remainderRule ==
                            RemainderRuleConstants.random &&
                        vm.balanceState.remainder.abs() > 0) ...[
                      InfoBar(
                        icon: Icons.savings_outlined,
                        text: Text(
                          t.S30_settlement_confirm.warning.random_reveal,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                    ],

                    // 3. 隨機模式提示
                    if (vm.remainderRule == RemainderRuleConstants.random &&
                        vm.balanceState.remainder.abs() > 0) ...[
                      InfoBar(
                        icon: Icons.savings_outlined,
                        text: Text(
                          t.S30_settlement_confirm.warning.random_reveal,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 16),
                    ],

                    // 4. 成員列表
                    Expanded(
                      child: ListView.separated(
                        // 底部留白讓最後一個項目不會被 BottomBar 擋住
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: vm.settlementMembers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
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
              onPressed: () async {
                await vm.unlockTask();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),

            // 右邊：下一步 (主要按鈕)
            AppButton(
              text: t.S30_settlement_confirm.buttons.next,
              type: AppButtonType.primary,
              onPressed: () => context.pushNamed(
                'S31',
                pathParameters: {'taskId': vm.taskId},
                extra: {
                  "checkPointPoolBalance": vm.checkPointPoolBalance,
                  "mergeMap": vm.currentMergeMap,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
