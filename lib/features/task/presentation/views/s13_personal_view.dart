import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/task/presentation/widgets/personal_balance_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/features/task/presentation/widgets/daily_header.dart';
import 'package:iron_split/features/task/presentation/widgets/record_item.dart';
import 'package:iron_split/features/task/presentation/widgets/sticky_header_delegate.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s13_task_dashboard_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S13PersonalView extends StatelessWidget {
  const S13PersonalView({super.key});

  static const double _kCardHeight = 140.0;
  static const double _kDateStripHeight = 56.0;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S13TaskDashboardViewModel>();
    final task = vm.task;

    if (task == null) return const SizedBox.shrink();

    // Member Data Logic (從 Task members Map 裡抓)
    final memberData = task.members[vm.currentUserId];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomPadding = constraints.maxHeight;

        return CustomScrollView(
          controller: vm.personalScrollController, // 共用 VM Controller
          slivers: [
            // Sticky Header 1 (Personal Balance)
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyHeaderDelegate(
                height: _kCardHeight,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: _kCardHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PersonalBalanceCard(
                      baseCurrencyOption: vm.currencyOption,
                      netBalance: vm.personalNetBalance, // 從 VM 拿計算好的值
                      uid: vm.currentUserId,
                      memberData: memberData, // 傳入 Map
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
                    // Personal View 的 No Result 判斷邏輯其實跟 Group 一樣
                    // 只要該日期沒有紀錄且不在範圍內就彈窗
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

            // Full Date Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.map((date) {
                  // 取出個人的分組紀錄
                  final dayRecords = vm.personalGroupedRecords[date] ?? [];

                  // 計算當日個人消費 (呼叫 VM Helper)
                  final dayMyDebit = vm.calculateDailyPersonalDebit(date);

                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  final key = vm.dateKeys[dateKeyStr];

                  return Column(
                    key: key,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeader(
                          date: date,
                          total: dayMyDebit, // 顯示我的消費
                          baseCurrencyOption: vm.currencyOption,
                          isPersonal: true),
                      if (dayRecords.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              t.S13_Task_Dashboard.personal_empty_desc,
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          ),
                        )
                      else
                        ...dayRecords.map((record) {
                          double displayAmount = record.type == 'income'
                              ? BalanceCalculator.calculatePersonalCredit(
                                  record, vm.currentUserId,
                                  isBaseCurrency: false)
                              : BalanceCalculator.calculatePersonalDebit(
                                  record, vm.currentUserId,
                                  isBaseCurrency: false);
                          return RecordItem(
                            record: record,
                            baseCurrencyOption: vm.currencyOption,
                            displayAmount: displayAmount,
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
                    ],
                  );
                }).toList(),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: bottomPadding),
            ),
          ],
        );
      },
    );
  }
}
