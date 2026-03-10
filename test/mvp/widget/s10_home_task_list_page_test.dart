import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s10_home_task_list_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../helpers/mock_analytics_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAuthRepository mockAuthRepo;
  late MockUser mockUser;
  late MockAnalyticsService mockAnalyticsService;
  late StreamController<List<TaskModel>> tasksController;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAuthRepo = MockAuthRepository();
    mockUser = MockUser();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);
    tasksController = StreamController<List<TaskModel>>.broadcast();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);
    when(() => mockTaskRepo.streamUserTasks('u1'))
        .thenAnswer((_) => tasksController.stream);
  });

  tearDown(() async {
    await tasksController.close();
  });

  GoRouter router() {
    return GoRouter(
      initialLocation: '/task',
      routes: [
        GoRoute(
          path: '/task',
          name: 'S10',
          builder: (_, __) => const S10HomeTaskListPage(),
        ),
        GoRoute(
          path: '/task/:taskId',
          name: 'S13',
          builder: (_, state) => Text('S13:${state.pathParameters['taskId']}'),
        ),
        GoRoute(
          path: '/locked/:taskId',
          name: 'S17',
          builder: (_, state) => Text('S17:${state.pathParameters['taskId']}'),
        ),
        GoRoute(
            path: '/task/enter-code',
            name: 'S18',
            builder: (_, __) => const Text('S18')),
        GoRoute(
            path: '/task/create',
            name: 'S16',
            builder: (_, __) => const Text('S16')),
        GoRoute(
            path: '/settings',
            name: 'S70',
            builder: (_, __) => const Text('S70')),
      ],
    );
  }

  Future<void> pump(WidgetTester tester) async {
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
            Provider<AuthRepository>.value(value: mockAuthRepo),
            Provider<AnalyticsService>.value(value: mockAnalyticsService),
            Provider<TaskService>.value(
              value: TaskService(
                taskRepo: mockTaskRepo,
                analyticsService: mockAnalyticsService,
              ),
            ),
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router()),
        ),
      ),
    );

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('S10HomeTaskListPage widget test', () {
    testWidgets('空態：Active/Finished 都應顯示對應 empty 文案', (tester) async {
      await pump(tester);
      tasksController.add(const []);
      await tester.pumpAndSettle();

      expect(find.text('No active tasks'), findsOneWidget);

      await tester.tap(find.text('Finished'));
      await tester.pumpAndSettle();
      expect(find.text('No finished tasks'), findsOneWidget);
    });

    testWidgets('有資料：應依分頁顯示 ongoing / settled 任務', (tester) async {
      await pump(tester);
      tasksController.add([
        _task(
            id: 't-ongoing', name: 'Trip Ongoing', status: TaskStatus.ongoing),
        _task(
            id: 't-settled', name: 'Trip Settled', status: TaskStatus.settled),
      ]);
      await tester.pumpAndSettle();

      expect(find.text('Trip Ongoing'), findsOneWidget);
      expect(find.text('Trip Settled'), findsNothing);

      await tester.tap(find.text('Finished'));
      await tester.pumpAndSettle();

      expect(find.text('Trip Settled'), findsOneWidget);
      expect(find.text('Trip Ongoing'), findsNothing);
    });

    testWidgets('點擊任務：ongoing 導 S13，settled 導 S17', (tester) async {
      await pump(tester);
      tasksController.add([
        _task(
            id: 't-ongoing', name: 'Trip Ongoing', status: TaskStatus.ongoing),
        _task(
            id: 't-settled', name: 'Trip Settled', status: TaskStatus.settled),
      ]);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Trip Ongoing'));
      await tester.pumpAndSettle();
      expect(find.text('S13:t-ongoing'), findsOneWidget);

      await pump(tester);
      tasksController.add([
        _task(
            id: 't-settled', name: 'Trip Settled', status: TaskStatus.settled),
      ]);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Finished'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Trip Settled'));
      await tester.pumpAndSettle();
      expect(find.text('S17:t-settled'), findsOneWidget);
    });
  });
}

TaskModel _task({
  required String id,
  required String name,
  required TaskStatus status,
}) {
  final now = DateTime(2026, 1, 1);
  return TaskModel(
    id: id,
    name: name,
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
    },
    memberIds: const ['u1'],
    status: status,
    createdBy: 'u1',
    remainderRule: 'member',
    remainderAbsorberId: 'u1',
    startDate: now,
    endDate: now.add(const Duration(days: 1)),
    createdAt: now,
    updatedAt: now,
  );
}
