import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/daily_statistics_helper.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/core/services/record_service.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/widgets/balance_card.dart';

class S13GroupView extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic>? taskData;
  final Map<String, dynamic>? memberData;
  final List<QueryDocumentSnapshot> records;
  final double prepayBalance;
  final String currency;

  const S13GroupView({
    super.key,
    required this.taskId,
    required this.taskData,
    required this.memberData,
    required this.records,
    required this.prepayBalance,
    required this.currency,
  });

  @override
  State<S13GroupView> createState() => _S13GroupViewState();
}

class _S13GroupViewState extends State<S13GroupView> {
  final Map<String, GlobalKey> _dateKeys = {};
  DateTime _selectedDateInStrip = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  // State for one-time scroll logic
  bool _hasPerformedInitialScroll = false;

  static const double _kCardHeight = 176.0;
  static const double _kDateStripHeight = 56.0;

  Map<DateTime, List<QueryDocumentSnapshot>> _groupRecords(
      List<QueryDocumentSnapshot> records) {
    final Map<DateTime, List<QueryDocumentSnapshot>> grouped = {};
    for (var doc in records) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['date'] as Timestamp?;
      if (ts == null) continue;

      final date =
          DateTime(ts.toDate().year, ts.toDate().month, ts.toDate().day);

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(doc);
    }
    return grouped;
  }

  List<DateTime> _generateFullDateRangeDescending(
      DateTime start, DateTime end) {
    if (start.isAfter(end)) return [start];
    final days = end.difference(start).inDays;
    return List.generate(
        days + 1, (index) => end.subtract(Duration(days: index)));
  }

  Future<void> _handleDateJump(DateTime date) async {
    setState(() {
      _selectedDateInStrip = date;
    });

    final dTarget = DateTime(date.year, date.month, date.day);
    final keyStr = DateFormat('yyyyMMdd').format(dTarget);

    void attemptScroll([int attempt = 0]) {
      final key = _dateKeys[keyStr];
      final context = key?.currentContext;

      if (context != null) {
        final renderObject = context.findRenderObject();

        if (renderObject != null) {
          final viewport = RenderAbstractViewport.of(renderObject);
          final revealedOffset =
              viewport.getOffsetToReveal(renderObject, 0.0).offset;

          final targetOffset = revealedOffset;

          _scrollController.animateTo(
            targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
          );
        }
      } else {
        if (attempt < 5) {
          Future.delayed(const Duration(milliseconds: 50),
              () => attemptScroll(attempt + 1));
          return;
        }

        bool isInRange = false;
        if (widget.taskData != null) {
          final start =
              _parseDate(widget.taskData!['startDate'], DateTime(2000));
          final end = _parseDate(widget.taskData!['endDate'], DateTime(2100));

          final dStart = DateTime(start.year, start.month, start.day);
          final dEnd = DateTime(end.year, end.month, end.day);

          if (!dTarget.isBefore(dStart) && !dTarget.isAfter(dEnd)) {
            isInRange = true;
          }
        }

        if (isInRange) return;

        final hasRecords = widget.records.any((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['date'] == null) return false;
          final rDate = (data['date'] as Timestamp).toDate();
          return rDate.year == dTarget.year &&
              rDate.month == dTarget.month &&
              rDate.day == dTarget.day;
        });

        if (!hasRecords) {
          showDialog(
            context: context ?? this.context,
            builder: (context) => D05DateJumpNoResultDialog(
              targetDate: dTarget,
              taskId: widget.taskId,
            ),
          );
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => attemptScroll());
  }

  DateTime _parseDate(dynamic input, DateTime fallback) {
    if (input is Timestamp) return input.toDate();
    if (input is String) return DateTime.tryParse(input) ?? fallback;
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    // Auto-Scroll Logic
    if (!_hasPerformedInitialScroll && widget.taskData != null) {
      _hasPerformedInitialScroll = true;

      final startTs = widget.taskData!['startDate'] as Timestamp?;
      final endTs = widget.taskData!['endDate'] as Timestamp?;

      if (startTs != null && endTs != null) {
        final start = startTs.toDate();
        final end = endTs.toDate();
        final now = DateTime.now();

        final dStart = DateTime(start.year, start.month, start.day);
        final dEnd = DateTime(end.year, end.month, end.day);
        final dNow = DateTime(now.year, now.month, now.day);

        DateTime targetDate;
        if (dNow.isBefore(dStart) || dNow.isAfter(dEnd)) {
          targetDate = start;
        } else {
          targetDate = now;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _handleDateJump(targetDate);
              }
            });
          }
        });
      }
    }

    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 7));

    if (widget.taskData != null) {
      if (widget.taskData!['startDate'] != null) {
        startDate = _parseDate(widget.taskData!['startDate'], startDate);
      }
      if (widget.taskData!['endDate'] != null) {
        endDate = _parseDate(widget.taskData!['endDate'], endDate);
      }
    }

    startDate = DateTime(startDate.year, startDate.month, startDate.day);
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    final groupedRecords = _groupRecords(widget.records);
    final fullDateList = _generateFullDateRangeDescending(startDate, endDate);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double visibleHeight = constraints.maxHeight;
        final double bottomPadding = visibleHeight;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sticky Header 1 (Card only)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                height: _kCardHeight,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: _kCardHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BalanceCard(
                      taskId: widget.taskId,
                      taskData: widget.taskData,
                      memberData: widget.memberData,
                      records: widget.records,
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
                startDate: startDate,
                endDate: endDate,
                selectedDate: _selectedDateInStrip,
                onDateSelected: (date) => _handleDateJump(date),
              ),
            ),

            // Full Date Record List
            SliverToBoxAdapter(
              child: Column(
                children: fullDateList.map((date) {
                  final dayRecords = groupedRecords[date] ?? [];
                  final dayModels = dayRecords
                      .map((doc) => RecordModel.fromFirestore(doc))
                      .toList();
                  final dayTotal =
                      DailyStatisticsHelper.calculateDailyExpense(dayModels);

                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  if (!_dateKeys.containsKey(dateKeyStr)) {
                    _dateKeys[dateKeyStr] = GlobalKey();
                  }

                  return Column(
                    key: _dateKeys[dateKeyStr],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DailyHeader(
                          date: date,
                          total: dayTotal,
                          currency: widget.currency),
                      if (dayRecords.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: OutlinedButton.icon(
                              onPressed: () => context.pushNamed(
                                'S15',
                                pathParameters: {'taskId': widget.taskId},
                                extra: {
                                  'prepayBalance': widget.prepayBalance,
                                  'date': date,
                                },
                              ),
                              icon: const Icon(Icons.add),
                              label: Text(t.S15_Record_Edit.title_create),
                            ),
                          ),
                        )
                      else
                        ...dayRecords.map((doc) {
                          final recordModel = RecordModel.fromFirestore(doc);
                          return _RecordItem(
                            taskId: widget.taskId,
                            record: recordModel,
                            prepayBalance: widget.prepayBalance,
                            baseCurrency: widget.currency,
                          );
                        }),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Dynamic Bottom Padding
            SliverToBoxAdapter(
              child: SizedBox(height: bottomPadding),
            ),
          ],
        );
      },
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _StickyHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

class _DailyHeader extends StatelessWidget {
  final DateTime date;
  final double total;
  final String currency;

  const _DailyHeader(
      {required this.date, required this.total, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dateStr = DateFormat('MM/dd (E)').format(date);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (isToday)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(t.common.today,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.onPrimary)),
                ),
              Text(dateStr,
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          Text(
              "${t.S13_Task_Dashboard.daily_expense_label}: $currency ${CurrencyOption.formatAmount(total, currency)}",
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _RecordItem extends StatelessWidget {
  final String taskId;
  final RecordModel record;
  final double prepayBalance;
  final String baseCurrency;

  const _RecordItem({
    required this.taskId,
    required this.record,
    required this.prepayBalance,
    required this.baseCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final isIncome = record.type == 'income';
    final amount = record.amount;
    final currency = record.currency;
    final exchangeRate = record.exchangeRate;
    final category = CategoryConstant.getCategoryById(record.categoryId);
    final title =
        (record.title.isNotEmpty) ? record.title : category.getName(t);

    final icon = isIncome ? Icons.savings_outlined : category.icon;

    final color =
        isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error;

    final bgColor = isIncome
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.errorContainer;

    final iconColor = isIncome
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onError;

    final numberFormat = NumberFormat("#,##0.##");
    final amountText = isIncome
        ? "- $currency ${numberFormat.format(amount)}"
        : "$currency ${numberFormat.format(amount)}";

    return Dismissible(
      key: Key(record.id ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (context) => D10RecordDeleteConfirmDialog(
            title: title,
            amount: amountText,
            onConfirm: () {
              confirmed = true;
            },
          ),
        );
        return confirmed;
      },
      onDismissed: (direction) {
        RecordService.deleteRecord(taskId, record.id ?? '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.D10_RecordDelete_Confirm.deleted_success)),
        );
      },
      child: ListTile(
        onTap: () => context.pushNamed(
          'S15',
          pathParameters: {'taskId': taskId},
          queryParameters: {'id': record.id},
          extra: {
            'prepayBalance': prepayBalance,
            'record': record,
          },
        ),
        leading: CircleAvatar(
          backgroundColor:
              isIncome ? bgColor : theme.colorScheme.tertiaryContainer,
          child: Icon(
            icon,
            color: isIncome ? iconColor : theme.colorScheme.onTertiaryContainer,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              amountText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (currency != baseCurrency)
              Text(
                "≈ $baseCurrency ${CurrencyOption.formatAmount(amount * exchangeRate, baseCurrency)}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
