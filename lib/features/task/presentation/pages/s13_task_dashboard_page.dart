import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

/// Page Key: S13_Task_Dashboard (Wireframe 16)
class S13TaskDashboardPage extends StatefulWidget {
  final String taskId;

  const S13TaskDashboardPage({super.key, required this.taskId});

  @override
  State<S13TaskDashboardPage> createState() => _S13TaskDashboardPageState();
}

class _S13TaskDashboardPageState extends State<S13TaskDashboardPage> {
  int _segmentIndex = 0; // 0: Group, 1: Personal
  bool _isShowingIntro = false;
  final Map<String, GlobalKey> _dateKeys = {};
  DateTime _selectedDateInStrip = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _taskData;

  String _mapRuleName(String? rule) {
    switch (rule) {
      case 'order':
        return t.S13_Task_Dashboard.rule_order;
      case 'member':
        return t.S13_Task_Dashboard.rule_member;
      case 'random':
      default:
        return t.S13_Task_Dashboard.rule_random;
    }
  }

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

  void _handleDateJump(BuildContext context, DateTime targetDate) {
    if (_taskData == null) return;

    // 1. Parse Dates
    DateTime start = DateTime.now();
    DateTime end = DateTime.now();

    if (_taskData!['startDate'] is Timestamp) {
      start = (_taskData!['startDate'] as Timestamp).toDate();
    } else if (_taskData!['startDate'] is String) {
      start = DateTime.tryParse(_taskData!['startDate']) ?? start;
    }

    if (_taskData!['endDate'] is Timestamp) {
      end = (_taskData!['endDate'] as Timestamp).toDate();
    } else if (_taskData!['endDate'] is String) {
      end = DateTime.tryParse(_taskData!['endDate']) ?? end;
    }

    // Normalize (strip time)
    final normalize = (DateTime d) => DateTime(d.year, d.month, d.day);
    final dTarget = normalize(targetDate);
    final dStart = normalize(start);
    final dEnd = normalize(end);

    // 2. Logic Check: Range
    // Note: Since list is Descending (End -> Start), range check is same.
    final isWithinRange = !dTarget.isBefore(dStart) && !dTarget.isAfter(dEnd);

    if (!isWithinRange) {
      showDialog(
        context: context,
        builder: (ctx) => const D05DateJumpNoResultDialog(),
      );
      return;
    }

    // Update strip selection
    setState(() {
      _selectedDateInStrip = dTarget;
    });

    // 3. Scroll Logic
    final dateStr = DateFormat('yyyyMMdd').format(dTarget);
    final key = _dateKeys[dateStr];

    if (key != null && key.currentContext != null) {
      // Scenario A: On-screen
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.04,
      );
    } else {
      // Scenario B: Off-screen (Lazy Loaded)
      // Since list is Descending (Top = EndDate), calculate index from End
      final dayIndex = dEnd.difference(dTarget).inDays.abs();

      // Estimate offset
      final estimatedOffset = dayIndex * 140.0;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetOffset =
          estimatedOffset > maxScroll ? maxScroll : estimatedOffset;

      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
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
      builder: (context, taskData, memberData, records) {
        _taskData = taskData; // Capture for Date Jump Logic

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
                initialAvatar: memberData!['avatar'] ?? 'pig',
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
        final String currency = taskData['baseCurrency'] ?? 'TWD';
        final double totalPool =
            (taskData['totalPool'] as num?)?.toDouble() ?? 0.0;
        final double remainderBuffer =
            (taskData['remainderBuffer'] as num?)?.toDouble() ?? 0.0;
        final String rule = taskData['balanceRule'] ?? 'random';
        final double myBalance = 0.0; // Mock
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
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // --- A. Segmented Control & B. Dashboard Card ---
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<int>(
                          segments: [
                            ButtonSegment(
                                value: 0,
                                label: Text(t.S13_Task_Dashboard.tab_group),
                                icon: const Icon(Icons.groups)),
                            ButtonSegment(
                                value: 1,
                                label: Text(t.S13_Task_Dashboard.tab_personal),
                                icon: const Icon(Icons.person)),
                          ],
                          selected: {_segmentIndex},
                          onSelectionChanged: (Set<int> newSelection) =>
                              setState(
                                  () => _segmentIndex = newSelection.first),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Card(
                        color: _segmentIndex == 0
                            ? colorScheme.primaryContainer
                            : colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _segmentIndex == 0
                                        ? t.S13_Task_Dashboard
                                            .label_prepay_balance
                                        : t.S13_Task_Dashboard.label_my_balance,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  if (_segmentIndex == 0)
                                    Chip(
                                        label: Text(_mapRuleName(rule)),
                                        padding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(currency,
                                      style: theme.textTheme.titleLarge),
                                  const SizedBox(width: 8),
                                  Text(
                                    _segmentIndex == 0
                                        ? totalPool.toStringAsFixed(1)
                                        : myBalance.toStringAsFixed(1),
                                    style: theme.textTheme.displayMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _segmentIndex == 0
                                                ? colorScheme.onPrimaryContainer
                                                : colorScheme
                                                    .onSecondaryContainer),
                                  ),
                                ],
                              ),
                              if (_segmentIndex == 0 && remainderBuffer > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    t.S13_Task_Dashboard.label_remainder(
                                        amount:
                                            remainderBuffer.toStringAsFixed(2)),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.textTheme.bodySmall?.color
                                            ?.withValues(alpha: 0.7)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Date Strip (Pinned) ---
              SliverPersistentHeader(
                pinned: true,
                delegate: _DateStripDelegate(
                  startDate: startDate,
                  endDate: endDate,
                  selectedDate: _selectedDateInStrip,
                  onDateSelected: (date) => _handleDateJump(context, date),
                ),
              ),

              // --- C. Full Date Record List ---
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final date = fullDateList[index];
                    final dayRecords = groupedRecords[date] ?? [];

                    // Calculate Daily Expense using Helper
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
                      key: _dateKeys[dateKeyStr], // Key attached here
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DailyHeader(
                            date: date, total: dayTotal, currency: currency),

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
                  },
                  childCount: fullDateList.length,
                ),
              ),

              // Extra padding at bottom
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }
}

class _DateStripDelegate extends SliverPersistentHeaderDelegate {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  _DateStripDelegate({
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
      color: theme.colorScheme.surface, // Solid background
      height: 72, // Increased height for padding
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
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
                                                : theme.colorScheme.onSurface)),
                              ),
                              const SizedBox(height: 4),
                              if (isToday)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              else
                                const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Padding bottom
        ],
      ),
    );
  }

  @override
  double get maxExtent => 72;

  @override
  double get minExtent => 72;

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
                  child: Text("Today",
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
    final title = data['title'] ?? 'Untitled';
    // date unused for display now
    final categoryId = data['categoryId'] as String?; // New

    // Icon logic: Income -> Savings, Expense -> Category Icon
    final icon = isIncome
        ? Icons.savings_outlined
        : CategoryConstant.getCategoryById(categoryId).icon;

    // Color logic: Income -> Green, Expense -> Red (Error)
    final color = isIncome ? const Color(0xFF4CAF50) : theme.colorScheme.error;

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
              ? const Color(0xFFE8F5E9) // Light Green
              : theme.colorScheme.tertiaryContainer,
          child: Icon(
            icon,
            color: isIncome
                ? const Color(0xFF2E7D32)
                : theme.colorScheme.onTertiaryContainer,
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
      List<QueryDocumentSnapshot> records) builder;

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
            return builder(context, taskData, memberData, records);
          },
        );
      },
    );
  }
}
