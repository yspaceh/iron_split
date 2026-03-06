import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late MockTaskRepository mockTaskRepo;
  late SettlementService service;

  setUp(() {
    mockTaskRepo = MockTaskRepository();
    service = SettlementService(mockTaskRepo);

    when(
      () => mockTaskRepo.settleTask(
        taskId: any(named: 'taskId'),
        settlementData: any(named: 'settlementData'),
      ),
    ).thenAnswer((_) async {});
  });

  group('SettlementService.executeSettlement - 資料衝突防護', () {
    test('checkpoint 與目前 pool balance 不一致時，拋 dataConflict 且不寫入結算', () async {
      final task = _buildTask(
        id: 'task-1',
        status: TaskStatus.ongoing,
        remainderRule: RemainderRuleConstants.member,
        remainderAbsorberId: 'u1',
      );

      final records = <RecordModel>[]; // current pool balance = 0

      await expectLater(
        () => service.executeSettlement(
          task: task,
          records: records,
          mergeMap: const {},
          checkPointPoolBalance: 999.0, // 故意不一致
        ),
        throwsA(AppErrorCodes.dataConflict),
      );

      verifyNever(
        () => mockTaskRepo.settleTask(
          taskId: any(named: 'taskId'),
          settlementData: any(named: 'settlementData'),
        ),
      );
    });
  });

  group('SettlementService.calculateSettlementMembers - 零頭分配策略 + mergeMap', () {
    final task = _buildTask(
      id: 'task-2',
      status: TaskStatus.ongoing,
      remainderRule: RemainderRuleConstants.random,
      remainderAbsorberId: null,
      // 基本盤: u1=10, u2=20, u3=30
      prepaidByMember: const {'u1': 10.0, 'u2': 20.0, 'u3': 30.0},
      expenseByMember: const {'u1': 0.0, 'u2': 0.0, 'u3': 0.0},
    );

    final recordsWithPositiveRemainder = [
      _recordWithRemainder(type: RecordType.prepay, remainder: 0.02),
    ];

    const mergeMap = {
      'u1': ['u2'], // u1 代表 + u2 子成員
    };

    test('random: 不分配零頭；merge 後總額等於 base 總和', () {
      final result = service.calculateSettlementMembers(
        task: task,
        records: recordsWithPositiveRemainder,
        remainderRule: RemainderRuleConstants.random,
        mergeMap: mergeMap,
      );

      final total = result.fold(0.0, (sum, m) => sum + m.finalAmount);

      expect(result.length, 2); // u1(含u2) + u3
      expect(total, closeTo(60.0, 1e-9)); // 10+20+30，random 不發牌
      expect(result.every((m) => m.isRemainderHidden), isTrue);
      expect(result.every((m) => m.remainderAmount.abs() < 1e-9), isTrue);
    });

    test('member: 指定成員吸收零頭；merge 後總額等於 base + remainder', () {
      final result = service.calculateSettlementMembers(
        task: task,
        records: recordsWithPositiveRemainder,
        remainderRule: RemainderRuleConstants.member,
        remainderAbsorberId: 'u3',
        mergeMap: mergeMap,
      );

      final total = result.fold(0.0, (sum, m) => sum + m.finalAmount);
      final u3 = result.firstWhere((m) => m.memberData.id == 'u3');

      expect(result.length, 2);
      expect(total, closeTo(60.02, 1e-9));
      expect(u3.remainderAmount, closeTo(0.02, 1e-9));
      expect(u3.finalAmount, closeTo(30.02, 1e-9));
    });

    test('order: 依序發牌；merge 後 head 應彙總子成員零頭', () {
      final result = service.calculateSettlementMembers(
        task: task,
        records: recordsWithPositiveRemainder,
        remainderRule: RemainderRuleConstants.order,
        mergeMap: mergeMap,
      );

      final total = result.fold(0.0, (sum, m) => sum + m.finalAmount);
      final head = result.firstWhere((m) => m.memberData.id == 'u1');
      final u3 = result.firstWhere((m) => m.memberData.id == 'u3');

      // 0.02 會以 0.01/step 依序給 u1, u2，merge 後都在 u1 head 上
      expect(result.length, 2);
      expect(total, closeTo(60.02, 1e-9));
      expect(head.remainderAmount, closeTo(0.02, 1e-9));
      expect(head.finalAmount, closeTo(30.02, 1e-9)); // 10 + 20 + 0.02
      expect(u3.remainderAmount, closeTo(0.0, 1e-9));
      expect(u3.finalAmount, closeTo(30.0, 1e-9));
    });
  });

  group('SettlementService.executeSettlement - 成功流程', () {
    test('成功時應寫入 settleTask payload（由 repository 將狀態標記為 settled）', () async {
      final task = _buildTask(
        id: 'task-3',
        status: TaskStatus.ongoing,
        remainderRule: RemainderRuleConstants.member,
        remainderAbsorberId: 'u2',
      );

      final records = <RecordModel>[]; // checkpoint 使用 0.0 對齊

      final winner = await service.executeSettlement(
        task: task,
        records: records,
        mergeMap: const {},
        captainPaymentInfoJson: '{"method":"bank"}',
        checkPointPoolBalance: 0.0,
      );

      expect(winner, 'u2');

      final captured = verify(
        () => mockTaskRepo.settleTask(
          taskId: 'task-3',
          settlementData: captureAny(named: 'settlementData'),
        ),
      ).captured.single as Map<String, dynamic>;

      expect(captured['baseCurrency'], 'USD');
      expect(captured['remainderWinnerId'], 'u2');
      expect(captured['receiverInfos'], '{"method":"bank"}');

      final allocations = captured['allocations'] as Map<String, dynamic>;
      final memberStatus = captured['memberStatus'] as Map<String, dynamic>;
      final viewStatus = captured['viewStatus'] as Map<String, dynamic>;

      expect(allocations.keys.toSet(), {'u1', 'u2', 'u3'});
      expect(memberStatus.keys.toSet(), {'u1', 'u2', 'u3'});
      expect(viewStatus.keys.toSet(), {'u1', 'u2', 'u3'});
      expect(memberStatus.values.every((v) => v == false), isTrue);
      expect(viewStatus.values.every((v) => v == false), isTrue);

      expect(captured['dashboardSnapshot'], isA<Map<String, dynamic>>());
    });
  });
}

