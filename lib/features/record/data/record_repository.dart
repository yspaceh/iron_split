import 'package:cloud_firestore/cloud_firestore.dart';
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
    await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .add(record.toMap());
  }

  /// 更新消費紀錄
  Future<void> updateRecord(String taskId, RecordModel record) async {
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
}
