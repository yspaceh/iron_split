import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b06_payment_info_detail_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S17SettledPendingView extends StatelessWidget {
  final String taskId;
  final TaskModel? task;
  final bool isCaptain;

  // 這些資料由母頁面 (S17TaskLockedPage) 傳入
  final BalanceSummaryState balanceState;
  final List<SettlementMember> pendingMembers;
  final List<SettlementMember> clearedMembers;

  const S17SettledPendingView({
    super.key,
    required this.isCaptain,
    required this.balanceState,
    required this.pendingMembers,
    required this.clearedMembers,
    this.task,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final settlementService = context.read<SettlementService>();
    final CurrencyConstants baseCurrency =
        CurrencyConstants.getCurrencyConstants(balanceState.currencyCode);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // 1. 頂部資訊卡 (Locked Mode)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GroupBalanceCard(state: balanceState),
              ),

              // 2. 收款資訊區
              AppButton(
                text: t.S17_Task_Locked.buttons.view_payment_details,
                type: AppButtonType.secondary,
                onPressed: () {
                  final currentTask = task;

                  // 3. 檢查 null
                  if (currentTask == null) {
                    // 這裡通常不會發生，因為 S17 頁面載入成功才會有按鈕
                    return;
                  }
                  B06PaymentInfoDetailBottomSheet.show(context,
                      task: currentTask, isCaptain: isCaptain);
                },
              ),

              const SizedBox(height: 24),

              // 3. 待處理區 (Pending)
              _buildSectionHeader(context, t.S17_Task_Locked.section_pending),
              if (pendingMembers.isEmpty) _buildEmptyState(context),

              ...pendingMembers.map((member) => SettlementMemberItem(
                    member: member,
                    baseCurrency: baseCurrency,
                    // 隊長權限：顯示 "勾選" 按鈕
                    isActionEnabled: isCaptain,
                    actionIcon: Icons.check_circle_outline,
                    onActionTap: () {
                      settlementService.updateMemberStatus(
                        taskId: taskId,
                        memberId: member.id,
                        isCleared: true,
                      );
                    },
                  )),

              const SizedBox(height: 24),

              // 4. 已處理區 (Processed)
              _buildSectionHeader(context, t.S17_Task_Locked.section_cleared),
              if (clearedMembers.isEmpty) _buildEmptyState(context),

              ...clearedMembers.map((member) => SettlementMemberItem(
                    member: member,
                    baseCurrency: baseCurrency,
                    // 隊長權限：顯示 "復原" 按鈕
                    isActionEnabled: isCaptain,
                    actionIcon: Icons.undo,
                    onActionTap: () {
                      settlementService.updateMemberStatus(
                        taskId: taskId,
                        memberId: member.id,
                        isCleared: false,
                      );
                    },
                  )),

              const SizedBox(height: 100), // Bottom padding for sticky bar
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          "-",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ),
    );
  }
}
