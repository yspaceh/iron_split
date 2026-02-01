import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/s30_settlement_confirm_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/settlement/presentation/widgets/step_indicator.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';

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

      // 修正這裡
      final List<Map<String, dynamic>> membersList =
          vm.task!.members.entries.map((e) {
        final m = e.value as Map<String, dynamic>;
        return <String, dynamic>{...m, 'id': e.key};
      }).toList();

      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        builder: (context) => B01BalanceRuleEditBottomSheet(
          initialRule: task.remainderRule,
          initialMemberId: task.remainderAbsorberId,
          members: membersList,
        ),
      );

      if (result != null && context.mounted) {
        await vm.updateRemainderRule(result['rule'], result['memberId']);
      }
    }

    void _showMergeSettings(
        BuildContext context, S30SettlementConfirmViewModel vm) {
      // TODO: 呼叫 B04 (省略實作)
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(t.s30_settlement_confirm.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 1. 步驟指示器
                const StepIndicator(currentStep: 1),

                // 2. 總覽卡片
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GroupBalanceCard(
                        state: vm.balanceState, // 使用 VM 的 State
                        onCurrencyTap: () => showCurrencyPicker(context, vm),
                        onRuleTap: () => onRemainderRuleChange(vm),
                      ),
                    ),
                  ),
                ),

                // 3. 隨機模式提示
                if (vm.remainderRule == RemainderRuleConstants.random)
                  Container(
                    width: double.infinity,
                    color: Colors.amber[50],
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.casino, size: 16, color: Colors.amber[900]),
                        const SizedBox(width: 8),
                        Text(
                          t.s30_settlement_confirm.warning.random_reveal,
                          style:
                              TextStyle(color: Colors.amber[900], fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                // 4. 成員列表
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: vm.settlementMembers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final member = vm.settlementMembers[index];
                      return SettlementMemberItem(
                        member: member,
                        baseCurrency: vm.baseCurrency,
                        onMergeTap: () => _showMergeSettings(context, vm),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          // 左邊：取消 (次要按鈕)
          AppButton(
            text: t.common.cancel,
            type: AppButtonType.secondary,
            onPressed: () => Navigator.pop(context),
          ),

          // 右邊：下一步 (主要按鈕)
          AppButton(
            text: t.s30_settlement_confirm.action_next,
            type: AppButtonType.primary,
            onPressed: () => context.pushNamed('S31'),
          ),
        ],
      ),
    );
  }
}
