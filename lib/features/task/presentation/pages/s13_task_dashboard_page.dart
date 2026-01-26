import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/task/presentation/widgets/s13/s13_group_view.dart';
import 'package:iron_split/features/task/presentation/widgets/s13/s13_personal_view.dart';

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
              // Segmented Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() => _segmentIndex = newSelection.first);
                    },
                    showSelectedIcon: false,
                  ),
                ),
              ),

              // Content Switcher
              Expanded(
                child: _segmentIndex == 0
                    ? S13GroupView(
                        taskId: widget.taskId,
                        taskData: taskData,
                        memberData: memberData,
                        records: records,
                        prepayBalance: prepayBalance,
                        currency: currency,
                      )
                    : S13PersonalView(
                        taskId: widget.taskId,
                        taskData: taskData, // [新增] 傳入資料
                        memberData: memberData, // [新增] 傳入資料
                        records: records, // [新增] 傳入資料
                        currency: currency, // [新增] 傳入資料
                        uid: user.uid, // [新增] 傳入 UID 做過濾
                        prepayBalance: prepayBalance, // [新增] 傳入預付款
                      ),
              ),
            ],
          ),
        );
      },
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
