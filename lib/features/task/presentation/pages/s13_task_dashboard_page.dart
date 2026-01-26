import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/daily_statistics_helper.dart';
import 'package:iron_split/core/constants/category_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/d05_date_jump_no_result_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';
import 'package:iron_split/core/services/record_service.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/widgets/balance_card.dart';

/// Page Key: S13_Task_Dashboard (Wireframe 16)
class S13TaskDashboardPage extends StatefulWidget {
  final String taskId;

  const S13TaskDashboardPage({super.key, required this.taskId});

  @override
  State<S13TaskDashboardPage> createState() => _S13TaskDashboardPageState();
}

class _S13TaskDashboardPageState extends State<S13TaskDashboardPage> {
  List<QueryDocumentSnapshot> _allRecords = [];
  bool _hasPerformedInitialScroll = false;
  int _segmentIndex = 0; // 0: Group, 1: Personal
  bool _isShowingIntro = false;
  final Map<String, GlobalKey> _dateKeys = {};
  DateTime _selectedDateInStrip = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _dateStripKey = GlobalKey();
  Map<String, dynamic>? _taskData;

  // Constants for Sticky Header
  static const double _kTabSectionHeight = 64.0; // Corrected to match actual UI
  static const double _kCardHeight = 176.0; // MATCHING CURRENT CARD UI
  static const double _kDateStripHeight = 56.0;

  // Total Sticky Height for SliverPersistentHeader
  double get _dashboardStickyHeight => _kTabSectionHeight + _kCardHeight;

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
    // Ensure start is before end
    if (start.isAfter(end)) return [start];

