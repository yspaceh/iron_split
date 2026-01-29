import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart'; // 引入修正後的 Calculator
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/features/task/presentation/widgets/daily_header.dart';
import 'package:iron_split/features/task/presentation/widgets/record_block.dart';
import 'package:iron_split/features/task/presentation/widgets/sticky_header_delegate.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart'; // 確保路徑正確

class S13PersonalView extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic>? taskData;
  final Map<String, dynamic>? memberData;
  final List<QueryDocumentSnapshot> records;
  final CurrencyOption baseCurrencyOption;
  final String uid;
  final Map<String, double> poolBalancesByCurrency;

  const S13PersonalView({
    super.key,
    required this.taskId,
    required this.taskData,
    required this.memberData,
    required this.records,
    required this.baseCurrencyOption,
    required this.uid,
    required this.poolBalancesByCurrency,
  });

  @override
  State<S13PersonalView> createState() => _S13PersonalViewState();
}

class _S13PersonalViewState extends State<S13PersonalView> {
  final Map<String, GlobalKey> _dateKeys = {};
  DateTime _selectedDateInStrip = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  bool _hasPerformedInitialScroll = false;
  static const double _kCardHeight = 140.0;
  static const double _kDateStripHeight = 56.0;

  // 使用 Calculator 過濾
  List<RecordModel> get _personalRecords {
    final allModels =
        widget.records.map((doc) => RecordModel.fromFirestore(doc)).toList();

    return allModels.where((record) {
      return BalanceCalculator.isUserInvolved(record, widget.uid);
    }).toList();
  }

  Map<DateTime, List<RecordModel>> _groupRecords(List<RecordModel> records) {
    final Map<DateTime, List<RecordModel>> grouped = {};
    for (var record in records) {
      final date =
          DateTime(record.date.year, record.date.month, record.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(record);
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
          // Personal view 不需要特別扣除 header offset，或者視您的 UI 調整
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

        final hasRecords = _personalRecords.any((r) {
          return r.date.year == dTarget.year &&
              r.date.month == dTarget.month &&
              r.date.day == dTarget.day;
        });

        if (!hasRecords) {
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

          if (isInRange) {
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
    final t = Translations.of(context);

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

    final groupedRecords = _groupRecords(_personalRecords);
    // 1. 先取得原本的任務期間列表
    final rangeDates = _generateFullDateRangeDescending(startDate, endDate);

    // 2. 使用 Set 來合併日期 (Set 會自動去除重複的日期)
    final Set<DateTime> uniqueDates = {};
    uniqueDates.addAll(rangeDates);
    uniqueDates.addAll(groupedRecords.keys);

    // 3. 轉回 List 並由新到舊排序
    final fullDateList = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

    return LayoutBuilder(
      builder: (context, constraints) {
        final double bottomPadding = constraints.maxHeight;

        return CustomScrollView(
          controller: _scrollController,
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
                    child: _PersonalBalanceCard(
                      baseCurrencyOption: widget.baseCurrencyOption,
                      // [重要] 傳入原始全部紀錄，才能算總帳
                      allRecords: widget.records
                          .map((d) => RecordModel.fromFirestore(d))
                          .toList(),
                      uid: widget.uid,
                      memberData: widget.memberData,
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

                  // [Fix] Convert each record's share to Base Currency before summing
                  double dayMyDebit = 0;
                  for (var r in dayRecords) {
                    // 1. Get personal share in original currency (e.g. JPY)
                    double myShareOriginal =
                        BalanceCalculator.calculatePersonalDebit(r, widget.uid,
                            isBaseCurrency: false);
                    // 2. Convert to Base Currency using the record's exchange rate (e.g. TWD)
                    dayMyDebit += myShareOriginal * r.exchangeRate;
                  }

                  final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                  if (!_dateKeys.containsKey(dateKeyStr)) {
                    _dateKeys[dateKeyStr] = GlobalKey();
                  }

                  return Column(
                    key: _dateKeys[dateKeyStr],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DailyHeader(
                          date: date,
                          total: dayMyDebit, // 顯示我的消費
                          baseCurrencyOption: widget.baseCurrencyOption,
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
                          return RecordBlock(
                            taskId: widget.taskId,
                            record: record,
                            poolBalancesByCurrency:
                                widget.poolBalancesByCurrency,
                            baseCurrencyOption: widget.baseCurrencyOption,
                            uid: widget.uid, // 傳入 UID 判斷顯示方式
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

// ----------------------------------------------------

class _PersonalBalanceCard extends StatelessWidget {
  final CurrencyOption baseCurrencyOption;
  final List<RecordModel> allRecords;
  final String uid;
  final Map<String, dynamic>? memberData;

  const _PersonalBalanceCard({
    required this.baseCurrencyOption,
    required this.allRecords,
    required this.uid,
    required this.memberData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    final netBalance = BalanceCalculator.calculatePersonalNetBalance(
        allRecords: allRecords, uid: uid, isBaseCurrency: true);

    final isPositive = netBalance >= 0;
    final statusColor = isPositive ? Colors.green : theme.colorScheme.error;

    final currentUser = FirebaseAuth.instance.currentUser;
    final displayName = memberData?['name'] ??
        memberData?['displayName'] ??
        currentUser?.displayName ??
        '';

    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CommonAvatar(
              avatarId: memberData?['avatar'],
              name: displayName,
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isPositive
                      ? t.S13_Task_Dashboard.personal_to_receive
                      : t.S13_Task_Dashboard.personal_to_pay,
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  '${baseCurrencyOption.code}${baseCurrencyOption.symbol} ${CurrencyOption.formatAmount(netBalance.abs(), baseCurrencyOption.code)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
