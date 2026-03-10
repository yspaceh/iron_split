import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSettlementService extends Mock implements SettlementService {}

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSystemRepository extends Mock implements SystemRepository {}

class MockUser extends Mock implements User {}

class FakeTaskModel extends Fake implements TaskModel {}

class FakeRecordModel extends Fake implements RecordModel {}

class FakePaymentInfoModel extends Fake implements PaymentInfoModel {}

void main() {
  late MockSettlementService mockSettlementService;
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockSystemRepository mockSystemRepo;
  late MockUser mockUser;

  setUpAll(() {
    registerFallbackValue(FakeTaskModel());
    registerFallbackValue(FakeRecordModel());
    registerFallbackValue(FakePaymentInfoModel());
  });

  setUp(() {
    mockSettlementService = MockSettlementService();
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockSystemRepo = MockSystemRepository();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(_task()));
    when(() => mockRecordRepo.streamRecords('task-1'))
        .thenAnswer((_) => Stream.value(_records()));

    when(() => mockSystemRepo.getDefaultPaymentInfo())
        .thenAnswer((_) async => null);
    when(() => mockSystemRepo.saveDefaultPaymentInfo(any()))
        .thenAnswer((_) async {});

    when(
      () => mockSettlementService.executeSettlement(
        task: any(named: 'task'),
        records: any(named: 'records'),
        mergeMap: any(named: 'mergeMap'),
        captainPaymentInfoJson: any(named: 'captainPaymentInfoJson'),
        checkPointPoolBalance: any(named: 'checkPointPoolBalance'),
      ),
    ).thenAnswer((_) async => 'u1');
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/preview/payment',
      routes: [
        GoRoute(
          path: '/preview',
          name: 'S30',
          builder: (context, state) => const Text('PREVIEW'),
          routes: [
            GoRoute(
              path: 'payment',
              name: 'S31',
              builder: (context, state) => const S31SettlementPaymentInfoPage(
                taskId: 'task-1',
                checkPointPoolBalance: 100.0,
                mergeMap: {
                  'u1': ['u2']
                },
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/task/:taskId/result',
          name: 'S32',
          builder: (context, state) =>
              Text('RESULT:${state.pathParameters['taskId']}'),
        ),
      ],
    );
  }

  Future<void> pump(WidgetTester tester) async {
    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<SettlementService>.value(value: mockSettlementService),
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<SystemRepository>.value(value: mockSystemRepo),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  Future<void> confirmSettlement(WidgetTester tester) async {
    await tester.tap(find.text('Settle').first);
    await tester.pumpAndSettle();

    expect(find.text('Settlement'), findsOneWidget);
    expect(find.textContaining('The task will be locked upon settlement'),
        findsOneWidget);

    await tester.tap(find.text('Settle').last);
    await tester.pumpAndSettle();
  }

  group('S31SettlementPaymentInfoPage widget test', () {
    testWidgets('核心測試 1: 點擊 Settle 應顯示結算確認 Dialog', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Settle').first);
      await tester.pumpAndSettle();

      expect(find.text('Settlement'), findsOneWidget);
      expect(find.textContaining('Records cannot be added, deleted, or edited'),
          findsOneWidget);
    });

    testWidgets('核心測試 2: 成功結算時應呼叫 executeSettlement 並導向結果頁', (tester) async {
      await pump(tester);
      await confirmSettlement(tester);

      verify(
        () => mockSettlementService.executeSettlement(
          task: any(named: 'task'),
          records: any(named: 'records'),
          mergeMap: const {
            'u1': ['u2']
          },
          captainPaymentInfoJson: any(named: 'captainPaymentInfoJson'),
          checkPointPoolBalance: 100.0,
        ),
      ).called(1);

      expect(find.text('RESULT:task-1'), findsOneWidget);
    });

    testWidgets('核心測試 3: dataConflict 時顯示衝突提示並返回前一步', (tester) async {
      when(
        () => mockSettlementService.executeSettlement(
          task: any(named: 'task'),
          records: any(named: 'records'),
          mergeMap: any(named: 'mergeMap'),
          captainPaymentInfoJson: any(named: 'captainPaymentInfoJson'),
          checkPointPoolBalance: any(named: 'checkPointPoolBalance'),
        ),
      ).thenThrow(AppErrorCodes.dataConflict);

      await pump(tester);
      await confirmSettlement(tester);

      expect(find.text('Data Changed'), findsOneWidget);
      expect(
        find.textContaining(
            'Other members updated the records while you were viewing'),
        findsOneWidget,
      );

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      verify(
        () => mockSettlementService.executeSettlement(
          task: any(named: 'task'),
          records: any(named: 'records'),
          mergeMap: any(named: 'mergeMap'),
          captainPaymentInfoJson: any(named: 'captainPaymentInfoJson'),
          checkPointPoolBalance: any(named: 'checkPointPoolBalance'),
        ),
      ).called(1);

      expect(find.text('Data Changed'), findsNothing);
      expect(find.text('RESULT:task-1'), findsNothing);
    });

    testWidgets('核心測試 4: 切換為公開收款後，結算時應儲存預設收款資訊', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Share payment details'));
      await tester.pumpAndSettle();

      expect(
        find.text(
            'Save as default payment information (stored on this device)'),
        findsOneWidget,
      );

      await confirmSettlement(tester);

      verify(() => mockSystemRepo.saveDefaultPaymentInfo(any())).called(1);
      expect(find.text('RESULT:task-1'), findsOneWidget);
    });
  });
}

TaskModel _task() {
  final now = DateTime(2026, 1, 1);
  return TaskModel(
    id: 'task-1',
    name: 'Tokyo Trip',
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
        expense: 80.0,
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member B',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
        prepaid: 40.0,
        expense: 80.0,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: TaskStatus.pending,
    createdBy: 'u1',
    remainderRule: 'member',
    remainderAbsorberId: 'u1',
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
      title: 'Lunch',
      type: RecordType.expense,
      amount: 100,
      currencyCode: 'USD',
      exchangeRate: 1,
      splitMemberIds: const ['u1', 'u2'],
      payersId: const ['u1'],
    ),
    RecordModel(
      id: 'r2',
      date: now,
      title: 'Pool top-up',
      type: RecordType.prepay,
      amount: 100,
      currencyCode: 'USD',
      exchangeRate: 1,
      payersId: const ['u1'],
    ),
  ];
}