TaskModel _buildTask({
  required String id,
  required TaskStatus status,
  required String remainderRule,
  String? remainderAbsorberId,
  Map<String, double>? prepaidByMember,
  Map<String, double>? expenseByMember,
}) {
  final prepaid = prepaidByMember ?? const {'u1': 0.0, 'u2': 0.0, 'u3': 0.0};
  final expense = expenseByMember ?? const {'u1': 0.0, 'u2': 0.0, 'u3': 0.0};
  final now = DateTime(2026, 1, 1);

  final members = <String, TaskMember>{};
  for (final id in ['u1', 'u2', 'u3']) {
    members[id] = TaskMember(
      id: id,
      displayName: id.toUpperCase(),
      isLinked: true,
      role: id == 'u1' ? 'captain' : 'member',
      joinedAt: now,
      createdAt: now,
      prepaid: prepaid[id] ?? 0.0,
      expense: expense[id] ?? 0.0,
    );
  }

  return TaskModel(
    id: id,
    name: 'task-$id',
    baseCurrency: 'USD',
    members: members,
    memberIds: members.keys.toList(),
    status: status,
    createdBy: 'u1',
    remainderRule: remainderRule,
    remainderAbsorberId: remainderAbsorberId,
    createdAt: now,
    updatedAt: now,
  );
}

RecordModel _recordWithRemainder({
  required RecordType type,
  required double remainder,
}) {
  return RecordModel(
    id: 'rec-${type.name}',
    date: DateTime(2026, 1, 1),
    title: type.name,
    type: type,
    payerType: type == RecordType.prepay ? PayerType.prepay : PayerType.member,
    payersId: const ['u1'],
    amount: 0.0,
    currencyCode: 'USD',
    exchangeRate: 1.0,
    remainder: remainder,
    splitMethod: SplitMethodConstant.even,
    splitMemberIds: const ['u1', 'u2', 'u3'],
  );
}
