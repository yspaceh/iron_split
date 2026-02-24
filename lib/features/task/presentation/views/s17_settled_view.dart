import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b06_payment_info_detail_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S17SettledView extends StatefulWidget {
  final String taskId;
  final TaskModel? task;
  final bool isCaptain;

  // 這些資料由母頁面 (S17TaskLockedPage) 傳入
  final BalanceSummaryState balanceState;
  final List<SettlementMember> pendingMembers;
  final List<SettlementMember> clearedMembers;

  const S17SettledView({
    super.key,
    required this.isCaptain,
    required this.balanceState,
    required this.pendingMembers,
    required this.clearedMembers,
    this.task,
    required this.taskId,
  });

  @override
  State<S17SettledView> createState() => _S17SettledViewState();
}

class _S17SettledViewState extends State<S17SettledView> {
  // 0: 待處理 (Pending), 1: 已處理 (Cleared)
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
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
        // 1. 頂部資訊卡 (Locked Mode)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GroupBalanceCard(
            state: widget.balanceState,
            isSettlement: true,
          ),
        ),

        const SizedBox(height: 16),

        // 3. 切換按鈕 (SegmentedButton)
        ExcludeSemantics(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomSlidingSegment<int>(
              selectedValue: _selectedIndex,
              onValueChanged: (int newValue) {
                setState(() {
                  _selectedIndex = newValue;
                });
              },
              segments: {
                0: "${t.S17_Task_Locked.section.pending} (${widget.pendingMembers.length})", // "待處理" (不含數字，保持乾淨)
                1: "${t.S17_Task_Locked.section.cleared} (${widget.clearedMembers.length})", // "已處理"
              },
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              if (_selectedIndex == 0 && displayList.isNotEmpty) ...[
                InkWell(
                  onTap: () {
                    final currentTask = widget.task;
                    if (currentTask == null) return;

                    B06PaymentInfoDetailBottomSheet.show(context,
                        task: currentTask, isCaptain: widget.isCaptain);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3), // 使用變數
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant
                            .withValues(alpha: 0.5), // 使用變數
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.S17_Task_Locked.buttons.view_payment_info,
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],

              for (var member in displayList) ...[
                SettlementMemberItem(
                  member: member,
                  baseCurrency: baseCurrency,
                  isActionEnabled: widget.isCaptain,
                  actionIcon: isShowingPending
                      ? Icons.check_rounded
                      : Icons.undo_rounded,
                  onActionTap: () {
                    settlementService.updateMemberStatus(
                      taskId: widget.taskId,
                      memberId: member.memberData.id,
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
