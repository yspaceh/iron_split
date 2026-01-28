import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/common_date_strip_delegate.dart';
import 'package:iron_split/features/task/presentation/widgets/daily_header.dart';
import 'package:iron_split/features/task/presentation/widgets/record_block.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/widgets/balance_card.dart';
import 'package:iron_split/features/task/presentation/widgets/sticky_header_delegate.dart';

class S13GroupView extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic>? taskData;
  final Map<String, dynamic>? memberData;
  final List<QueryDocumentSnapshot> records;
  final Map<String, double> poolBalancesByCurrency;
  final CurrencyOption baseCurrencyOption;

  const S13GroupView({
    super.key,
    required this.taskId,
    required this.taskData,
    required this.memberData,
    required this.records,
    required this.poolBalancesByCurrency,
    required this.baseCurrencyOption,
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
        // 假設 widget.records 是 List<QueryDocumentSnapshot>
        final List<RecordModel> recordModels = widget.records.map((doc) {
          return RecordModel.fromFirestore(doc);
        }).toList();

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Sticky Header 1 (Card only)
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
                      taskId: widget.taskId,
                      taskData: widget.taskData,
                      memberData: widget.memberData,
                      records: widget.records,
                      remainderBuffer:
                          BalanceCalculator.calculateRemainderBuffer(
                              recordModels),
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
                  final dayTotal = BalanceCalculator.calculateExpenseTotal(
                      dayModels,
                      isBaseCurrency: true);

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
                        total: dayTotal,
                        baseCurrencyOption: widget.baseCurrencyOption,
                        isPersonal: false,
                      ),
                      ...dayRecords.map((doc) {
                        final recordModel = RecordModel.fromFirestore(doc);
                        return RecordBlock(
                          taskId: widget.taskId,
                          record: recordModel,
                          poolBalancesByCurrency: widget.poolBalancesByCurrency,
                          baseCurrencyOption: widget.baseCurrencyOption,
                        );
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16), // 調整間距，讓下面空一點
                        child: SizedBox(
                          width: double.infinity, // 1. 讓按鈕撐滿寬度
                          height: 48, // 2. 設定固定高度，讓它看起來像個卡片區塊
                          child: OutlinedButton(
                            onPressed: () => context.pushNamed(
                              'S15',
                              pathParameters: {'taskId': widget.taskId},
                              extra: {
                                'poolBalancesByCurrency':
                                    widget.poolBalancesByCurrency,
                                'baseCurrencyOption': widget.baseCurrencyOption,
                                'date': date,
                              },
                            ),
                            style: OutlinedButton.styleFrom(
                              // 按鈕內容顏色 (Icon 顏色) - 使用較淡的灰色
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              // 邊框樣式 - 使用細且淡的邊框 (模擬虛線框的視覺感)
                              side: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant
                                    .withValues(alpha: 0.5),
                                width: 1,
                                // 注意：Flutter 原生 OutlinedButton 不支援虛線，若需虛線需用 CustomPaint，
                                // 但通常淡色實線邊框在 UI 上已足夠達到「新增區塊」的視覺效果。
                              ),
                              // 圓角設定 - 設定為 16 或 20
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              // 移除預設的背景色 (變透明)
                              backgroundColor: Colors.transparent,
                            ),
                            // 3. 中間只放 Icon
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ),
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
