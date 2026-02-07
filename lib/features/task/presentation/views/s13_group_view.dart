import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_error_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
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
  static const double _kDateStripHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<S13TaskDashboardViewModel>();
    final task = vm.task;

    if (task == null) return const Center(child: CircularProgressIndicator());

    Future<void> onRemainderRuleChange(S13TaskDashboardViewModel vm) async {
      final task = vm.task;
      if (task == null) return;

      final List<Map<String, dynamic>> membersList =
          task.members.entries.map((e) {
        final m = e.value as Map<String, dynamic>;
        return <String, dynamic>{...m, 'id': e.key};
      }).toList();

      final result = await B01BalanceRuleEditBottomSheet.show(context,
          initialRule: task.remainderRule,
          initialMemberId: task.remainderAbsorberId,
          members: membersList);

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
            showDialog(
              context: context,
              builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
                taskId: task.id,
                newCurrency: selected,
              ),
            );
          }
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomPadding = constraints.maxHeight;

        return CustomScrollView(
          controller: vm.groupScrollController,
          slivers: [
            // Sticky Header 1 (Card)
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyHeaderDelegate(
                height: _kCardHeight,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: _kCardHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GroupBalanceCard(
                      state: vm.balanceState, // 使用 VM 的 State
                      onCurrencyTap: showCurrencyPicker,
                      onRuleTap: () => onRemainderRuleChange(vm),
                      fixedHeight: _kCardHeight,
                    ),
                  ),
                ),
              ),
            ),

            // Sticky Header 2 (Date Strip)
            SliverPersistentHeader(
              pinned: true,
              delegate: CommonDateStripDelegate(
                height: _kDateStripHeight,
                startDate: task.startDate ?? DateTime.now(),
                endDate: task.endDate ?? DateTime.now(),
                selectedDate: vm.selectedDateInStrip,
                onDateSelected: (date) {
                  vm.handleDateJump(date, onNoResult: () {
                    D05DateJumpNoResultDialog.show(context,
                        targetDate: date, taskId: task.id);
                  });
                },
              ),
            ),

            // Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.map((date) {
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                final success =
                                    await vm.deleteRecord(record.id!);
                                // 顯示 SnackBar
                                if (success) {
                                  if (ctx.mounted) {
                                    AppToast.showSuccess(
                                        ctx,
                                        t.D10_RecordDelete_Confirm
                                            .deleted_success);
                                  }
                                } else {
                                  // B. 刪除失敗 (因為被使用) -> 彈出錯誤 Dialog
                                  if (context.mounted) {
                                    CommonErrorDialog.show(ctx,
                                        title:
                                            t.error.dialog.delete_failed.title,
                                        content: t.error.dialog.delete_failed
                                            .message);
                                  }
                                }
                              } catch (e) {
                                if (!ctx.mounted) return;

                                final eStr = e.toString();
                                final friendlyMessage = ErrorMapper.map(ctx, e);

                                if (eStr
                                    .contains(AppErrorCodes.recordNotFound)) {
                                  CommonErrorDialog.show(ctx,
                                      title: t.error.dialog.unknown.title,
                                      content: friendlyMessage);
                                } else {
                                  AppToast.showError(ctx, friendlyMessage);
                                }
                              }
                            },
                          ),
                        );
                      }),
                      if (dayRecords.isNotEmpty) const SizedBox(height: 8),
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
