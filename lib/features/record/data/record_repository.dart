import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/models/record_model.dart';

class RecordRepository {
  final FirebaseFirestore _firestore;

  RecordRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // =========== S13 Dashboard 用 (讀取 - Stream) ===========

  /// 監聽特定任務的所有消費紀錄
  /// S13 Dashboard 需要用這個來顯示列表與計算餘額
  /// (RecordModel.fromFirestore 會自動讀取 remainder 欄位)
  Stream<List<RecordModel>> streamRecords(String taskId) {
    return _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .orderBy('date', descending: true) // 保持 S13 列表依日期排序
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecordModel.fromFirestore(doc))
          .toList();
    });
  }

  // =========== Service 運算用 (讀取 - Future) ===========

  ///  一次性讀取該任務所有紀錄
  /// 用途：提供給 RecordService 進行整批匯率更新或重算零頭
  Future<List<RecordModel>> getRecordsOnce(String taskId) async {
    final snapshot = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .get();

    return snapshot.docs.map((doc) => RecordModel.fromFirestore(doc)).toList();
  }

  // =========== S15 Add/Edit Record 用 (寫入) ===========

  /// 新增消費紀錄
  Future<void> addRecord(String taskId, RecordModel record) async {
    // 1. 取得原始 Map (此時已包含 remainder 欄位)
    final Map<String, dynamic> data = record.toMap();

    // 2. 強制轉換時間格式 (Fix Bug)
    data['date'] = Timestamp.fromDate(record.date);

    if (record.createdAt != null) {
      data['createdAt'] = Timestamp.fromDate(record.createdAt!);
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    data['updatedAt'] = FieldValue.serverTimestamp();

    // 3. 寫入處理過的 data (Fix Bug: 之前錯誤使用 record.toMap() 導致 timestamp 失效)
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .add(data);
  }

  /// 更新消費紀錄
  Future<void> updateRecord(String taskId, RecordModel record) async {
    // 1. 取得原始 Map
    final Map<String, dynamic> data = record.toMap();

    // 2. 強制轉換時間格式
    data['date'] = Timestamp.fromDate(record.date);
    data['updatedAt'] = FieldValue.serverTimestamp();

    // 3. 安全性過濾
    data.remove('createdAt');
    data.remove('createdBy');
    // data.remove('id'); // ID 是 Document Key，不需寫入欄位

    // 4. 寫入處理過的 data (Fix Bug)
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .doc(record.id)
        .update(data);
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

  // =========== 批次處理 (Batch Operations) ===========

  ///  批次更新多筆紀錄
  /// 用途：RecordService 算好新的匯率與零頭後，呼叫此方法一次寫入
  Future<void> batchUpdateRecords(
      String taskId, List<RecordModel> records) async {
    if (records.isEmpty) return;

    final batch = _firestore.batch();

    for (var record in records) {
      final docRef = _firestore
          .collection('tasks')
          .doc(taskId)
          .collection('records')
          .doc(record.id);

      final Map<String, dynamic> data = record.toMap();

      // 確保更新時間正確
      data['updatedAt'] = FieldValue.serverTimestamp();

      // 移除不應變動的欄位
      data.remove('createdAt');
      data.remove('createdBy');

      batch.update(docRef, data);
    }

    await batch.commit();
  }

  // =========== 防呆檢查 ===========

  /// 檢查某成員是否有相關的消費紀錄 (完整保留您指定的邏輯)
  Future<bool> hasMemberRecords(String taskId, String memberId) async {
    // 雖然全撈效能較低，但為了確保 payerId, splitMemberIds, details 都能檢查到，這是最安全的方法
    final snapshot = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // 1. 檢查付款人
      if (data['payerId'] == memberId) return true;

      // 2. 檢查分帳對象
      if (data['splitMemberIds'] is List) {
        final splits = List<String>.from(data['splitMemberIds']);
        if (splits.contains(memberId)) return true;
      }

      // 3. 檢查細項付款人
      if (data['paymentDetails'] != null &&
          data['paymentDetails']['memberAdvance'] is Map) {
        final advances = data['paymentDetails']['memberAdvance'] as Map;
        if (advances.containsKey(memberId)) return true;
      }
    }

    return false;
  }

  /// 檢查此紀錄是否被其他紀錄引用 (例如作為 payerId)
  /// 主要用於防止刪除已被使用的預收款 (Income/Prepay)
  Future<bool> isRecordReferenced(String taskId, String recordId) async {
    // 1. 檢查是否有任何紀錄的 payerId 指向此 recordId
    final payerQuery = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .where('payerId', isEqualTo: recordId)
        .limit(1)
        .get();

    if (payerQuery.docs.isNotEmpty) return true;

    // 2. 如果未來有其他引用方式 (例如關聯轉帳)，也可以在這裡檢查
    return false;
  }

  /// 專門用於更新匯率與零頭的批次寫入
  /// Service 層算好後，把一包 (ID, 新匯率, 新零頭) 丟進來，這裡只負責寫入
  Future<void> batchUpdateRatesAndRemainders(
    String taskId,
    List<({String id, double rate, double remainder})> updates,
  ) async {
    if (updates.isEmpty) return;

    final batch = _firestore.batch();

    for (var update in updates) {
      final docRef = _firestore
          .collection('tasks')
          .doc(taskId)
          .collection('records')
          .doc(update.id);

      batch.update(docRef, {
        'exchangeRate': update.rate,
        'remainder': update.remainder,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
