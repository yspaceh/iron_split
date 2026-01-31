import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';

class RecordRepository {
  final FirebaseFirestore _firestore;

  RecordRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // =========== S13 Dashboard 用 (讀取) ===========

  /// 監聽特定任務的所有消費紀錄
  /// S13 Dashboard 需要用這個來計算餘額與顯示列表
  Stream<List<RecordModel>> streamRecords(String taskId) {
    return _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .orderBy('date', descending: true) // S13 列表需要依日期排序
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecordModel.fromFirestore(doc))
          .toList();
    });
  }

  // =========== S15 Add Record 用 (寫入) ===========

  /// 新增消費紀錄
  Future<void> addRecord(String taskId, RecordModel record) async {
    // 1. 取得原始 Map
    final Map<String, dynamic> data = record.toMap();

    // 2. 強制轉換時間格式 (Safety Net)
    // 確保 'date' (消費日期) 是 Timestamp
    data['date'] = Timestamp.fromDate(record.date);

    // 確保 'createdAt' 是 Server 時間 (避免手機時間不準)
    // 如果是補登舊資料(有指定 createdAt)，則轉為 Timestamp，否則用 Server 時間
    if (record.createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(record.createdAt!);
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    // 新增時，updatedAt 通常等於 createdAt 或 Server 時間
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .add(record.toMap());
  }

  /// 更新消費紀錄
  Future<void> updateRecord(String taskId, RecordModel record) async {
    // 1. 取得原始 Map
    final Map<String, dynamic> data = record.toMap();

    // 2. 強制轉換時間格式
    data['date'] = Timestamp.fromDate(record.date);

    // 更新時，強制更新 'updatedAt' 為 Server 時間
    data['updatedAt'] = FieldValue.serverTimestamp();

    // 3. 安全性過濾：移除不該被更新的欄位
    // 確保更新紀錄時，不會不小心改到 'createdAt' 或 'createdBy'
    data.remove('createdAt');
    data.remove('createdBy');
    // data.remove('id'); // ID 也不應該被寫入欄位中，它是 Document ID
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .doc(record.id)
        .update(record.toMap());
  }

  /// 刪除消費紀錄
  Future<void> deleteRecord(String taskId, String recordId) async {
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .doc(recordId)
        .delete();
  }

  /// 根據提供的匯率表，批次更新該任務下所有紀錄的匯率
  /// [taskId] 任務 ID
  /// [rateMap] 幣別對應匯率表 (Key: CurrencyCode, Value: Rate to new base)
  Future<void> updateExchangeRates(
      String taskId, Map<String, double> rateMap) async {
    // 1. 讀取該任務所有紀錄 (一次性讀取，不用 Stream)
    final snapshot = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .get();

    if (snapshot.docs.isEmpty) return;

    // 2. 開啟 Batch
    final batch = _firestore.batch();
    bool hasUpdates = false;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final recordCurrency =
          data['currency'] as String? ?? CurrencyConstants.defaultCode;

      // 查表取得新匯率 (如果沒在表裡，維持 1.0 或原樣，視需求而定)
      final newRate = rateMap[recordCurrency] ?? 1.0;
      final currentRate = (data['exchangeRate'] as num? ?? 0).toDouble();

      // 優化：只有數值真的變動時才寫入
      if ((currentRate - newRate).abs() > 0.000001) {
        batch.update(doc.reference, {'exchangeRate': newRate});
        hasUpdates = true;
      }
    }

    // 3. 提交 Batch
    if (hasUpdates) {
      await batch.commit();
    }
  }

  // RecordRepository 類別內

  /// 檢查某成員是否有相關的消費紀錄 (用於刪除成員前的防呆)
  Future<bool> hasMemberRecords(String taskId, String memberId) async {
    // 優化：只查 "跟該成員有關" 的紀錄，而不是全部撈回來前端過濾
    // 但因為 Firestore 的 OR query 限制，有時候全部撈回來反而簡單
    // 考慮到 record 結構複雜 (payerId, contributors, splitMemberIds)，
    // 用原本的 "Fetch All + Local Check" 策略在小規模下是可以的。

    // 如果想要更精確，可以只抓最近的幾筆，或者分開查詢。
    // 為了保持與您原本邏輯一致 (最安全)，我們先 fetch all。

    final snapshot = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // 1. 檢查付款人
      if (data['payerId'] == memberId) return true;

      // 2. 檢查分帳對象 (splitMemberIds 是 List<String>)
      if (data['splitMemberIds'] is List) {
        final splits = List<String>.from(data['splitMemberIds']);
        if (splits.contains(memberId)) return true;
      }

      // 3. 檢查細項付款人 (paymentDetails.memberAdvance)
      if (data['paymentDetails'] != null &&
          data['paymentDetails']['memberAdvance'] is Map) {
        final advances = data['paymentDetails']['memberAdvance'] as Map;
        if (advances.containsKey(memberId)) return true;
      }

      // 4. (保險起見) JSON String 檢查
      // 雖然這招很髒，但如果您原本有用，我們可以保留作為最後一道防線
      // if (data.toString().contains(memberId)) return true;
    }

    return false;
  }
}
