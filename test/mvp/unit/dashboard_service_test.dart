import 'package:flutter_test/flutter_test.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';

void main() {
  late DashboardService service;

  setUp(() {
    service = DashboardService();
  });

  group('DashboardService.calculateBalanceState (flex boundary)', () {
    test('無紀錄時 expenseFlex/prepayFlex 應為 0 且 locked 依 task status 決定', () {
      final task = _task(status: TaskStatus.ongoing);

      final state = service.calculateBalanceState(
        task: task,
        records: const [],
        currentUserId: 'u1',
      );

      expect(state.expenseFlex, 0);
      expect(state.prepayFlex, 0);
      expect(state.isLocked, isFalse);
    });

    test('有 prepay/expense 時 flex 應為比例且總和 1000', () {
      final task = _task(status: TaskStatus.settled);
      final records = [
        _record(type: RecordType.prepay, amount: 100.0),
        _record(type: RecordType.expense, amount: 300.0),
      ];

      final state = service.calculateBalanceState(
        task: task,
        records: records,
        currentUserId: 'u1',
      );

      expect(state.expenseFlex, 750);
      expect(state.prepayFlex, 250);
      expect(state.expenseFlex + state.prepayFlex, 1000);
      expect(state.isLocked, isTrue);
    });
  });

  group('DashboardService.generateDisplayDates (date boundary)', () {
    test('startDate > endDate 時應至少包含 startDate，並與 grouped dates 合併排序', () {
      final start = DateTime(2026, 1, 10, 12);
      final end = DateTime(2026, 1, 9, 12);
      final grouped = {
        DateTime(2026, 1, 8, 12): [_record()],
        DateTime(2026, 1, 12, 12): [_record()],
      };

      final dates = service.generateDisplayDates(
        startDate: start,
        endDate: end,
        groupedRecords: grouped,
      );

      expect(dates.first, DateTime(2026, 1, 12, 12));
      expect(dates, contains(start));
      expect(dates, contains(DateTime(2026, 1, 8, 12)));
      expect(dates.length, 3);
    });
  });

  group('DashboardService.calculateInitialTargetDate (date boundary)', () {
    test('當 now 不在期間內時應回傳 start', () {
      final now = DateTime.now();
      final start = DateTime(now.year + 1, 1, 1, 12);
      final end = DateTime(now.year + 1, 1, 5, 12);

      final target = service.calculateInitialTargetDate(start, end);

      expect(target, start);
    });
  });
}

TaskModel _task({required TaskStatus status}) {
  final now = DateTime(2026, 1, 1, 12);
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
    },
    memberIds: const ['u1'],
    status: status,
    createdBy: 'u1',
    remainderRule: RemainderRuleConstants.member,
    createdAt: now,
    updatedAt: now,
  );
}

RecordModel _record({
  RecordType type = RecordType.expense,
  double amount = 10.0,
}) {
  return RecordModel(
    id: 'r1',
    date: DateTime(2026, 1, 1, 12),
    title: 'Item',
    type: type,
    amount: amount,
    currencyCode: CurrencyConstants.defaultCode,
    exchangeRate: 1.0,
  );
}
