import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_info_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/widgets/daily_header.dart';
import 'package:iron_split/features/task/presentation/widgets/record_item.dart';
import 'package:iron_split/features/common/presentation/widgets/group_balance_card.dart';
import 'package:iron_split/features/task/presentation/widgets/sticky_header_delegate.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s13_task_dashboard_vm.dart';

class S13GroupView extends StatelessWidget {
  const S13GroupView({super.key});

  /// ! CRITICAL LAYOUT CONFIGURATION !
  /// Used by S13Page to calculate Sticky Header size.
  static const double _kCardHeight = 176.0;
  static const double _kDateStripHeightStandard = 56.0;
  static const double _kDateStripHeightEnlarged = 96.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<S13TaskDashboardViewModel>();
    final theme = Theme.of(context);
    final task = vm.task;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final double dateStripHeight =
        isEnlarged ? _kDateStripHeightEnlarged : _kDateStripHeightStandard;

    if (task == null) return const Center(child: CircularProgressIndicator());

    Future<void> onRemainderRuleChange(S13TaskDashboardViewModel vm) async {
      final task = vm.task;
      if (task == null) return;

      final List<TaskMember> membersList =
          task.members.entries.map((m) => m.value).toList();

      final result = await B01BalanceRuleEditBottomSheet.show(context,
          initialRule: task.remainderRule,
          initialMemberId: task.remainderAbsorberId,
          members: membersList,
          currentRemainder: vm.balanceState.remainder,
          baseCurrency: vm.baseCurrency);

      if (result != null && context.mounted) {
        await vm.updateRemainderRule(result['rule'], result['memberId']);
      }
    }

    void showCurrencyPicker() {
      CurrencyPickerSheet.show(
        context: context,
        initialCode: task.baseCurrency,
        onSelected: (selected) async {
          if (selected.code == task.baseCurrency) return;
          await Future.delayed(const Duration(milliseconds: 300));

          if (context.mounted) {
            D09TaskSettingsCurrencyConfirmDialog.show(context,
                taskId: task.id, newCurrency: selected);
          }
        },
      );
    }

    // 1. 將卡片內容獨立出來，讓兩種 Sliver 共用
    final Widget balanceCardWidget = Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: GroupBalanceCard(
          state: vm.balanceState, // 使用 VM 的 State
          onCurrencyTap: showCurrencyPicker,
          onRuleTap: () => onRemainderRuleChange(vm),
          fixedHeight: isEnlarged ? null : _kCardHeight,
          isEnlarged: isEnlarged,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomPadding = constraints.maxHeight;

        return CustomScrollView(
          controller: vm.groupScrollController,
          slivers: [
            // Sticky Header 1 (Card)
            if (!isEnlarged) ...[
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  height: _kCardHeight,
                  child: SizedBox(
                    height: _kCardHeight,
                    child: balanceCardWidget,
                  ),
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: balanceCardWidget,
              ),
            ],

            // Sticky Header 2 (Date Strip)
            SliverPersistentHeader(
              pinned: true,
              delegate: CommonDateStripDelegate(
                height: dateStripHeight,
                startDate: task.startDate ?? DateTime.now(),
                endDate: task.endDate ?? DateTime.now(),
                selectedDate: vm.selectedDateInStrip,
                onDateSelected: (date) {
                  vm.scrollRecord(date, onNoResult: () {
                    D05DateJumpNoResultDialog.show(context,
                        targetDate: date, taskId: task.id);
                  });
                },
                isEnlarged: isEnlarged,
              ),
            ),

            // Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.toSet().map((date) {
                  final dayRecords = vm.groupedRecords[date] ?? [];
                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  final key = vm.dateKeys[dateKeyStr];

                  return Column(
                    key: key,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeader(
                        date: date,
                        onAddTap: () => context.pushNamed(
                          'S15',
                          pathParameters: {'taskId': task.id},
                          extra: {
                            'poolBalancesByCurrency': vm.poolBalances,
                            'baseCurrency': vm.baseCurrency,
                            'date': date,
                          },
                        ),
                      ),
                      ...dayRecords.map((record) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppLayout.spaceL),
                          child: RecordItem(
                            record: record,
                            baseCurrency: vm.baseCurrency,
                            amount: DualAmount(
                                original: record.amount,
                                base: record.amount * record.exchangeRate),
                            onTap: () {
                              context.pushNamed(
                                'S15',
                                pathParameters: {'taskId': task.id},
                                queryParameters: {'id': record.id},
                                extra: {
                                  // 需要帶過去的資料由這裡決定，RecordItem 不用當搬運工
                                  'poolBalancesByCurrency': vm.poolBalances,
                                  'baseCurrency': vm.baseCurrency,
                                  'record': record,
                                },
                              );
                            },
                            onDelete: (ctx) async {
                              // 呼叫 Repo 進行刪除
                              try {
                                await vm.deleteRecord(record.id!);
                                if (ctx.mounted) {
                                  AppToast.showSuccess(ctx, t.success.deleted);
                                }
                              } on AppErrorCodes catch (code) {
                                if (!ctx.mounted) return;

                                final msg = ErrorMapper.map(ctx, code: code);
                                switch (code) {
                                  case AppErrorCodes.prepayIsUsed:
                                    CommonInfoDialog.show(ctx,
                                        title:
                                            t.error.dialog.delete_failed.title,
                                        content: t.error.dialog.delete_failed
                                            .content);
                                    break;
                                  case AppErrorCodes.dataNotFound:
                                    CommonInfoDialog.show(ctx,
                                        title:
                                            t.error.dialog.delete_failed.title,
                                        content: msg);
                                    break;
                                  default:
                                    AppToast.showError(ctx, msg);
                                }
                              }
                            },
                          ),
                        );
                      }),
                      if (dayRecords.isNotEmpty)
                        const SizedBox(height: AppLayout.spaceS),
                    ],
                  );
                }).toList(),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
          ],
        );
      },
    );
  }
}
