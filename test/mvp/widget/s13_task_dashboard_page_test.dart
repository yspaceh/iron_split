import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s13_task_dashboard_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTaskService extends Mock implements TaskService {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockTaskService mockTaskService;
  late MockUser mockUser;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockTaskService = MockTaskService();
    mockUser = MockUser();

    when(() => mockTaskRepo.updateTaskStatus(any(), any()))
        .thenAnswer((_) async {});
    when(() => mockRecordRepo.streamRecords('task-1'))
        .thenAnswer((_) => Stream.value(const []));
  });

  GoRouter _router() {
    return GoRouter(
      initialLocation: '/task/task-1',
      routes: [
        GoRoute(
          path: '/task',
          name: 'S10',
          builder: (context, state) => const Text('S10'),
        ),
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (context, state) => Text('S17:${state.pathParameters['taskId']}'),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (context, state) =>
              S13TaskDashboardPage(taskId: state.pathParameters['taskId']!),
          routes: [
            GoRoute(
              path: 'settlement/preview',
              name: 'S30',
              builder: (context, state) =>
                  Text('S30:${state.pathParameters['taskId']}'),
            ),
            GoRoute(
              path: 'record',
              name: 'S15',
              builder: (context, state) => const Text('S15'),
            ),
            GoRoute(
              path: 'settings',
              name: 'S14',
              builder: (context, state) => const Text('S14'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pump(
    WidgetTester tester, {
    required String currentUserId,
    required TaskModel task,
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(() => mockUser.uid).thenReturn(currentUserId);
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
    when(() => mockTaskService.getValidatedTask('task-1'))
        .thenAnswer((_) async => task);
    when(() => mockTaskRepo.streamTask('task-1'))
        .thenAnswer((_) => Stream.value(task));

    LocaleSettings.setLocale(AppLocale.enUs);

    await tester.pumpWidget(
      TranslationProvider(
        child: MultiProvider(
          providers: [
            Provider<TaskRepository>.value(value: mockTaskRepo),
            Provider<RecordRepository>.value(value: mockRecordRepo),
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<TaskService>.value(value: mockTaskService),
            Provider<DashboardService>.value(value: DashboardService()),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: true, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: _router()),
        ),
      ),
    );

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('S13TaskDashboardPage widget test', () {
    testWidgets('Captain: 應顯示 Settle + Add，點擊 Settle 會鎖定並進入 S30',
        (tester) async {
      await _pump(
        tester,
        currentUserId: 'u1',
        task: _task(status: TaskStatus.ongoing, createdBy: 'u1'),
      );

      expect(find.widgetWithText(OutlinedButton, 'Settle'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Add'), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Settle'));
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      verify(() => mockTaskRepo.updateTaskStatus('task-1', 'pending')).called(1);
      expect(find.text('S30:task-1'), findsOneWidget);
    });

    testWidgets('Member: 應只顯示 Add，不顯示 Settle', (tester) async {
      await _pump(
        tester,
        currentUserId: 'u2',
        task: _task(status: TaskStatus.ongoing, createdBy: 'u1'),
      );

      expect(find.widgetWithText(OutlinedButton, 'Settle'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Add'), findsOneWidget);
    });

    testWidgets('Settled 非隊長：應自動導向 S17', (tester) async {
      await _pump(
        tester,
        currentUserId: 'u2',
        task: _task(status: TaskStatus.settled, createdBy: 'u1'),
      );

      expect(find.text('S17:task-1'), findsOneWidget);
    });
  });
}

TaskModel _task({required TaskStatus status, required String createdBy}) {
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
        hasSeenRoleIntro: true,
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
        hasSeenRoleIntro: true,
      ),
    },
    memberIds: const ['u1', 'u2'],
    status: status,
    createdBy: createdBy,
    remainderRule: RemainderRuleConstants.member,
    remainderAbsorberId: 'u1',
    startDate: now,
    endDate: now,
    createdAt: now,
    updatedAt: now,
  );
}