    final days = end.difference(start).inDays;
    // Generate from End to Start (Descending)
    return List.generate(
        days + 1, (index) => end.subtract(Duration(days: index)));
  }

  Future<void> _handleDateJump(DateTime date) async {
    // 1. Immediate UI Update
    setState(() {
      _selectedDateInStrip = date;
    });

    final dTarget = DateTime(date.year, date.month, date.day);
    final keyStr = DateFormat('yyyyMMdd').format(dTarget);

    // 2. Scroll Helper with Retry
    void attemptScroll([int attempt = 0]) {
      final key = _dateKeys[keyStr];
      final context = key?.currentContext;

      if (context != null) {
        // --- FIX: Absolute Position Scrolling ---
        // 診斷結果證實 revealedOffset 已經是正確的目標位置
        // 直接捲動到該位置，不需要再扣除 Header 高度
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
        // Retry if failed (Layout settling)
        if (attempt < 5) {
          Future.delayed(const Duration(milliseconds: 50),
              () => attemptScroll(attempt + 1));
          return;
        }

        // 3. Fallback: Range Check (保留您的 Code 原封不動)
        bool isInRange = false;
        if (_taskData != null) {
          final start = _parseDate(_taskData!['startDate'], DateTime(2000));
          final end = _parseDate(_taskData!['endDate'], DateTime(2100));

          final dStart = DateTime(start.year, start.month, start.day);
          final dEnd = DateTime(end.year, end.month, end.day);

          if (!dTarget.isBefore(dStart) && !dTarget.isAfter(dEnd)) {
            isInRange = true;
          }
        }

        // If date is valid, STOP. Do not show dialog.
        if (isInRange) return;

        // Fallback: Check records
        final hasRecords = _allRecords.any((doc) {
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
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    return MultiStreamBuilder(
      taskId: widget.taskId,
      uid: user.uid,
      builder: (context, taskData, memberData, records, isLoading) {
        if (isLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        _taskData = taskData; // Capture for Date Jump Logic
        _allRecords = records; // Capture for Auto-Scroll Calculation

        // Auto-Scroll Logic (Run Once)
        if (!_hasPerformedInitialScroll && taskData != null && !isLoading) {
          _hasPerformedInitialScroll = true; // Lock immediately

          // Extract dates
          final startTs = taskData['startDate'] as Timestamp?;
          final endTs = taskData['endDate'] as Timestamp?;

          if (startTs != null && endTs != null) {
            final start = startTs.toDate();
            final end = endTs.toDate();
            final now = DateTime.now();

            // Normalize (remove time) for comparison
            final dStart = DateTime(start.year, start.month, start.day);
            final dEnd = DateTime(end.year, end.month, end.day);
            final dNow = DateTime(now.year, now.month, now.day);

            // Determine Target
            DateTime targetDate;
            if (dNow.isBefore(dStart) || dNow.isAfter(dEnd)) {
              targetDate = start; // Out of range -> Go to Start
            } else {
              targetDate = now; // In range -> Go to Today
            }

            // Schedule Jump after frame (to allow list to build)
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                // Add delay to ensure layout is ready
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    _handleDateJump(targetDate);
                  }
                });
              }
            });
          }
        }

        // 1. D01 Intro Logic
        final bool hasSeen = memberData?['hasSeenRoleIntro'] ?? true;
        if (memberData != null && !hasSeen && !_isShowingIntro) {
          _isShowingIntro = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => D01MemberRoleIntroDialog(
                taskId: widget.taskId,
                initialAvatar: memberData['avatar'] ?? 'pig',
                canReroll: true,
              ),
            );
            if (mounted) {
              setState(() => _isShowingIntro = false);
            }
          });
        }

        if (taskData == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        // Calculate Balance
        final recordModels =
            records.map((doc) => RecordModel.fromFirestore(doc)).toList();
        final double prepayBalance =
            BalanceCalculator.calculatePrepayBalance(recordModels);

        // 2. Data Preparation
        final String systemCurrency = NumberFormat.simpleCurrency(
                    locale: Localizations.localeOf(context).toString())
                .currencyName ??
            '';
        final String currency = taskData['baseCurrency'] ??
            (systemCurrency.isNotEmpty
                ? systemCurrency
                : kSupportedCurrencies
                    .firstWhere((e) => e.code == CurrencyOption.defaultCode)
                    .code);
        final bool isCaptain = taskData['createdBy'] == user.uid;

        // Parse Start/End Date
        DateTime startDate = DateTime.now();
        DateTime endDate = DateTime.now().add(const Duration(days: 7));

        if (taskData['startDate'] != null) {
          if (taskData['startDate'] is Timestamp) {
            startDate = (taskData['startDate'] as Timestamp).toDate();
          } else if (taskData['startDate'] is String) {
            startDate = DateTime.tryParse(taskData['startDate']) ?? startDate;
          }
        }

        if (taskData['endDate'] != null) {
          if (taskData['endDate'] is Timestamp) {
            endDate = (taskData['endDate'] as Timestamp).toDate();
          } else if (taskData['endDate'] is String) {
            endDate = DateTime.tryParse(taskData['endDate']) ?? endDate;
          }
        }

        // Normalize to start of day
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        endDate = DateTime(endDate.year, endDate.month, endDate.day);

        // 3. Group Records and Full Date List
        final groupedRecords = _groupRecords(records);
        final fullDateList =
            _generateFullDateRangeDescending(startDate, endDate);

        return Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(taskData['name'] ?? t.S13_Task_Dashboard.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () =>
                    context.push('/tasks/${widget.taskId}/settings'),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              children: [
                if (isCaptain)
                  OutlinedButton.icon(
                    onPressed: () => context.pushNamed(
                      'S30',
                      pathParameters: {'taskId': widget.taskId},
                    ),
                    icon: const Icon(Icons.check),
                    label: Text(t.S13_Task_Dashboard.settlement_button),
                  ),
                const Spacer(),
                FloatingActionButton.extended(
                  onPressed: () => context.pushNamed(
                    'S15',
                    pathParameters: {'taskId': widget.taskId},
                    extra: {'prepayBalance': prepayBalance},
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(t.S13_Task_Dashboard.fab_record),
                  elevation: 0,
                ),
              ],
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate padding dynamically
              final double visibleHeight = constraints.maxHeight;
              // Force full screen padding for safety
              final double bottomPadding = visibleHeight;

              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // --- A. Sticky Header 1 (Tab + Card) ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyHeaderDelegate(
                      height: _dashboardStickyHeight,
                      child: Column(
                        children: [
                          // Tab Section (Standard M3 padding)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<int>(
                                segments: [
                                  ButtonSegment(
                                      value: 0,
                                      label:
                                          Text(t.S13_Task_Dashboard.tab_group),
                                      icon: const Icon(Icons.groups)),
                                  ButtonSegment(
                                      value: 1,
                                      label: Text(
                                          t.S13_Task_Dashboard.tab_personal),
                                      icon: const Icon(Icons.person)),
                                ],
                                selected: {_segmentIndex},
                                onSelectionChanged: (Set<int> newSelection) {
                                  setState(
                                      () => _segmentIndex = newSelection.first);
                                },
                                showSelectedIcon: false,
                              ),
                            ),
                          ),

                          // Card Section (Enforced Height)
                          SizedBox(
                            height: _kCardHeight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: _segmentIndex == 0
                                  ? BalanceCard(
                                      taskId: widget.taskId,
                                      taskData: taskData,
                                      memberData: memberData,
                                      records: records,
                                    )
                                  : S13DailyStatsCard(
                                      records: records,
                                      targetDate: DateTime.now(),
                                      currency: currency,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- B. Sticky Header 2 (Date Strip) ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _DateStripDelegate(
                      key: _dateStripKey,
                      height: _kDateStripHeight,
                      startDate: startDate,
                      endDate: endDate,
                      selectedDate: _selectedDateInStrip,
                      onDateSelected: (date) => _handleDateJump(date),
                    ),
                  ),

                  // --- C. Full Date Record List (Render All) ---
                  SliverToBoxAdapter(
                    child: Column(
                      children: fullDateList.map((date) {
                        final dayRecords = groupedRecords[date] ?? [];

                        // Calculate Daily Expense using Helper
                        final dayModels = dayRecords
                            .map((doc) => RecordModel.fromFirestore(doc))
                            .toList();
                        final dayTotal =
                            DailyStatisticsHelper.calculateDailyExpense(
                                dayModels);

                        final dateKeyStr = DateFormat('yyyyMMdd').format(date);
                        if (!_dateKeys.containsKey(dateKeyStr)) {
                          _dateKeys[dateKeyStr] = GlobalKey();
                        }

                        return Column(
                          key: _dateKeys[dateKeyStr], // Key attached here
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _DailyHeader(
                                date: date,
                                total: dayTotal,
                                currency: currency),

                            // Records or Quick Add
                            if (dayRecords.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: OutlinedButton.icon(
                                    onPressed: () => context.pushNamed(
                                      'S15',
                                      pathParameters: {'taskId': widget.taskId},
                                      extra: {
                                        'prepayBalance': prepayBalance,
                                        'date': date, // Pass date
                                      },
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: Text(t.S15_Record_Edit.title_create),
                                  ),
                                ),
                              )
                            else
                              ...dayRecords.map((doc) {
                                return _RecordItem(
                                  taskId: widget.taskId,
                                  doc: doc,
                                  prepayBalance: prepayBalance,
                                  baseCurrency: currency,
                                );
                              }),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  // --- D. Dynamic Bottom Padding ---
                  SliverToBoxAdapter(
                    child: SizedBox(height: bottomPadding),
                  ),
                ],
              );
            },
          ),
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

class _DateStripDelegate extends SliverPersistentHeaderDelegate {
  final GlobalKey key;
  final double height;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  _DateStripDelegate({
    required this.key,
    required this.height,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final days = endDate.difference(startDate).inDays + 1;
    final dates = List.generate(
        days > 0 ? days : 1, (index) => startDate.add(Duration(days: index)));

    return Container(
      key: key,
      color: theme.colorScheme.surface, // Solid background
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    // 1. Get current locale from slang
                    Locale activeLocale =
                        TranslationProvider.of(context).flutterLocale;

                    // 2. FIX: Upgrade generic 'zh' to 'zh_Hant_TW'
                    if (activeLocale.languageCode == 'zh') {
                      activeLocale = const Locale.fromSubtags(
                        languageCode: 'zh',
                        scriptCode:
                            'Hant', // This forces the DatePicker to use Traditional Chinese assets
                        countryCode: 'TW',
                      );
                    }

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: startDate.subtract(const Duration(days: 365)),
                      lastDate: endDate.add(const Duration(days: 365)),
                      // 3. Pass the corrected locale
                      locale: activeLocale,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      onDateSelected(picked);
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      final date = dates[index];
                      final isToday = DateUtils.isSameDay(date, DateTime.now());
                      final isSelected =
                          DateUtils.isSameDay(date, selectedDate);
                      final dateStr = DateFormat('MM/dd').format(date);

                      return InkWell(
                        onTap: () => onDateSelected(date),
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          // Padding handled by alignment
                          child: Stack(
                            children: [
                              // A. 日期數字 (絕對置中)
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : Colors.transparent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(dateStr,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? theme.colorScheme.onPrimary
                                                  : theme
                                                      .colorScheme.onSurface)),
                                ),
                              ),
                              // B. Today 圓點 (固定底部)
                              if (isToday)
                                Positioned(
                                  bottom: 6, // 固定距離底部 4px
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ), // Padding bottom
        ],
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _DateStripDelegate oldDelegate) {
    return oldDelegate.startDate != startDate ||
        oldDelegate.endDate != endDate ||
        oldDelegate.selectedDate != selectedDate;
  }
}

// --- Components (Existing) ---

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
  final DocumentSnapshot doc;
  final double prepayBalance;
  final String baseCurrency;

  const _RecordItem({
    required this.taskId,
    required this.doc,
    required this.prepayBalance,
    required this.baseCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final theme = Theme.of(context);
    final type = data['type'] ?? 'expense';
    final isIncome = type == 'income';
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = data['currency'] ?? '';
    final exchangeRate = (data['exchangeRate'] as num?)?.toDouble() ?? 1.0;
    final title = data['title'] ?? t.common.untitled;
    // date unused for display now
    final categoryId = data['categoryId'] as String?; // New

    // Icon logic: Income -> Savings, Expense -> Category Icon
    final icon = isIncome
        ? Icons.savings_outlined
        : CategoryConstant.getCategoryById(categoryId).icon;

    // Color logic: Income -> Green, Expense -> Red (Error)
    // Income 使用 Tertiary (綠), Expense 使用 Error (紅)
    final color =
        isIncome ? theme.colorScheme.tertiary : theme.colorScheme.error;

    // Income 背景使用 TertiaryContainer (淺綠), Expense 背景使用 ErrorContainer (淺紅)
    final bgColor = isIncome
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.errorContainer;

    // Icon/文字顏色
    final iconColor = isIncome
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onError;

    final numberFormat = NumberFormat("#,##0.##");
    // Text logic: Income -> "- $currency$amount", Expense -> "$currency$amount"
    final amountText = isIncome
        ? "- $currency ${numberFormat.format(amount)}"
        : "$currency ${numberFormat.format(amount)}";

    return Dismissible(
      key: Key(doc.id),
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
        RecordService.deleteRecord(taskId, doc.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.D10_RecordDelete_Confirm.deleted_success)),
        );
      },
      child: ListTile(
        onTap: () => context.pushNamed(
          'S15',
          pathParameters: {'taskId': taskId},
          queryParameters: {'id': doc.id},
          extra: {
            'prepayBalance': prepayBalance,
            'record': RecordModel.fromFirestore(doc),
          },
        ),
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? bgColor // Light Green
              : theme.colorScheme.tertiaryContainer,
          child: Icon(
            icon,
            color: isIncome ? iconColor : theme.colorScheme.onTertiaryContainer,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        // Remove Subtitle (Time)
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

class MultiStreamBuilder extends StatelessWidget {
  final String taskId;
  final String uid;
  final Widget Function(
      BuildContext context,
      Map<String, dynamic>? task,
      Map<String, dynamic>? member,
      List<QueryDocumentSnapshot> records,
      bool isLoading) builder;

  const MultiStreamBuilder(
      {super.key,
      required this.taskId,
      required this.uid,
      required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .snapshots(),
      builder: (context, taskSnapshot) {
        final taskData = taskSnapshot.data?.data() as Map<String, dynamic>?;

        // Derive memberData from the Map
        Map<String, dynamic>? memberData;
        if (taskData != null && taskData.containsKey('members')) {
          final membersMap = taskData['members'] as Map<String, dynamic>;
          if (membersMap.containsKey(uid)) {
            memberData = membersMap[uid] as Map<String, dynamic>;
          }
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskId)
              .collection('records')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, recordSnapshot) {
            final records = recordSnapshot.data?.docs ?? [];
            final bool isLoading =
                recordSnapshot.connectionState == ConnectionState.waiting ||
                    taskSnapshot.connectionState == ConnectionState.waiting;
            return builder(context, taskData, memberData, records, isLoading);
          },
        );
      },
    );
  }
}

class S13DailyStatsCard extends StatelessWidget {
  final List<QueryDocumentSnapshot> records;
  final DateTime targetDate;
  final String currency;

  const S13DailyStatsCard({
    super.key,
    required this.records,
    required this.targetDate,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter records for targetDate
    final dailyRecords = records.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final ts = data['date'] as Timestamp?;
      if (ts == null) return false;
      final date = ts.toDate().toLocal();
      return date.year == targetDate.year &&
          date.month == targetDate.month &&
          date.day == targetDate.day;
    }).toList();

    final recordModels =
        dailyRecords.map((doc) => RecordModel.fromFirestore(doc)).toList();
    final dailyTotal =
        DailyStatisticsHelper.calculateDailyExpense(recordModels);

    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.S13_Task_Dashboard.daily_stats_title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(currency, style: theme.textTheme.titleLarge),
                const SizedBox(width: 8),
                Text(
                  dailyTotal.toStringAsFixed(1),
                  style: theme.textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
