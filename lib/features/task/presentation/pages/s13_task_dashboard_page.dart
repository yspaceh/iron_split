import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/daily_statistics_helper.dart';
import 'package:iron_split/core/constants/category_constants.dart';
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
  bool _hasShownIntro = false;

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

  /// 邏輯：將 records 依照日期分組
  /// 修正：明確使用 QueryDocumentSnapshot
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
        // 1. D01 Intro Logic
        final bool hasSeenRoleIntro = memberData?['hasSeenRoleIntro'] ?? false;
        if (memberData != null && !hasSeenRoleIntro && !_hasShownIntro) {
          Future.microtask(() {
            if (!mounted) return;
            _hasShownIntro = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => D01MemberRoleIntroDialog(
                taskId: widget.taskId,
                initialAvatar: memberData['avatar'] ?? 'unknown',
                canReroll: !(memberData['hasRerolled'] ?? false),
              ),
            );
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

        // 3. Group Records by Date
        // ✅ 這裡現在不會報錯了，因為 records 是 List<QueryDocumentSnapshot>
        final groupedRecords = _groupRecords(records);
        final sortedDates = groupedRecords.keys.toList()
          ..sort((a, b) => b.compareTo(a));

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
          body: Column(
            children: [
              // --- A. Segmented Control ---
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        setState(() => _segmentIndex = newSelection.first),
                  ),
                ),
              ),

              // --- B. Dashboard Card ---
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _segmentIndex == 0
                                  ? t.S13_Task_Dashboard.label_prepay_balance
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
                            Text(currency, style: theme.textTheme.titleLarge),
                            const SizedBox(width: 8),
                            Text(
                              _segmentIndex == 0
                                  ? totalPool.toStringAsFixed(1)
                                  : myBalance.toStringAsFixed(1),
                              style: theme.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _segmentIndex == 0
                                      ? colorScheme.onPrimaryContainer
                                      : colorScheme.onSecondaryContainer),
                            ),
                          ],
                        ),
                        if (_segmentIndex == 0 && remainderBuffer > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              t.S13_Task_Dashboard.label_remainder(
                                  amount: remainderBuffer.toStringAsFixed(2)),
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

              const Divider(height: 1),

              // --- C. Grouped Record List ---
              Expanded(
                child: records.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long,
                                size: 48, color: colorScheme.outlineVariant),
                            const SizedBox(height: 16),
                            Text(t.S13_Task_Dashboard.empty_records,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          final date = sortedDates[index];
                          final dayRecords = groupedRecords[date]!;

                          // Calculate Daily Expense using Helper
                          final dayModels = dayRecords
                              .map((doc) => RecordModel.fromFirestore(doc))
                              .toList();
                          final dayTotal =
                              DailyStatisticsHelper.calculateDailyExpense(
                                  dayModels);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DailyHeader(
                                  date: date,
                                  total: dayTotal,
                                  currency: currency),
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
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Components ---

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

// ✅ 修正後的 MultiStreamBuilder：明確指定 List<QueryDocumentSnapshot>
class MultiStreamBuilder extends StatelessWidget {
  final String taskId;
  final String uid;
  final Widget Function(
      BuildContext context,
      Map<String, dynamic>? task,
      Map<String, dynamic>? member,
      List<QueryDocumentSnapshot> records // 修正此處型別
      ) builder;

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
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskId)
              .collection('members')
              .doc(uid)
              .snapshots(),
          builder: (context, memberSnapshot) {
            final memberData =
                memberSnapshot.data?.data() as Map<String, dynamic>?;
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(taskId)
                  .collection('records')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, recordSnapshot) {
                // recordSnapshot.data.docs 本身就是 List<QueryDocumentSnapshot>
                final records = recordSnapshot.data?.docs ?? [];
                return builder(context, taskData, memberData, records);
              },
            );
          },
        );
      },
    );
  }
}
