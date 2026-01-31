import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/currency_picker_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/remainder_rule_picker_sheet.dart';
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

    void showRulePicker() {
      RemainderRulePickerSheet.show(
        context: context,
        initialRule: task.remainderRule,
        onSelected: (selectedRule) {
          vm.updateRemainderRule(selectedRule);
        },
      );
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
                      onRuleTap: showRulePicker,
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
                          taskId: task.id,
                          record: record,
                          poolBalancesByCurrency: vm.poolBalances, // 從 VM 獲取
                          baseCurrencyOption: vm.currencyOption,
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
