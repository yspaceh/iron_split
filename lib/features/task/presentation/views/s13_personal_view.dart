import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/theme/app_layout.dart';
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

    if (task == null) return const SizedBox.shrink();

    // Member Data Logic (從 Task members Map 裡抓)
    final memberData = task.members[vm.currentUserId];

    // 1. 將卡片內容獨立出來，讓兩種 Sliver 共用
    final Widget balanceCardWidget = Container(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: PersonalBalanceCard(
          baseCurrency: vm.baseCurrency,
          netBalance: vm.personalNetBalance,
          totalExpense: vm.personalTotalExpense,
          totalPrepay: vm.personalTotalPrepay,
          uid: vm.currentUserId,
          memberData: memberData,
          fixedHeight: isEnlarged ? null : _kCardHeight,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomPadding = constraints.maxHeight;

        return CustomScrollView(
          controller: vm.personalScrollController, // 共用 VM Controller
          slivers: [
            if (!isEnlarged) ...[
              SliverPersistentHeader(
                pinned: true,
                delegate: StickyHeaderDelegate(
                  height: _kCardHeight,
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: _kCardHeight,
                    child: SizedBox(
                      height: _kCardHeight,
                      child: balanceCardWidget,
                    ),
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

            // Full Date Record List
            SliverToBoxAdapter(
              child: Column(
                children: vm.displayDates.toSet().map((date) {
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
                        final DualAmount displayAmount =
                            vm.getPersonalRecordDisplayAmount(record);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppLayout.spaceL),
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
                                await vm.deleteRecord(record.id!);
                                // 顯示 SnackBar
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
