import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/pages/s30_settlement_confirm_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart';
import 'package:iron_split/features/settlement/presentation/pages/s32_settlement_result_page.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSystemRepository extends Mock implements SystemRepository {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockShareService extends Mock implements ShareService {}

class MockUser extends Mock implements User {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockSystemRepository mockSystemRepo;
  late MockDeepLinkService mockDeepLinkService;
  late MockShareService mockShareService;
  late MockUser mockUser;

  late SettlementService settlementService;
  late TaskModel task;
  late List<RecordModel> records;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockSystemRepo = MockSystemRepository();
    mockDeepLinkService = MockDeepLinkService();
    mockShareService = MockShareService();
    mockUser = MockUser();
    settlementService = SettlementService(mockTaskRepo);

    task = _task();
    records = _records();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockUser.displayName).thenReturn('Captain');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockTaskRepo.getTaskOnce('task-1'))
        .thenAnswer((_) async => task);
    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(task));
    when(() => mockRecordRepo.streamRecords('task-1'))
        .thenAnswer((_) => Stream.value(records));

    when(() => mockTaskRepo.updateTaskStatus(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockTaskRepo.settleTask(
          taskId: any(named: 'taskId'),
          settlementData: any(named: 'settlementData'),
        )).thenAnswer((_) async {});
    when(() => mockTaskRepo.updateTask(any(), any())).thenAnswer((_) async {});

    when(() => mockSystemRepo.getDefaultPaymentInfo())
        .thenAnswer((_) async => null);

    when(() => mockDeepLinkService.generateSettlementLink(any()))
        .thenReturn('https://ironsplit.app/locked/task-1');
    when(() =>
            mockShareService.shareText(any(), subject: any(named: 'subject')))
        .thenAnswer((_) async {});
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/host',
      routes: [
        GoRoute(
          path: '/host',
          builder: (context, state) => _AutoPushS30Host(
            taskId: 'task-1',
            onLock: () => mockTaskRepo.updateTaskStatus('task-1', 'pending'),
          ),
        ),
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (context, state) =>
              Text('S17:${state.pathParameters['taskId']}'),
        ),
        GoRoute(
          path: '/task/:taskId',
          builder: (context, state) => const SizedBox.shrink(),
          routes: [
            GoRoute(
              path: 'settlement/preview',
              name: 'S30',
              builder: (context, state) => S30SettlementConfirmPage(
                  taskId: state.pathParameters['taskId']!),
              routes: [
                GoRoute(
                  path: 'settlement/payment',
                  name: 'S31',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    return S31SettlementPaymentInfoPage(
                      taskId: state.pathParameters['taskId']!,
                      checkPointPoolBalance:
                          extra['checkPointPoolBalance'] as double,
                      mergeMap:
                          (extra['mergeMap'] as Map<String, List<String>>?) ??
                              const {},
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'settlement/result',
              name: 'S32',
              builder: (context, state) => S32SettlementResultPage(
                  taskId: state.pathParameters['taskId']!),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pumpFrames(WidgetTester tester,
      {int times = 20,
      Duration step = const Duration(milliseconds: 100)}) async {
    for (int i = 0; i < times; i++) {
      await tester.pump(step);
    }
  }

  Future<void> _pumpFlowApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<SystemRepository>.value(value: mockSystemRepo),
            Provider<DeepLinkService>.value(value: mockDeepLinkService),
            Provider<ShareService>.value(value: mockShareService),
            Provider<DashboardService>.value(value: DashboardService()),
            Provider<SettlementService>.value(value: settlementService),
            ChangeNotifierProvider<ThemeViewModel>(
              create: (_) => ThemeViewModel(),
            ),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );
    await _pumpFrames(tester);
  }

  group('MVP Integration - Settlement Flow', () {
    testWidgets(
      'S13 lock -> S30 preview -> S31 execute -> S32 result -> seen status',
      (tester) async {
        await _pumpFlowApp(tester);

        expect(find.text('Confirm Settlement'), findsOneWidget);
        await tester.tap(find.text('Payment Info'));
        await _pumpFrames(tester);

        expect(find.text('Payment Information'), findsOneWidget);
        final s31Settle = find.widgetWithText(FilledButton, 'Settle');
        await tester.tap(s31Settle.first);
        await _pumpFrames(tester);
        await tester.tap(s31Settle.last);
        await _pumpFrames(tester);

        expect(find.text('Settlement Complete'), findsOneWidget);
        await tester.tap(find.text('Back to Task'));
        await _pumpFrames(tester);

        expect(find.text('S17:task-1'), findsOneWidget);

        verify(() => mockTaskRepo.updateTaskStatus('task-1', 'pending'))
            .called(1);
        verify(() => mockTaskRepo.settleTask(
              taskId: 'task-1',
              settlementData: any(named: 'settlementData'),
            )).called(1);
        verify(() => mockTaskRepo.updateTask(
              'task-1',
              {'settlement.viewStatus.u1': true},
            )).called(1);
      },
    );

    testWidgets(
      'S31 dataConflict should recover to S30 and must not navigate to S32',
      (tester) async {
        final recordsController = StreamController<List<RecordModel>>.broadcast();
        addTearDown(recordsController.close);

        when(() => mockRecordRepo.streamRecords('task-1'))
            .thenAnswer((_) => recordsController.stream);

        await _pumpFlowApp(tester);
        recordsController.add(_records());
        await _pumpFrames(tester, times: 5);

        expect(find.text('Confirm Settlement'), findsOneWidget);
        await tester.tap(find.text('Payment Info'));
        await _pumpFrames(tester);
        expect(find.text('Payment Information'), findsOneWidget);

        // Simulate background record update after checkpoint is captured at S30.
        recordsController.add(_records(prepayAmount: 101.0));
        await _pumpFrames(tester, times: 5);

        final s31Settle = find.widgetWithText(FilledButton, 'Settle');
        await tester.tap(s31Settle.first);
        await _pumpFrames(tester);
        await tester.tap(s31Settle.last);
        await _pumpFrames(tester);

        expect(find.text('Data Changed'), findsOneWidget);
        await tester.tap(find.text('Back'));
        await _pumpFrames(tester);

        expect(find.text('Settlement Complete'), findsNothing);
        expect(find.text('Data Changed'), findsNothing);
        verifyNever(
          () => mockTaskRepo.settleTask(
            taskId: any(named: 'taskId'),
            settlementData: any(named: 'settlementData'),
          ),
        );
      },
    );

    testWidgets(
      'S31 taskStatusError should stay on S31 and must not navigate to S32',
      (tester) async {
        final taskController = StreamController<TaskModel>.broadcast();
        addTearDown(taskController.close);

        when(() => mockTaskRepo.streamTask('task-1'))
            .thenAnswer((_) => taskController.stream);

        await _pumpFlowApp(tester);
        taskController.add(_task(status: TaskStatus.ongoing));
        await _pumpFrames(tester, times: 5);

        expect(find.text('Confirm Settlement'), findsOneWidget);
        await tester.tap(find.text('Payment Info'));
        await _pumpFrames(tester);
        // Re-emit for S31 subscriber (stream does not replay old events).
        taskController.add(_task(status: TaskStatus.ongoing));
        await _pumpFrames(tester, times: 5);
        expect(find.text('Payment Information'), findsOneWidget);

        // Simulate task already settled by others before current user confirms.
        taskController.add(_task(status: TaskStatus.settled));
        await _pumpFrames(tester, times: 5);

        final s31Settle = find.widgetWithText(FilledButton, 'Settle');
        await tester.tap(s31Settle.first);
        await _pumpFrames(tester);
        await tester.tap(s31Settle.last);
        await _pumpFrames(tester);

        expect(find.text('Error'), findsOneWidget);
        await tester.tap(find.text('OK'));
        await _pumpFrames(tester);

        expect(find.text('Error'), findsNothing);
        expect(find.text('Settlement Complete'), findsNothing);
        verifyNever(
          () => mockTaskRepo.settleTask(
            taskId: any(named: 'taskId'),
            settlementData: any(named: 'settlementData'),
          ),
        );
      },
    );

    testWidgets(
      'S31 race condition: task/record streams mutate together should deterministically recover with dataConflict',
      (tester) async {
        final taskController = StreamController<TaskModel>.broadcast();
        final recordsController = StreamController<List<RecordModel>>.broadcast();
        addTearDown(taskController.close);
        addTearDown(recordsController.close);

        when(() => mockTaskRepo.streamTask('task-1'))
            .thenAnswer((_) => taskController.stream);
        when(() => mockRecordRepo.streamRecords('task-1'))
            .thenAnswer((_) => recordsController.stream);

        await _pumpFlowApp(tester);
        taskController.add(_task(status: TaskStatus.ongoing));
        recordsController.add(_records(prepayAmount: 100.0));
        await _pumpFrames(tester, times: 5);

        expect(find.text('Confirm Settlement'), findsOneWidget);
        await tester.tap(find.text('Payment Info'));
        await _pumpFrames(tester);
        // Re-emit for S31 subscribers (stream does not replay old events).
        taskController.add(_task(status: TaskStatus.ongoing));
        recordsController.add(_records(prepayAmount: 100.0));
        await _pumpFrames(tester, times: 5);
        expect(find.text('Payment Information'), findsOneWidget);

        final s31Settle = find.widgetWithText(FilledButton, 'Settle');
        await tester.tap(s31Settle.first);
        await _pumpFrames(tester, times: 2);

        // Simulate near-simultaneous stream changes right before final confirm.
        // Keep task ongoing but change records to force dataConflict deterministically.
        recordsController.add(_records(prepayAmount: 123.0));
        taskController.add(_task(status: TaskStatus.ongoing));
        await _pumpFrames(tester, times: 5);

        await tester.tap(s31Settle.last);
        await _pumpFrames(tester);

        expect(find.text('Data Changed'), findsOneWidget);
        expect(find.text('Error'), findsNothing);
        await tester.tap(find.text('Back'));
        await _pumpFrames(tester);
        expect(find.text('Data Changed'), findsNothing);

        expect(find.text('Settlement Complete'), findsNothing);
        verifyNever(
          () => mockTaskRepo.settleTask(
            taskId: any(named: 'taskId'),
            settlementData: any(named: 'settlementData'),
          ),
        );
      },
    );
  });
}

TaskModel _task({TaskStatus status = TaskStatus.ongoing}) {
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
        prepaid: 100.0,
        expense: 40.0,
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member B',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
        prepaid: 0.0,
        expense: 60.0,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: status,
    createdBy: 'u1',
    remainderRule: RemainderRuleConstants.member,
    remainderAbsorberId: 'u1',
    startDate: now,
    endDate: now.add(const Duration(days: 2)),
    createdAt: now,
    updatedAt: now,
  );
}

List<RecordModel> _records({double prepayAmount = 100.0}) {
  return [
    RecordModel(
      id: 'r1',
      date: DateTime(2026, 1, 1),
      title: 'Prepay',
      type: RecordType.prepay,
      payerType: PayerType.prepay,
      payersId: const ['u1'],
      amount: prepayAmount,
      currencyCode: 'USD',
      exchangeRate: 1.0,
      remainder: 0.0,
      splitMethod: SplitMethodConstant.even,
      splitMemberIds: const ['u1', 'u2'],
    ),
    RecordModel(
      id: 'r2',
      date: DateTime(2026, 1, 1),
      title: 'Expense',
      type: RecordType.expense,
      payerType: PayerType.prepay,
      payersId: const ['u1'],
      amount: 100.0,
      currencyCode: 'USD',
      exchangeRate: 1.0,
      remainder: 0.0,
      splitMethod: SplitMethodConstant.even,
      splitMemberIds: const ['u1', 'u2'],
    ),
  ];
}

class _AutoPushS30Host extends StatefulWidget {
  const _AutoPushS30Host({
    required this.taskId,
    required this.onLock,
  });

  final String taskId;
  final Future<void> Function() onLock;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await widget.onLock();
      if (!mounted) return;
      context.pushNamed('S30', pathParameters: {'taskId': widget.taskId});
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
