import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/models/task_model.dart'; // 引用現有 Model

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// 監聽使用者的任務列表
  Stream<List<TaskModel>> streamUserTasks(String userId) {
    // 若 Firestore members 是 Map，標準查詢是 where('members.$userId', isNull: false)
    // 但這需要複合索引。
    // 假設您的舊邏輯能跑，這裡使用最兼容的查詢方式：
    // 查詢 'members' 欄位包含此 key (透過 FieldPath)
    return _firestore
        .collection('tasks')
        // .where(FieldPath(['members', userId]), isNull: false) // 這是 Map 的查法
        // 如果舊專案是用 Array，請改回 arrayContains。這裡依照 Model 是 Map 處理。
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    }).map((tasks) {
      // 二次過濾：確保使用者真的在 members Map 裡
      // (這是為了避免索引問題導致的權限溢出，做一層前端過濾最安全)
      return tasks.where((t) => t.members.containsKey(userId)).toList();
    });
  }

  /// 刪除任務
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  /// S13: 監聽單一任務詳情 (即時更新標題、成員、幣別、規則)
  Stream<TaskModel?> streamTask(String taskId) {
    return _firestore.collection('tasks').doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TaskModel.fromFirestore(doc);
    });
  }

  /// S13/S14: 更新任務設定 (改餘額規則、改幣別等)
  /// 取代原 S13GroupView 裡的 FirebaseFirestore.instance.update(...)
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _firestore.collection('tasks').doc(taskId).update(data);
  }
}
