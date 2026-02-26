import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b06_payment_info_detail_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/settlement_member_item.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S17SettledView extends StatefulWidget {
  final TaskModel? task;
  final bool isCaptain;

  // 這些資料由母頁面 (S17TaskLockedPage) 傳入
  final BalanceSummaryState balanceState;
  final List<SettlementMember> pendingMembers;
  final List<SettlementMember> clearedMembers;
  final Future<void> Function(String memberId, bool isCleared)
      onUpdateMemberStatusTap;

  const S17SettledView({
    super.key,
    required this.isCaptain,
    required this.balanceState,
    required this.pendingMembers,
    required this.clearedMembers,
    this.task,
    required this.onUpdateMemberStatusTap,
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
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final CurrencyConstants baseCurrency =
        CurrencyConstants.getCurrencyConstants(
            widget.balanceState.currencyCode);

    // 根據選擇決定要顯示的列表資料
    final isShowingPending = _selectedIndex == 0;
    final displayList =
        isShowingPending ? widget.pendingMembers : widget.clearedMembers;
    final cardWidget = GroupBalanceCard(
      state: widget.balanceState,
      isSettlement: true,
      isEnlarged: isEnlarged,
    );
    final segmentWidget = ExcludeSemantics(
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
    );
    final paymentInfoWidget = InkWell(
      onTap: () {
        final currentTask = widget.task;
        if (currentTask == null) return;

        B06PaymentInfoDetailBottomSheet.show(context,
            task: currentTask, isCaptain: widget.isCaptain);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppLayout.spaceL, vertical: AppLayout.spaceM),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.3), // 使用變數
          borderRadius: BorderRadius.circular(AppLayout.radiusL),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5), // 使用變數
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.S17_Task_Locked.buttons.view_payment_info,
              style:
                  textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            ),
            Icon(
              Icons.keyboard_arrow_right_outlined,
              size: AppLayout.inlineIconSize(isEnlarged),
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );

    return isEnlarged
        ? ListView(
            padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceM),
            children: [
              cardWidget,
              const SizedBox(height: AppLayout.spaceL),
              segmentWidget,
              const SizedBox(height: AppLayout.spaceL),
              if (_selectedIndex == 0 && displayList.isNotEmpty) ...[
                paymentInfoWidget,
                const SizedBox(height: AppLayout.spaceL),
              ],

              for (var member in displayList) ...[
                SettlementMemberItem(
                  member: member,
                  baseCurrency: baseCurrency,
                  isActionEnabled: widget.isCaptain,
                  actionIcon: isShowingPending
                      ? Icons.check_rounded
                      : Icons.undo_rounded,
                  onActionTap: () => widget.onUpdateMemberStatusTap(
                      member.memberData.id, isShowingPending),
                ),
                const SizedBox(height: AppLayout.spaceL), // 這裡控制間隔高度
              ],

              const SizedBox(height: 80), // Bottom padding
            ],
          )
        : Column(
            children: [
              cardWidget,
              const SizedBox(height: AppLayout.spaceL),
              segmentWidget,
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppLayout.spaceM),
                  children: [
                    if (_selectedIndex == 0 && displayList.isNotEmpty) ...[
                      paymentInfoWidget,
                      SizedBox(
                          height:
                              isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                    ],

                    for (var member in displayList) ...[
                      SettlementMemberItem(
                        member: member,
                        baseCurrency: baseCurrency,
                        isActionEnabled: widget.isCaptain,
                        actionIcon: isShowingPending
                            ? Icons.check_rounded
                            : Icons.undo_rounded,
                        onActionTap: () => widget.onUpdateMemberStatusTap(
                          member.memberData.id,
                          isShowingPending,
                        ),
                      ),
                      SizedBox(
                          height:
                              isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                    ],

                    const SizedBox(height: 32), // Bottom padding
                  ],
                ),
              ),
            ],
          );
  }
}
