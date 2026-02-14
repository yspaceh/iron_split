import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class RecordService {
  final RecordRepository _recordRepo;
  final TaskRepository _taskRepo;

  RecordService(this._recordRepo, this._taskRepo);

  // =========== 公開方法 (給 ViewModel 呼叫) ===========

  /// 新增紀錄 (包含自動計算零頭)
  Future<void> createRecord({
    required String taskId,
    required RecordModel draftRecord,
  }) async {
    // 1. 委派計算 (零頭 + 成員分攤金額)
    final result = _getSplitResult(draftRecord);
    final recordToSave = draftRecord.copyWith(remainder: result.remainder);

    // 2. 準備 Task 更新包
    final rawIncrements = _calculateBalanceIncrements(recordToSave);
    final taskUpdates = _taskRepo.buildBalanceIncrementData(rawIncrements);

    await _recordRepo.addRecord(taskId, recordToSave, taskUpdates: taskUpdates);
  }

  /// 更新紀錄 (撤銷舊、套用新)
  Future<void> updateRecord(
      {required String taskId,
      required RecordModel oldRecord,
      required RecordModel newRecord}) async {
    final undoOld = _calculateBalanceIncrements(oldRecord, isUndo: true);

    final newRes = _getSplitResult(newRecord);
    final recordToSave = newRecord.copyWith(remainder: newRes.remainder);
    final applyNew = _calculateBalanceIncrements(recordToSave);

    final combined = Map<String, double>.from(undoOld);
    applyNew.forEach((k, v) => combined[k] = (combined[k] ?? 0) + v);

    final taskUpdates = _taskRepo.buildBalanceIncrementData(combined);

    await _recordRepo.updateRecord(taskId, recordToSave,
        taskUpdates: taskUpdates);
  }

  /// 刪除紀錄：撤銷該紀錄餘額
  Future<void> deleteRecord(String taskId, RecordModel record) async {
    final undo = _calculateBalanceIncrements(record, isUndo: true);

    final taskUpdates = _taskRepo.buildBalanceIncrementData(undo);
    await _recordRepo.deleteRecord(taskId, record.id!,
        taskUpdates: taskUpdates);
  }

  /// 更新匯率 (完整補回邏輯，同步所有 Record 與 Task 總額)
  Future<void> updateTaskExchangeRates({
    required String taskId,
    required Map<String, double> newRates,
    required CurrencyConstants newCurrency,
  }) async {
    final records = await _recordRepo.getRecordsOnce(taskId);

    final List<({String id, double rate, double remainder})> recordUpdates = [];
    final Map<String, double> totalTaskDelta = {};

    for (var record in records) {
      final newRate = newRates[record.currencyCode];
      if (newRate != null && (record.exchangeRate - newRate).abs() > 0.000001) {
        // 數學計算全靠 Calculator
        final undoOld = _calculateBalanceIncrements(record, isUndo: true);

        final newRes = BalanceCalculator.calculateSplit(
          totalAmount: record.amount,
          exchangeRate: newRate,
          splitMethod: record.splitMethod,
          memberIds: record.splitMemberIds,
          details: record.splitDetails ?? {},
          baseCurrency: newCurrency,
        );
        final recordWithNewRate =
            record.copyWith(exchangeRate: newRate, remainder: newRes.remainder);
        final applyNew = _calculateBalanceIncrements(recordWithNewRate);

        // C. 累加差額
        undoOld.forEach(
            (k, v) => totalTaskDelta[k] = (totalTaskDelta[k] ?? 0) + v);
        applyNew.forEach(
            (k, v) => totalTaskDelta[k] = (totalTaskDelta[k] ?? 0) + v);

        recordUpdates
            .add((id: record.id!, rate: newRate, remainder: newRes.remainder));
      }
    }

    if (recordUpdates.isNotEmpty) {
      final taskUpdates = _taskRepo.buildBalanceIncrementData(totalTaskDelta);
      await _recordRepo.batchUpdateRatesAndRemainders(taskId, recordUpdates,
          taskUpdates: taskUpdates);
    }
  }

  // --- 私有輔助：100% 委派給 BalanceCalculator ---

  SplitResult _getSplitResult(RecordModel record) {
    return BalanceCalculator.calculateSplit(
      totalAmount: record.amount,
      exchangeRate: record.exchangeRate,
      splitMethod: record.splitMethod,
      memberIds: record.splitMemberIds,
      details: record.splitDetails ?? {},
      baseCurrency: CurrencyConstants.getCurrencyConstants(record.currencyCode),
    );
  }

  /// [重構核心]：100% 依賴 Dashboard 也在使用的 Calculator 方法
  Map<String, double> _calculateBalanceIncrements(RecordModel record,
      {bool isUndo = false}) {
    final Map<String, double> increments = {};
    final double mult = isUndo ? -1.0 : 1.0;

    // 取得基準幣別
    final baseCurrency =
        CurrencyConstants.getCurrencyConstants(record.currencyCode);

    // 1. 萃取這筆紀錄牽涉到的所有人 (付款人、分擔人、細項分擔人)
    final involvedUids = _extractInvolvedUids(record);

    // 2. 統一代入 BalanceCalculator 計算每個人的 Debit (Expense) 與 Credit (Prepaid)
    for (var uid in involvedUids) {
      // 完全與 Dashboard 相同的計算源頭
      final expense =
          BalanceCalculator.calculatePersonalDebit(record, uid, baseCurrency)
              .base;
      final prepaid =
          BalanceCalculator.calculatePersonalCredit(record, uid, baseCurrency)
              .base;

      if (expense > 0) {
        increments['members.$uid.expense'] = expense * mult;
      }
      if (prepaid > 0) {
        increments['members.$uid.prepaid'] = prepaid * mult;
      }
    }

    return increments;
  }

  /// 萃取這筆紀錄有牽涉到的所有 UID (避免無謂的運算)
  Set<String> _extractInvolvedUids(RecordModel record) {
    final Set<String> uids = {};

    // 付款人
    if (record.payerId != null) uids.add(record.payerId!);

    // 主分擔人
    if (record.splitMemberIds.isNotEmpty) uids.addAll(record.splitMemberIds);

    // 混合付款裡的代墊人
    if (record.paymentDetails != null &&
        record.paymentDetails!['memberAdvance'] != null) {
      final advances = record.paymentDetails!['memberAdvance'] as Map;
      uids.addAll(advances.keys.map((k) => k.toString()));
    }

    // 子明細 (Items) 裡的分擔人
    if (record.details.isNotEmpty) {
      for (var item in record.details) {
        if (item.splitMemberIds.isNotEmpty) {
          uids.addAll(item.splitMemberIds);
        }
      }
    }

    return uids;
  }

  /// 驗證並刪除紀錄
  /// [taskId] 房間 ID
  /// [record] 要刪除的紀錄
  /// [poolBalances] 當前房間各幣別的公款餘額
  Future<void> validateAndDelete(String taskId, RecordModel record,
      Map<String, double> poolBalances) async {
    // 1. 邏輯檢查：如果是收入，檢查是否可以刪除
    if (record.type == 'income') {
      // 檢查此收入是否已被其他支出引用（原則 2：Service 調用 Repo）
      await _recordRepo.checkRecordReferenced(taskId, record.id ?? '');

      // 檢查公款餘額是否足以扣除這筆收入 (避免餘額變成負數)
      double currentBalance = poolBalances[record.currencyCode] ?? 0.0;
      if (currentBalance < (record.amount - 0.01)) {
        throw AppErrorCodes.incomeIsUsed; // 語意上這也代表這筆錢已經被花掉了
      }
    }

    // 2. 通過驗證後，執行實際刪除
    await deleteRecord(taskId, record);
  }
}
