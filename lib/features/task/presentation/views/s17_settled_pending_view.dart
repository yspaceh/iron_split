import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b06_payment_info_detail_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S17SettledPendingView extends StatefulWidget {
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
  State<S17SettledPendingView> createState() => _S17SettledPendingViewState();
}

class _S17SettledPendingViewState extends State<S17SettledPendingView> {
  // 0: 待處理 (Pending), 1: 已處理 (Cleared)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final settlementService = context.read<SettlementService>();
    final CurrencyConstants baseCurrency =
        CurrencyConstants.getCurrencyConstants(
            widget.balanceState.currencyCode);

    // 根據選擇決定要顯示的列表資料
    final isShowingPending = _selectedIndex == 0;
    final displayList =
        isShowingPending ? widget.pendingMembers : widget.clearedMembers;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              // 1. 頂部資訊卡 (Locked Mode)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: GroupBalanceCard(state: widget.balanceState),
              ),

              // 3. 切換按鈕 (SegmentedButton)

              CustomSlidingSegment<int>(
                selectedValue: _selectedIndex,
                onValueChanged: (int newValue) {
                  setState(() {
                    _selectedIndex = newValue;
                  });
                },
                segments: {
                  0: "${t.S17_Task_Locked.section_pending} (${widget.pendingMembers.length})", // "待處理" (不含數字，保持乾淨)
                  1: "${t.S17_Task_Locked.section_cleared} (${widget.clearedMembers.length})", // "已處理"
                },
              ),
              const SizedBox(height: 8),
              if (_selectedIndex == 0)
                // 2. 收款資訊區
                AppButton(
                  text: t.S17_Task_Locked.buttons.view_payment_details,
                  type: AppButtonType.secondary,
                  onPressed: () {
                    final currentTask = widget.task;
                    if (currentTask == null) return;

                    B06PaymentInfoDetailBottomSheet.show(context,
                        task: currentTask, isCaptain: widget.isCaptain);
                  },
                ),
              const SizedBox(height: 8),

              // 4. 動態列表區
              if (displayList.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          isShowingPending
                              ? Icons.done_all
                              : Icons.hourglass_empty,
                          size: 48,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isShowingPending
                              ? t.S17_Task_Locked.section_pending
                              : t.S17_Task_Locked.section_cleared,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (var member in displayList) ...[
                  SettlementMemberItem(
                    member: member,
                    baseCurrency: baseCurrency,
                    isActionEnabled: widget.isCaptain,
                    actionIcon: isShowingPending
                        ? Icons.check_circle_outline
                        : Icons.undo,
                    onActionTap: () {
                      settlementService.updateMemberStatus(
                        taskId: widget.taskId,
                        memberId: member.id,
                        isCleared: isShowingPending,
                      );
                    },
                  ),
                  const SizedBox(height: 12), // 這裡控制間隔高度
                ],

              const SizedBox(height: 100), // Bottom padding
            ],
          ),
        ),
      ],
    );
  }
}
