import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_info_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
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

  static const double _kCardHeight = 176.0;
  static const double _kDateStripHeight = 56.0;

  @override
  Widget build(BuildContext context) {
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
                      baseCurrency: vm.baseCurrency,
                      netBalance: vm.personalNetBalance,
                      totalExpense: vm.personalTotalExpense,
                      totalIncome: vm.personalTotalIncome,
                      uid: vm.currentUserId,
                      memberData: memberData,
                      fixedHeight: _kCardHeight, // 傳入 Map
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

            // Full Date Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.map((date) {
                  // 取出個人的分組紀錄
                  final dayRecords = vm.personalGroupedRecords[date] ?? [];

                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  final key = vm.dateKeys[dateKeyStr];

                  return Column(
                    key: key,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeader(
                        date: date,
                        isEmpty: dayRecords.isEmpty,
                      ),
                      ...dayRecords.map((record) {
                        DualAmount displayAmount = record.type == 'income'
                            ? BalanceCalculator.calculatePersonalCredit(
                                record, vm.currentUserId, vm.baseCurrency)
                            : BalanceCalculator.calculatePersonalDebit(
                                record, vm.currentUserId, vm.baseCurrency);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RecordItem(
                            record: record,
                            baseCurrency: vm.baseCurrency,
                            amount: displayAmount,
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
                                    CommonInfoDialog.show(ctx,
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
                                  CommonInfoDialog.show(ctx,
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
