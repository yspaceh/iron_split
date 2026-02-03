import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart'; // 引用現有 Model

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
        .where('memberIds', arrayContains: userId)
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
      try {
        return TaskModel.fromFirestore(doc);
      } catch (e) {
        // 防止單一資料壞掉導致崩潰
        print('❌ Error parsing task $taskId: $e');
        return null;
      }
    });
  }

  /// S13/S14: 更新任務設定 (改餘額規則、改幣別等)
  /// 取代原 S13GroupView 裡的 FirebaseFirestore.instance.update(...)
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await _firestore.collection('tasks').doc(taskId).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(), // 自動更新時間
    });
  }

  /// 更新特定成員的特定欄位 (Partial Update)
  /// [taskId] 任務ID
  /// [memberId] 成員ID (通常是 user uid)
  /// [data] 要更新的欄位與值，例如 {'avatar': 'cat', 'hasSeenRoleIntro': true}
  Future<void> updateMemberFields(
      String taskId, String memberId, Map<String, dynamic> data) async {
    final Map<String, dynamic> updateData = {};
    data.forEach((key, value) {
      updateData['members.$memberId.$key'] = value;
    });
    await _firestore.collection('tasks').doc(taskId).update(updateData);
  }

  /// 更新整個成員列表 (Full Replacement)
  Future<void> replaceMembersMap(
      String taskId, Map<String, dynamic> membersMap) async {
    final List<String> memberIds = membersMap.keys.toList();
    await _firestore.collection('tasks').doc(taskId).update({
      'members': membersMap,
      'memberIds': memberIds, // 同步更新查詢索引
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 結束任務 (將狀態改為 closed 並記錄時間)
  Future<void> closeTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': 'closed',
      'closedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(), // 建議同時更新 updatedAt
    });
  }

  /// 建立新任務
  /// [taskData] 已經組裝好的任務資料 Map (包含 members)
  /// 回傳新建立的 Task ID
  Future<String> createTask(Map<String, dynamic> taskData) async {
    // 確保時間戳記是 Server Time
    taskData['createdAt'] = FieldValue.serverTimestamp();
    taskData['updatedAt'] = FieldValue.serverTimestamp();

    // 預設狀態
    taskData['status'] = 'ongoing';
    taskData['activeInviteCode'] = null;

    // 3. [關鍵] 自動生成 memberIds 陣列以供查詢
    // 假設 taskData['members'] 是一個 Map
    if (taskData['members'] is Map) {
      final membersMap = taskData['members'] as Map<String, dynamic>;
      taskData['memberIds'] = membersMap.keys.toList();
    }

    final docRef = await _firestore.collection('tasks').add(taskData);
    return docRef.id;
  }

  /// 監聽活動日誌 (回傳 Model List，而非 Snapshot)
  Stream<List<ActivityLogModel>> streamActivityLogs(String taskId) {
    return _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('activity_logs')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();
    });
  }

  /// 取得所有活動日誌 (一次性讀取，供匯出用)
  Future<List<ActivityLogModel>> getActivityLogs(String taskId) async {
    final snapshot = await _firestore
        .collection('tasks')
        .doc(taskId)
        .collection('activity_logs')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ActivityLogModel.fromFirestore(doc))
        .toList();
  }

  /// 執行結算存檔
  /// 1. 將 Task 狀態改為 'pending' (鎖定房間，禁止編輯)
  /// 2. 寫入 settlement 結算快照
  Future<void> settleTask({
    required String taskId,
    required Map<String, dynamic> settlementData,
  }) async {
    // 雖然 settlementData 裡面已經有 status: 'pending'，
    // 但為了查詢效能，通常 Task document 根目錄也會有一個 status 欄位。
    // 這裡我們同時更新兩者，確保資料一致。

    await _firestore.collection('tasks').doc(taskId).update({
      'status': 'settled',
      // 2. 寫入完整結算資訊 (Snapshot Field)
      'settlement': {
        ...settlementData, // 展開其他欄位 (allocations, stats, etc.)
        'status': 'pending', // 確保這裡初始狀態是 pending
      },
      // 3. 更新時間
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 切換任務狀態 (用於 S30->S31 鎖定，或 S31返回 解鎖)
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
