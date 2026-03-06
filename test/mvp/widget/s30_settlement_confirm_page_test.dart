import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/pages/s30_settlement_confirm_page.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockDashboardService extends Mock implements DashboardService {}

class MockSettlementService extends Mock implements SettlementService {}

class MockUser extends Mock implements User {}

class FakeTaskModel extends Fake implements TaskModel {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockDashboardService mockDashboardService;
  late MockSettlementService mockSettlementService;
  late MockUser mockUser;

  late TaskModel task;
  late List<RecordModel> records;
  late BalanceSummaryState currentBalanceState;
  late List<SettlementMember> currentSettlementMembers;

  setUpAll(() {
    registerFallbackValue(FakeTaskModel());
  });

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockDashboardService = MockDashboardService();
    mockSettlementService = MockSettlementService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    task = _task(remainderRule: RemainderRuleConstants.member);
    records = _records();
    currentBalanceState = _balanceState(
      rule: task.remainderRule,
      remainder: 0.0,
      poolBalance: 100.0,
    );
    currentSettlementMembers = _settlementMembers(task);

    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(task));
    when(() => mockRecordRepo.streamRecords('task-1'))
        .thenAnswer((_) => Stream.value(records));

    when(() => mockTaskRepo.updateTaskStatus(any(), any()))
        .thenAnswer((_) async {});

    when(
      () => mockDashboardService.calculateBalanceState(
        task: any(named: 'task'),
        records: any(named: 'records'),
        currentUserId: any(named: 'currentUserId'),
      ),
    ).thenAnswer((_) => currentBalanceState);

    when(
      () => mockSettlementService.calculateSettlementMembers(
        task: any(named: 'task'),
        records: any(named: 'records'),
        remainderRule: any(named: 'remainderRule'),
        remainderAbsorberId: any(named: 'remainderAbsorberId'),
        mergeMap: any(named: 'mergeMap'),
      ),
    ).thenAnswer((_) => currentSettlementMembers);
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/host',
      routes: [
        GoRoute(
          path: '/host',
          builder: (context, state) => const _AutoPushS30Host(taskId: 'task-1'),
        ),
        GoRoute(
          path: '/task/:taskId/settlement/preview',
          name: 'S30',
          builder: (context, state) =>
              S30SettlementConfirmPage(taskId: state.pathParameters['taskId']!),
        ),
        GoRoute(
          path: '/task/:taskId/settlement/payment',
          name: 'S31',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final cp = extra?['checkPointPoolBalance'];
            final map = extra?['mergeMap'] as Map<String, List<String>>?;
            final merged = map == null ? '' : (map['u1']?.join(',') ?? '');
            return Text('S31:${state.pathParameters['taskId']}:$cp:$merged');
          },
        ),
      ],
    );
  }

  Future<void> _pump(WidgetTester tester) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<DashboardService>.value(value: mockDashboardService),
            Provider<SettlementService>.value(value: mockSettlementService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('S30SettlementConfirmPage widget test', () {
    testWidgets('應正確渲染標題、成員與底部操作按鈕', (tester) async {
      await _pump(tester);

      expect(find.text('Confirm Settlement'), findsOneWidget);
      expect(find.text('Captain'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Payment Info'), findsOneWidget);
    });

    testWidgets('點擊 Payment Info 應導航到 S31 並帶入 checkpoint 與 mergeMap',
        (tester) async {
      await _pump(tester);

      await tester.tap(find.text('Payment Info'));
      await tester.pumpAndSettle();

      expect(find.text('S31:task-1:100.0:'), findsOneWidget);
    });

    testWidgets('點擊 Cancel 應呼叫 updateTaskStatus(taskId, ongoing)',
        (tester) async {
      await _pump(tester);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verify(() => mockTaskRepo.updateTaskStatus('task-1', 'ongoing'))
          .called(1);
    });

    testWidgets('random + remainder > 0 時應顯示 random_reveal 提示',
        (tester) async {
      task = _task(remainderRule: RemainderRuleConstants.random);
      currentBalanceState = _balanceState(
        rule: task.remainderRule,
        remainder: 0.02,
        poolBalance: 0.0,
      );
      currentSettlementMembers = _settlementMembers(task);
      when(() => mockTaskRepo.streamTask('task-1'))
          .thenAnswer((_) => Stream.value(task));

      await _pump(tester);

      expect(find.text('Remainder will be revealed after settlement.'),
          findsOneWidget);
    });
  });
}

class _AutoPushS30Host extends StatefulWidget {
  final String taskId;

  const _AutoPushS30Host({required this.taskId});

  @override
  State<_AutoPushS30Host> createState() => _AutoPushS30HostState();
}

class _AutoPushS30HostState extends State<_AutoPushS30Host> {
  bool _pushed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pushed) return;
    _pushed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.pushNamed('S30', pathParameters: {'taskId': widget.taskId});
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

TaskModel _task({required String remainderRule}) {
  final now = DateTime(2026, 1, 1);
  return TaskModel(
    id: 'task-1',
    name: 'Trip',
    baseCurrency: 'USD',
    members: {
      'u1': TaskMember(
        id: 'u1',
        displayName: 'Captain',
        isLinked: true,
        role: 'captain',
        joinedAt: now,
        createdAt: now,
        prepaid: 120.0,
        expense: 20.0,
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member B',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
        prepaid: 0.0,
        expense: 80.0,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: TaskStatus.pending,
    createdBy: 'u1',
    remainderRule: remainderRule,
    remainderAbsorberId:
        remainderRule == RemainderRuleConstants.member ? 'u1' : null,
    createdAt: now,
    updatedAt: now,
  );
}

List<RecordModel> _records() {
  final now = DateTime(2026, 1, 2, 12);
  return [
    RecordModel(
      id: 'r1',
      date: now,
      title: 'Top up',
      type: RecordType.prepay,
      amount: 100,
      currencyCode: 'USD',
      exchangeRate: 1,
      payersId: const ['u1'],
    ),
  ];
}

BalanceSummaryState _balanceState({
  required String rule,
  required double remainder,
  required double poolBalance,
}) {
  return BalanceSummaryState(
    currencyCode: 'USD',
    currencySymbol: '\$',
    poolBalance: poolBalance,
    totalExpense: 20,
    totalPrepay: 120,
    remainder: remainder,
    expenseFlex: 143,
    prepayFlex: 857,
    ruleKey: rule,
    isLocked: true,
    expenseDetail: const {'USD': 20},
    prepayDetail: const {'USD': 120},
    poolDetail: {'USD': poolBalance},
  );
}

List<SettlementMember> _settlementMembers(TaskModel task) {
  final captain = task.members['u1']!;
  final memberB = task.members['u2']!;
  return [
    SettlementMember(
      memberData: captain,
      finalAmount: 10,
      baseAmount: 10,
      remainderAmount: 0,
      isRemainderAbsorber: false,
    ),
    SettlementMember(
      memberData: memberB,
      finalAmount: -10,
      baseAmount: -10,
      remainderAmount: 0,
      isRemainderAbsorber: false,
    ),
  ];
}
