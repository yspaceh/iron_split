import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(widget.taskId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text(t.common.loading);
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            return Text(data?['name'] ?? t.S13_Task_Dashboard.title);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/tasks/${widget.taskId}/settings'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.pushNamed('S15', pathParameters: {'taskId': widget.taskId}),
        icon: const Icon(Icons.add),
        label: Text(t.S13_Task_Dashboard.fab_record),
      ),
      body: MultiStreamBuilder(
        taskId: widget.taskId,
        uid: user.uid,
        builder: (context, taskData, memberData, records) {
          // 1. D01 Intro Logic
          final bool hasSeenRoleIntro =
              memberData?['hasSeenRoleIntro'] ?? false;
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
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Data Preparation
          final String currency = taskData['baseCurrency'] ?? 'TWD';
          final double totalPool =
              (taskData['totalPool'] as num?)?.toDouble() ?? 0.0;
          final double remainderBuffer =
              (taskData['remainderBuffer'] as num?)?.toDouble() ?? 0.0;
          final String rule = taskData['balanceRule'] ?? 'random';
          final double myBalance = 0.0; // Mock

          // 3. Group Records by Date
          // ✅ 這裡現在不會報錯了，因為 records 是 List<QueryDocumentSnapshot>
          final groupedRecords = _groupRecords(records);
          final sortedDates = groupedRecords.keys.toList()
            ..sort((a, b) => b.compareTo(a));

          return Column(
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

                          // 計算當日小計
                          double dayTotal = 0;
                          for (var doc in dayRecords) {
                            final d = doc.data() as Map<String, dynamic>;
                            if (d['type'] == 'expense') {
                              dayTotal +=
                                  (d['amount'] as num?)?.toDouble() ?? 0.0;
                            }
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DailyHeader(
                                  date: date,
                                  total: dayTotal,
                                  currency: currency),
                              ...dayRecords.map((doc) {
                                final rData =
                                    doc.data() as Map<String, dynamic>;
                                return _RecordItem(
                                    data: rData, recordId: doc.id);
                              }),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
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
          Text("Exp: $total $currency",
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _RecordItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final String recordId;

  const _RecordItem({required this.data, required this.recordId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpense = data['type'] == 'expense';
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = data['currency'] ?? '';
    final title = data['title'] ?? 'Untitled';
    final date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();

    return ListTile(
      onTap: () => context.pushNamed('S15', queryParameters: {'id': recordId}),
      leading: CircleAvatar(
        backgroundColor: isExpense
            ? theme.colorScheme.tertiaryContainer
            : theme.colorScheme.primaryContainer,
        child: Icon(
          isExpense ? Icons.shopping_bag : Icons.savings,
          color: isExpense
              ? theme.colorScheme.onTertiaryContainer
              : theme.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(DateFormat('HH:mm').format(date)),
      trailing: Text(
        '${isExpense ? '-' : '+'} $amount $currency',
        style: theme.textTheme.titleMedium?.copyWith(
          color:
              isExpense ? theme.colorScheme.error : theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
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
