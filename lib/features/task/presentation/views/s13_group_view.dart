import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/widgets/daily_header.dart';
import 'package:iron_split/features/task/presentation/widgets/record_item.dart';
import 'package:iron_split/features/task/presentation/widgets/balance_card.dart';
import 'package:iron_split/features/task/presentation/widgets/sticky_header_delegate.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s13_task_dashboard_vm.dart';

class S13GroupView extends StatelessWidget {
  const S13GroupView({super.key});

  static const double _kCardHeight = 176.0;
  static const double _kDateStripHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<S13TaskDashboardViewModel>();
    final task = vm.task;

    if (task == null) return const Center(child: CircularProgressIndicator());

    Future<void> onRemainderRuleChange() async {
      final vm = context.read<S13TaskDashboardViewModel>();
      final task = vm.task;
      if (task == null) return;

      // 修正這裡
      final List<Map<String, dynamic>> membersList =
          task.members.entries.map((e) {
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
                    child: BalanceCard(
                      state: vm.balanceState, // 使用 VM 的 State
                      onCurrencyTap: showCurrencyPicker,
                      onRuleTap: onRemainderRuleChange,
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
                    showDialog(
                      context: context,
                      builder: (context) => D05DateJumpNoResultDialog(
                        targetDate: date,
                        taskId: task.id,
                      ),
                    );
                  });
                },
              ),
            ),

            // Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.map((date) {
                  final dayRecords = vm.groupedRecords[date] ?? [];

                  // 保留 BalanceCalculator 邏輯
                  final dayTotal = BalanceCalculator.calculateExpenseTotal(
                      dayRecords,
                      isBaseCurrency: true);

                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  final key = vm.dateKeys[dateKeyStr];

                  return Column(
                    key: key,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeader(
                        date: date,
                        total: dayTotal,
                        baseCurrencyOption: vm.currencyOption, // 從 VM 獲取
                        isPersonal: false,
                      ),
                      ...dayRecords.map((record) {
                        return RecordItem(
                          record: record,
                          baseCurrencyOption: vm.currencyOption,
                          displayAmount: record.amount,
                          onTap: () {
                            context.pushNamed(
                              'S15',
                              pathParameters: {'taskId': task.id},
                              queryParameters: {'id': record.id},
                              extra: {
                                // 需要帶過去的資料由這裡決定，RecordItem 不用當搬運工
                                'poolBalancesByCurrency': vm.poolBalances,
                                'baseCurrencyOption': vm.currencyOption,
                                'record': record,
                              },
                            );
                          },
                          onDelete: (ctx) async {
                            // 呼叫 Repo 進行刪除
                            try {
                              await vm.deleteRecord(record.id!);
                              // 顯示 SnackBar
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  SnackBar(
                                      content: Text(Translations.of(ctx)
                                          .D10_RecordDelete_Confirm
                                          .deleted_success)),
                                );
                              }
                            } catch (e) {
                              // TODO: 需追加錯誤處理
                            }
                          },
                        );
                      }),
                      // 保留新增按鈕樣式
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => context.pushNamed(
                              'S15',
                              pathParameters: {'taskId': task.id},
                              extra: {
                                'poolBalancesByCurrency': vm.poolBalances,
                                'baseCurrencyOption': vm.currencyOption,
                                'date': date,
                              },
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant
                                    .withValues(alpha: 0.5),
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
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
