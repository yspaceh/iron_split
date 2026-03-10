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
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/pages/s14_task_settings_page.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

class MockRecordRepository extends Mock implements RecordRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUser extends Mock implements User {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockRecordRepository mockRecordRepo;
  late MockAuthRepository mockAuthRepo;
  late MockUser mockUser;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockRecordRepo = MockRecordRepository();
    mockAuthRepo = MockAuthRepository();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('u1');
    when(() => mockAuthRepo.currentUser).thenReturn(mockUser);

    when(() => mockRecordRepo.getRecordsOnce('task-1'))
        .thenAnswer((_) async => []);
  });

  GoRouter router(TaskModel task) {
    return GoRouter(
      initialLocation: '/task/task-1/settings',
      routes: [
        GoRoute(
          path: '/task/:taskId/settings',
          name: 'S14',
          builder: (context, state) =>
              S14TaskSettingsPage(taskId: state.pathParameters['taskId']!),
          routes: [
            GoRoute(
              path: 'close',
              name: 'S12',
              builder: (context, state) => const Text('S12'),
            ),
            GoRoute(
              path: 'leave',
              name: 'S20',
              builder: (context, state) => const Text('S20'),
            ),
            GoRoute(
              path: 'invite',
              name: 'S54',
              builder: (context, state) => const Text('S54'),
            ),
            GoRoute(
              path: 'members',
              name: 'S53',
              builder: (context, state) => const Text('S53'),
            ),
            GoRoute(
              path: 'log',
              name: 'S52',
              builder: (context, state) => const Text('S52'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> pump(WidgetTester tester, TaskModel task) async {
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
            Provider<DisplayState>.value(
              value: DisplayState(isEnlarged: false, scale: 1.0),
            ),
          ],
          child: MaterialApp.router(routerConfig: router(task)),
        ),
      ),
    );

    for (int i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('S14TaskSettingsPage widget test', () {
    testWidgets('owner + ongoing 應顯示 End Task，點擊可導向 S12', (tester) async {
      await pump(
        tester,
        _task(createdBy: 'u1', status: TaskStatus.ongoing),
      );

      await tester.drag(find.byType(ListView).first, const Offset(0, -1000));
      await tester.pumpAndSettle();
      expect(find.text('End Task'), findsOneWidget);

      await tester.tap(find.text('End Task'));
      await tester.pumpAndSettle();

      expect(find.text('S12'), findsOneWidget);
    });

    testWidgets('非 owner + ongoing 應顯示 End Task，點擊可導向 S20', (tester) async {
      await pump(
        tester,
        _task(createdBy: 'u2', status: TaskStatus.ongoing),
      );

      await tester.drag(find.byType(ListView).first, const Offset(0, -1000));
      await tester.pumpAndSettle();
      expect(find.text('End Task'), findsOneWidget);

      await tester.tap(find.text('End Task'));
      await tester.pumpAndSettle();

      expect(find.text('S20'), findsOneWidget);
    });

    testWidgets('settled 狀態不應顯示 End Task', (tester) async {
      await pump(
        tester,
        _task(createdBy: 'u1', status: TaskStatus.settled),
      );

      expect(find.text('End Task'), findsNothing);
    });
  });
}

TaskModel _task({
  required String createdBy,
  required TaskStatus status,
}) {
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
      ),
      'u2': TaskMember(
        id: 'u2',
        displayName: 'Member',
        isLinked: true,
        role: 'member',
        joinedAt: now,
        createdAt: now,
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
