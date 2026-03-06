import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s17_task_locked_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskService extends Mock implements TaskService {}

class MockShareService extends Mock implements ShareService {}

class MockDeepLinkService extends Mock implements DeepLinkService {}

class MockSettlementService extends Mock implements SettlementService {}

class MockUser extends Mock implements User {}

class StubExportService extends ExportService {
  int generateCalls = 0;

  @override
  String generateProfessionalSettlementCsv({
    required records,
    required String taskName,
    required baseCurrency,
    required allMembers,
    required clearedMembers,
    required double totalExpense,
    required double totalPrepay,
    required double remainderBuffer,
    required String? absorbedBy,
    required Map<String, String> labels,
    required taskMembers,
  }) {
    generateCalls += 1;
    return 'csv-content';
  }
}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockTaskService mockTaskService;
  late MockShareService mockShareService;
  late StubExportService exportService;
  late MockDeepLinkService mockDeepLinkService;
  late MockSettlementService mockSettlementService;
  late MockUser mockUser;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockTaskService = MockTaskService();
    mockShareService = MockShareService();
    exportService = StubExportService();
    mockDeepLinkService = MockDeepLinkService();
    mockSettlementService = MockSettlementService();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockDeepLinkService.generateSettlementLink(any()))
        .thenReturn('https://ironsplit.app/locked/task-1');

    when(() => mockShareService.shareText(any(), subject: any(named: 'subject')))
        .thenAnswer((_) async {});
    when(() => mockShareService.shareFile(
          content: any(named: 'content'),
          fileName: any(named: 'fileName'),
          subject: any(named: 'subject'),
        )).thenAnswer((_) async {});

    when(() => mockRecordRepo.getRecordsOnce('task-1'))
        .thenAnswer((_) async => []);
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/locked/task-1',
      routes: [
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (context, state) =>
              S17TaskLockedPage(taskId: state.pathParameters['taskId']!),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (context, state) => Text('S13:${state.pathParameters['taskId']}'),
        ),
        GoRoute(path: '/task', name: 'S10', builder: (_, __) => const Text('S10')),
        GoRoute(
          path: '/task/:taskId/settings',
          name: 'S14',
          builder: (_, __) => const Text('S14'),
        ),
      ],
    );
  }

  Future<void> _pump(
    WidgetTester tester, {
    required TaskModel task,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    LocaleSettings.setLocale(AppLocale.enUs);

    when(() => mockTaskService.getValidatedTask('task-1'))
        .thenAnswer((_) async => task);
    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(task));

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<TaskService>.value(value: mockTaskService),
            Provider<ShareService>.value(value: mockShareService),
            Provider<ExportService>.value(value: exportService),
            Provider<DeepLinkService>.value(value: mockDeepLinkService),
            Provider<SettlementService>.value(value: mockSettlementService),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: true, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );

    for (int i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('S17TaskLockedPage widget test', () {
    testWidgets('task status 非 settled/closed 時，應自動導向 S13', (tester) async {
      await _pump(
        tester,
        task: _task(status: TaskStatus.ongoing),
      );

      expect(find.text('S13:task-1'), findsOneWidget);
    });

    testWidgets('settled 時應顯示 Notify Members 與 Download 按鈕', (tester) async {
      await _pump(
        tester,
        task: _task(status: TaskStatus.settled),
      );

      expect(find.widgetWithText(OutlinedButton, 'Notify Members'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Download'), findsOneWidget);
    });

    testWidgets('點擊 Notify Members / Download 應觸發通知與匯出流程', (tester) async {
      await _pump(
        tester,
        task: _task(status: TaskStatus.settled),
      );

      await tester.tap(find.widgetWithText(OutlinedButton, 'Notify Members'));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      verify(() => mockShareService.shareText(
            any(),
            subject: any(named: 'subject'),
          )).called(1);

      await tester.tap(find.widgetWithText(FilledButton, 'Download').first);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      verify(() => mockRecordRepo.getRecordsOnce('task-1')).called(1);
      expect(exportService.generateCalls, 1);
    });
  });
}

TaskModel _task({required TaskStatus status}) {
  final now = DateTime(2026, 1, 1);
  final snapshot = {
    'currencyCode': 'USD',
    'currencySymbol': r'$',
    'poolBalance': 0.0,
    'totalExpense': 100.0,
    'totalPrepay': 100.0,
    'remainder': 0.0,
    'expenseFlex': 500,
    'prepayFlex': 500,
    'ruleKey': RemainderRuleConstants.member,
    'isLocked': true,
    'expenseDetail': {'USD': 100.0},
    'prepayDetail': {'USD': 100.0},
    'poolDetail': {'USD': 0.0},
    'absorbedBy': null,
    'absorbedAmount': null,
  };

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
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member B',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: status,
    createdBy: 'u1',
    remainderRule: RemainderRuleConstants.member,
    remainderAbsorberId: 'u1',
    finalizedAt: now,
    createdAt: now,
    updatedAt: now,
    settlement: {
      'remainderWinnerId': 'u2',
      'allocations': {
        'u1': -10.0,
        'u2': 10.0,
      },
      'memberStatus': {
        'u1': false,
        'u2': true,
      },
      'viewStatus': {
        'u1': true,
        'u2': false,
      },
      'dashboardSnapshot': snapshot,
    },
  );
}
