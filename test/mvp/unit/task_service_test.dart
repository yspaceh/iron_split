import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_analytics_service.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late MockAnalyticsService mockAnalyticsService;
  late TaskService service;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    mockAnalyticsService = MockAnalyticsService();
    stubAnalyticsService(mockAnalyticsService);

    service = TaskService(
      taskRepo: mockTaskRepo,
      analyticsService: mockAnalyticsService,
    );
  });

  group('TaskService.leaveTask', () {
    test('隊長離開任務時應拋 permissionDenied，且不呼叫 repository leaveTask', () async {
      when(() => mockTaskRepo.getTaskOnce('task-1'))
          .thenAnswer((_) async => _task(createdBy: 'u1'));

      await expectLater(
        () => service.leaveTask('task-1', 'u1'),
        throwsA(AppErrorCodes.permissionDenied),
      );

      verify(() => mockTaskRepo.getTaskOnce('task-1')).called(1);
      verifyNever(() => mockTaskRepo.leaveTask(any(), any()));
      verifyNever(() => mockAnalyticsService.logTaskLeave(
            memberCount: any(named: 'memberCount'),
            linkedMemberCount: any(named: 'linkedMemberCount'),
          ));
    });

    test('一般成員離開時應呼叫 repository leaveTask 與 analytics', () async {
      when(() => mockTaskRepo.getTaskOnce('task-1'))
          .thenAnswer((_) async => _task(createdBy: 'u1'));
      when(() => mockTaskRepo.leaveTask('task-1', 'u2'))
          .thenAnswer((_) async {});

      await service.leaveTask('task-1', 'u2');

      verify(() => mockTaskRepo.getTaskOnce('task-1')).called(1);
      verify(() => mockTaskRepo.leaveTask('task-1', 'u2')).called(1);
      verify(() => mockAnalyticsService.logTaskLeave(
            memberCount: 2,
            linkedMemberCount: 2,
          )).called(1);
    });
  });

  group('TaskService.createTask', () {
    test('進行中任務已達上限時應拋 tasksExceeded，且不呼叫 repository createTask',
        () async {
      final taskData = _taskData();
      when(() => mockTaskRepo.getOngoingTaskCount('u1'))
          .thenAnswer((_) async => AppConstants.maxOngoingTasks);

      await expectLater(
        () => service.createTask(taskData, 'u1'),
        throwsA(AppErrorCodes.tasksExceeded),
      );

      verify(() => mockTaskRepo.getOngoingTaskCount('u1')).called(1);
      verifyNever(() => mockTaskRepo.createTask(any()));
      verifyNever(() => mockAnalyticsService.logTaskCreate(
            expectedDays: any(named: 'expectedDays'),
            memberTotal: any(named: 'memberTotal'),
          ));
    });

    test('未達上限時應先檢查數量，再建立任務並送出 analytics', () async {
      final taskData = _taskData();
      when(() => mockTaskRepo.getOngoingTaskCount('u1'))
          .thenAnswer((_) async => AppConstants.maxOngoingTasks - 1);
      when(() => mockTaskRepo.createTask(taskData))
          .thenAnswer((_) async => 'task-new');

      final taskId = await service.createTask(taskData, 'u1');

      expect(taskId, 'task-new');
      verifyInOrder([
        () => mockTaskRepo.getOngoingTaskCount('u1'),
        () => mockTaskRepo.createTask(taskData),
      ]);
      verify(() => mockAnalyticsService.logTaskCreate(
            expectedDays: 3,
            memberTotal: 2,
          )).called(1);
    });
  });
}

TaskModel _task({
  required String createdBy,
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
    status: TaskStatus.ongoing,
    createdBy: createdBy,
    remainderRule: RemainderRuleConstants.member,
    remainderAbsorberId: 'u1',
    memberCount: 2,
    startDate: now,
    endDate: now,
    createdAt: now,
    updatedAt: now,
  );
}

Map<String, dynamic> _taskData() {
  final start = DateTime(2026, 1, 1);
  final end = DateTime(2026, 1, 3);
  return {
    'name': 'Trip',
    'startDate': start,
    'endDate': end,
    'baseCurrency': 'USD',
    'members': {
      'u1': {'displayName': 'Captain'},
      'ghost_1': {'displayName': 'Member 2'},
    },
  };
}
