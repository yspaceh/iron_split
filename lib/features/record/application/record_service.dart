import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/record/data/record_repository.dart';

class RecordService {
  final RecordRepository _recordRepository;

  RecordService(this._recordRepository);

  // =========== 公開方法 (給 ViewModel 呼叫) ===========

  /// 新增紀錄 (包含自動計算零頭)
  Future<void> createRecord({
    required String taskId,
    required RecordModel draftRecord,
  }) async {
    // 1. 執行運算：算出這筆交易的零頭
    final result = BalanceCalculator.calculateSplit(
      totalAmount: draftRecord.amount,
      exchangeRate: draftRecord.exchangeRate,
      splitMethod: draftRecord.splitMethod,
      memberIds: draftRecord.splitMemberIds,
      details: draftRecord.splitDetails ?? {},
      baseCurrency:
          CurrencyConstants.getCurrencyConstants(draftRecord.currencyCode),
    );

    // 2. 補完 Model：加上零頭資訊
    final recordToSave = draftRecord.copyWith(
      remainder: result.remainder,
      // 可以在這裡設定 createdBy 等 Server 無法決定的業務欄位
    );

    // 3. 交給 Repository：只負責存
    await _recordRepository.addRecord(taskId, recordToSave);
  }

  /// 更新匯率 (包含重新計算所有受影響的零頭)
  /// 這就是之前 Repository 不該做，但 Service 必須做的事
  Future<void> updateTaskExchangeRates({
    required String taskId,
    required Map<String, double> newRates,
    required CurrencyConstants baseCurrency,
  }) async {
    // 1. 撈出資料 (委託 Repo)
    final records = await _recordRepository.getRecordsOnce(taskId);

    // 準備一個 List 來存放需要更新的資料
    // 使用 Dart 3 Record 語法: ({String id, double rate, double remainder})
    final List<({String id, double rate, double remainder})> updates = [];

    for (var record in records) {
      final newRate = newRates[record.currencyCode];

      // 只有匯率變動超過 0.000001 才需要重算
      if (newRate != null && (record.exchangeRate - newRate).abs() > 0.000001) {
        // 2. 核心計算 (呼叫 Calculator)
        final result = BalanceCalculator.calculateSplit(
          totalAmount: record.amount,
          exchangeRate: newRate,
          splitMethod: record.splitMethod,
          memberIds: record.splitMemberIds,
          details: record.splitDetails ?? {},
          baseCurrency: baseCurrency,
        );

        // 3. 收集更新資料 (不直接操作 DB)
        updates.add((
          id: record.id ?? '',
          rate: newRate,
          remainder: result.remainder,
        ));
      }
    }

    // 4. 批次寫入 (委託 Repo)
    if (updates.isNotEmpty) {
      await _recordRepository.batchUpdateRatesAndRemainders(taskId, updates);
    }
  }
}
