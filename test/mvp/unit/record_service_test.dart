import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockRecordRepository extends Mock implements RecordRepository {}

class MockTaskRepository extends Mock implements TaskRepository {}

class FakeRecordModel extends Fake implements RecordModel {}

void main() {
  late MockRecordRepository mockRecordRepo;
  late MockTaskRepository mockTaskRepo;
  late RecordService service;

  setUpAll(() {
    registerFallbackValue(FakeRecordModel());
  });

  setUp(() {
    mockRecordRepo = MockRecordRepository();
    mockTaskRepo = MockTaskRepository();
    service = RecordService(mockRecordRepo, mockTaskRepo);

    // 測試中直接把 increment map 原樣回傳，方便驗證 Service 計算結果
    when(() => mockTaskRepo.buildBalanceIncrementData(any())).thenAnswer(
      (invocation) => Map<String, dynamic>.from(
        invocation.positionalArguments.first as Map<String, double>,
      ),
    );

    when(
      () => mockRecordRepo.addRecord(
        any(),
        any(),
        taskUpdates: any(named: 'taskUpdates'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockRecordRepo.updateRecord(
        any(),
        any(),
        taskUpdates: any(named: 'taskUpdates'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockRecordRepo.deleteRecord(
        any(),
        any(),
        taskUpdates: any(named: 'taskUpdates'),
      ),
    ).thenAnswer((_) async {});
  });

  group('RecordService.createRecord', () {
    test('新增支出時，應正確增量更新 expense/prepaid 並呼叫 addRecord', () async {
      final draft = _expenseRecord(
        id: 'r-create',
        amount: 90.0,
        payerId: 'u1',
        splitMembers: const ['u1', 'u2'],
      );

      await service.createRecord(taskId: 'task-1', draftRecord: draft);

      final capturedRawIncrements = verify(
        () => mockTaskRepo.buildBalanceIncrementData(captureAny()),
      ).captured.single as Map<String, double>;

      // u1: 代墊 90，分攤 45 -> prepaid +90, expense +45
      // u2: 分攤 45 -> expense +45
      expect(capturedRawIncrements['members.u1.prepaid'], closeTo(90.0, 1e-9));
      expect(capturedRawIncrements['members.u1.expense'], closeTo(45.0, 1e-9));
      expect(capturedRawIncrements['members.u2.expense'], closeTo(45.0, 1e-9));
      expect(capturedRawIncrements.containsKey('members.u2.prepaid'), isFalse);

      final captured = verify(
        () => mockRecordRepo.addRecord(
          'task-1',
          captureAny(),
          taskUpdates: captureAny(named: 'taskUpdates'),
        ),
      ).captured;

      final savedRecord = captured[0] as RecordModel;
      final taskUpdates = captured[1] as Map<String, dynamic>;

      // 本案例可整除，remainder 應為 0
      expect(savedRecord.remainder, closeTo(0.0, 1e-9));
      expect(taskUpdates['members.u1.prepaid'], closeTo(90.0, 1e-9));
      expect(taskUpdates['members.u1.expense'], closeTo(45.0, 1e-9));
      expect(taskUpdates['members.u2.expense'], closeTo(45.0, 1e-9));
    });
  });

  group('RecordService.updateRecord', () {
    test('更新紀錄應執行 Undo + Apply 並把合併增量送到 updateRecord', () async {
      final oldRecord = _expenseRecord(
        id: 'r-1',
        amount: 90.0,
        payerId: 'u1',
        splitMembers: const ['u1', 'u2'],
      );
      final newRecord = _expenseRecord(
        id: 'r-1',
        amount: 120.0,
        payerId: 'u2',
        splitMembers: const ['u1', 'u2'],
      );

      await service.updateRecord(
        taskId: 'task-1',
        oldRecord: oldRecord,
        newRecord: newRecord,
      );

      final capturedRawIncrements = verify(
        () => mockTaskRepo.buildBalanceIncrementData(captureAny()),
      ).captured.single as Map<String, double>;

      // undo(old) + apply(new)
      // old: u1 prepaid +90, u1 expense +45, u2 expense +45
      // new: u2 prepaid +120, u1 expense +60, u2 expense +60
      // combined:
      // u1.prepaid -90, u1.expense +15, u2.prepaid +120, u2.expense +15
      expect(capturedRawIncrements['members.u1.prepaid'], closeTo(-90.0, 1e-9));
      expect(capturedRawIncrements['members.u1.expense'], closeTo(15.0, 1e-9));
      expect(capturedRawIncrements['members.u2.prepaid'], closeTo(120.0, 1e-9));
      expect(capturedRawIncrements['members.u2.expense'], closeTo(15.0, 1e-9));

      final captured = verify(
        () => mockRecordRepo.updateRecord(
          'task-1',
          captureAny(),
          taskUpdates: captureAny(named: 'taskUpdates'),
        ),
      ).captured;

      final savedRecord = captured[0] as RecordModel;
      final taskUpdates = captured[1] as Map<String, dynamic>;

      expect(savedRecord.id, 'r-1');
      expect(savedRecord.remainder, closeTo(0.0, 1e-9));
      expect(taskUpdates['members.u1.prepaid'], closeTo(-90.0, 1e-9));
      expect(taskUpdates['members.u1.expense'], closeTo(15.0, 1e-9));
      expect(taskUpdates['members.u2.prepaid'], closeTo(120.0, 1e-9));
      expect(taskUpdates['members.u2.expense'], closeTo(15.0, 1e-9));
    });
  });

  group('RecordService.validateAndDelete', () {
    test('情境 A: 刪除 prepay 且餘額不足時，必須拋 prepayIsUsed 且不可呼叫 deleteRecord', () async {
      final prepay = _prepayRecord(
        id: 'r-prepay',
        amount: 100.0,
        splitMembers: const ['u1', 'u2'],
      );

      await expectLater(
        () => service.validateAndDelete('task-1', prepay, const {'USD': 50.0}),
        throwsA(AppErrorCodes.prepayIsUsed),
      );

      verifyNever(
        () => mockRecordRepo.deleteRecord(
          any(),
          any(),
          taskUpdates: any(named: 'taskUpdates'),
        ),
      );
      verifyNever(() => mockTaskRepo.buildBalanceIncrementData(any()));
    });

    test('情境 B1: 刪除 prepay 且餘額充足時，應呼叫 deleteRecord 並套用 Undo', () async {
      final prepay = _prepayRecord(
        id: 'r-prepay',
        amount: 100.0,
        splitMembers: const ['u1', 'u2'],
      );

      await service.validateAndDelete('task-1', prepay, const {'USD': 150.0});

      final capturedRawIncrements = verify(
        () => mockTaskRepo.buildBalanceIncrementData(captureAny()),
      ).captured.single as Map<String, double>;

      // prepay undo: 各 -50 prepaid
      expect(capturedRawIncrements['members.u1.prepaid'], closeTo(-50.0, 1e-9));
      expect(capturedRawIncrements['members.u2.prepaid'], closeTo(-50.0, 1e-9));
      expect(capturedRawIncrements.containsKey('members.u1.expense'), isFalse);
      expect(capturedRawIncrements.containsKey('members.u2.expense'), isFalse);

      final captured = verify(
        () => mockRecordRepo.deleteRecord(
          'task-1',
          'r-prepay',
          taskUpdates: captureAny(named: 'taskUpdates'),
        ),
      ).captured;

      final taskUpdates = captured.single as Map<String, dynamic>;
      expect(taskUpdates['members.u1.prepaid'], closeTo(-50.0, 1e-9));
      expect(taskUpdates['members.u2.prepaid'], closeTo(-50.0, 1e-9));
    });

    test('情境 B2: 刪除一般 expense 不應受 pool 保護阻擋，應正常刪除', () async {
      final expense = _expenseRecord(
        id: 'r-expense',
        amount: 80.0,
        payerId: 'u1',
        splitMembers: const ['u1', 'u2'],
      );

      await service.validateAndDelete('task-1', expense, const {'USD': 0.0});

      final capturedRawIncrements = verify(
        () => mockTaskRepo.buildBalanceIncrementData(captureAny()),
      ).captured.single as Map<String, double>;

      // expense undo:
      // create 80 with payer u1 + even split -> u1 prepaid +80, u1 expense +40, u2 expense +40
      // undo => u1 prepaid -80, u1 expense -40, u2 expense -40
      expect(capturedRawIncrements['members.u1.prepaid'], closeTo(-80.0, 1e-9));
      expect(capturedRawIncrements['members.u1.expense'], closeTo(-40.0, 1e-9));
      expect(capturedRawIncrements['members.u2.expense'], closeTo(-40.0, 1e-9));

      verify(
        () => mockRecordRepo.deleteRecord(
          'task-1',
          'r-expense',
          taskUpdates: any(named: 'taskUpdates'),
        ),
      ).called(1);
    });
  });
}

RecordModel _expenseRecord({
  required String id,
  required double amount,
  required String payerId,
  required List<String> splitMembers,
}) {
  return RecordModel(
    id: id,
    date: DateTime(2026, 1, 1),
    title: 'expense',
    type: RecordType.expense,
    payerType: PayerType.member,
    payersId: [payerId],
    amount: amount,
    currencyCode: 'USD',
    exchangeRate: 1.0,
    splitMethod: SplitMethodConstant.even,
    splitMemberIds: splitMembers,
  );
}

RecordModel _prepayRecord({
  required String id,
  required double amount,
  required List<String> splitMembers,
}) {
  return RecordModel(
    id: id,
    date: DateTime(2026, 1, 1),
    title: 'prepay',
    type: RecordType.prepay,
    payerType: PayerType.prepay,
    amount: amount,
    currencyCode: 'USD',
    exchangeRate: 1.0,
    splitMethod: SplitMethodConstant.even,
    splitMemberIds: splitMembers,
  );
}
