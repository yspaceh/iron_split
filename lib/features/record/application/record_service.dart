import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/record/data/record_repository.dart';

class RecordService {
  final RecordRepository _recordRepository;

  RecordService(this._recordRepository);

  // =========== 核心業務邏輯：計算零頭 ===========

  /// [Pure Function] 根據金額、匯率、分帳成員，算出零頭
  /// 這就是該筆交易的 "Accountant" 邏輯
  double _calculateRemainder({
    required double originalAmount,
    required double exchangeRate,
    // 這裡簡化，假設均分。如果是複雜分帳，這裡會引入 SplitStrategy
    required int splitMemberCount,
  }) {
    if (splitMemberCount == 0) return 0.0;

    // 1. 錨定總價值 (Total Base)
    final double totalBase = originalAmount * exchangeRate;

    // 2. 計算單人分攤額 (無條件捨去，避免超收)
    // 假設精度到小數點下 2 位 (依據 CurrencyConstants)
    const int precision = 2;
    final double multiplier = pow(10, precision).toDouble();

    // (Total / N) 下取整
    final double memberAmount =
        (totalBase / splitMemberCount * multiplier).floorToDouble() /
            multiplier;

    // 3. 算出總分配額
    final double totalAllocated = memberAmount * splitMemberCount;

    // 4. 算出零頭 (Remainder)
    // 這裡必須處理浮點數精度，避免 0.300000004
    double remainder = totalBase - totalAllocated;
    return double.parse(remainder.toStringAsFixed(precision));
  }

  // =========== 公開方法 (給 ViewModel 呼叫) ===========

  /// 新增紀錄 (包含自動計算零頭)
  Future<void> createRecord({
    required String taskId,
    required RecordModel draftRecord, // 從 UI 來的草稿 (不含 remainder)
  }) async {
    // 1. 執行運算：算出這筆交易的零頭
    // 這裡我們把計算邏輯封裝在 Service 裡，確保資料一致性
    final double calculatedRemainder = _calculateRemainder(
      originalAmount: draftRecord.amount,
      exchangeRate: draftRecord.exchangeRate,
      splitMemberCount: draftRecord.splitMemberIds.length,
    );

    // 2. 補完 Model：加上零頭資訊
    final recordToSave = draftRecord.copyWith(
      remainder: calculatedRemainder,
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
  }) async {
    // 1. 撈出所有紀錄 (透過 Repo)
    // 這裡我們需要一次性讀取來重算
    // 注意：這裡假設 repo 提供了 getRecords (Future) 或類似方法
    // 如果 repo 只有 stream，這裡需要調整為 get
    final records = await _recordRepository.getRecordsOnce(taskId);

    final batch = FirebaseFirestore.instance.batch();
    bool hasUpdates = false;

    for (var record in records) {
      final newRate = newRates[record.currencyCode];

      // 如果匯率有變，必須重算 "整個結構"
      if (newRate != null && (record.exchangeRate - newRate).abs() > 0.000001) {
        // A. 重算零頭
        final newRemainder = _calculateRemainder(
          originalAmount: record.amount,
          exchangeRate: newRate,
          splitMemberCount: record.splitMemberIds.length,
        );

        // B. 準備更新資料
        // 這裡直接操作 DB reference，或是呼叫 repo 的 batch helper
        // 為了簡單示意，這裡直接用 Firestore 邏輯，
        // 理想上應該呼叫 _recordRepository.addToBatch(...)
        final docRef = FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskId)
            .collection('records')
            .doc(record.id);

        batch.update(docRef, {
          'exchangeRate': newRate,
          'remainder': newRemainder, // [關鍵] 同步更新零頭
          'updatedAt': FieldValue.serverTimestamp(),
        });

        hasUpdates = true;
      }
    }

    // 2. 提交更新
    if (hasUpdates) {
      await batch.commit();
    }
  }
}
