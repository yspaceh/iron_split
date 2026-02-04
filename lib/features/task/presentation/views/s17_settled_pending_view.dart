import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S17SettledPendingView extends StatelessWidget {
  final String taskId;
  final String taskName;
  final bool isCaptain;

  // 這些資料由母頁面 (S17TaskLockedPage) 傳入
  final BalanceSummaryState balanceState;
  final List<SettlementMember> pendingMembers;
  final List<SettlementMember> clearedMembers;

  const S17SettledPendingView({
    super.key,
    required this.taskId,
    required this.isCaptain,
    required this.balanceState,
    required this.pendingMembers,
    required this.clearedMembers,
    required this.taskName,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final settlementService = context.read<SettlementService>();
    final CurrencyConstants baseCurrency =
        CurrencyConstants.getCurrencyConstants(balanceState.currencyCode);

    Future<void> onShareTap() async {
      try {
        if (context.mounted) {
          await TaskShareHelper.shareSettlement(
            context: context,
            taskId: taskId,
            taskName: taskName,
          );
        }
      } catch (e) {
        if (context.mounted) {
          debugPrint(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(Translations.of(context)
                    .common
                    .error_prefix(message: e.toString()))),
          );
        }
      }
    }

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
                onPressed: onShareTap,
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
                      //TODO: B06
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

        // 5. 底部按鈕區
        StickyBottomActionBar(
          children: [
            // 通知成員
            AppButton(
              text: t.S17_Task_Locked.buttons.notify_members,
              type: AppButtonType.secondary,
              onPressed: onShareTap,
            ),
            // 下載帳單
            AppButton(
              text: t.S17_Task_Locked.buttons.download,
              type: AppButtonType.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  // TODO: Add logic
                  const SnackBar(
                      content: Text('Feature coming soon: PDF Export')),
                );
              },
            ),
          ],
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
