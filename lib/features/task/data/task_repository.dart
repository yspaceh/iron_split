import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:iron_split/core/base/base_repository.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart'; // 引用現有 Model

class TaskRepository extends BaseRepository {
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
    }).handleError((e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace,
          reason: 'Task repository streamUserTasks failed');
      throw ErrorMapper.parseErrorCode(e);
    });
  }

  /// S13: 監聽單一任務詳情 (即時更新標題、成員、幣別、規則)
  Stream<TaskModel?> streamTask(String taskId) {
    return _firestore.collection('tasks').doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return TaskModel.fromFirestore(doc);
    }).handleError((e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace,
          reason: 'Task repository streamTask failed');
      final String errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission-denied') ||
          errorStr.contains('permission_denied') ||
          (e is FirebaseException && e.code == 'permission-denied')) {
        // 如果是因為權限不足（通常是因為文件被刪除導致規則失效），
        // 我們選擇「吞掉」這個錯誤，不拋出，讓 Stream 靜靜結束或保持原狀。
        return;
      }

      // 其他錯誤才拋出
      throw ErrorMapper.parseErrorCode(e);
    });
  }

  /// S13/S14: 更新任務設定 (改餘額規則、改幣別等)
  /// 取代原 S13GroupView 裡的 FirebaseFirestore.instance.update(...)
  Future<void> updateTask(String taskId, Map<String, dynamic> data) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(), // 自動更新時間
      }),
      AppErrorCodes.saveFailed,
    );
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
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update(updateData),
      AppErrorCodes.saveFailed,
    );
  }

  /// 更新整個成員列表 (Full Replacement)
  Future<void> replaceMembersMap(
      String taskId, Map<String, dynamic> membersMap) async {
    final List<String> memberIds = membersMap.keys.toList();
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        'members': membersMap,
        'memberIds': memberIds, // 同步更新查詢索引
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      AppErrorCodes.saveFailed,
    );
  }

  /// 結束任務 (將狀態改為 closed 並記錄時間)
  Future<void> closeTaskWithRetention(String taskId) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        'status': 'closed',
        'finalizedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(), // 建議同時更新 updatedAt
      }),
      AppErrorCodes.taskCloseFailed,
    );
  }

  Future<void> deleteTask(String taskId) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).delete(),
      AppErrorCodes.deleteFailed, // 請確認 AppErrorCodes 有加入此列舉，若無可用 saveFailed 代替
    );
  }

  /// 建立新任務
  /// [taskData] 已經組裝好的任務資料 Map (包含 members)
  /// 回傳新建立的 Task ID
  Future<String> createTask(Map<String, dynamic> taskData) async {
    return await safeRun(() async {
      final docRef = _firestore.collection('tasks').doc();
      // 確保時間戳記是 Server Time
      final members = (taskData['members'] as Map<String, dynamic>?) ?? {};
      if (members.isEmpty) {
        throw AppErrorCodes.saveFailed; // 例如：任務建立失敗，因為沒有成員數據
      }
      final memberIds = members.keys.toList();

      await docRef.set({
        ...taskData,
        'id': docRef.id,
        'status': 'ongoing',
        'memberIds': memberIds, // 自動生成索引陣elf
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    }, AppErrorCodes.saveFailed);
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
    }).handleError((e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace,
          reason: 'Task repository streamActivityLogs failed');
      throw ErrorMapper.parseErrorCode(e);
    });
  }

  /// 取得所有活動日誌 (一次性讀取，供匯出用)
  Future<List<ActivityLogModel>> getActivityLogs(String taskId) async {
    return await safeRun(() async {
      final snapshot = await _firestore
          .collection('tasks')
          .doc(taskId)
          .collection('activity_logs')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ActivityLogModel.fromFirestore(doc))
          .toList();
    }, AppErrorCodes.initFailed);
  }

  /// 執行結算存檔
  /// 1. 將 Task 狀態改為 'settled' (鎖定房間，禁止編輯)
  /// 2. 寫入 settlement 結算快照
  Future<void> settleTask({
    required String taskId,
    required Map<String, dynamic> settlementData,
  }) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        'status': 'settled',
        // 2. 寫入完整結算資訊 (Snapshot Field)
        'settlement': {
          ...settlementData, // 展開其他欄位 (allocations, stats, etc.)
        },
        // 3. 更新時間
        'finalizedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      AppErrorCodes.settlementFailed,
    );
  }

  /// 切換任務狀態 (用於 S30->S31 鎖定，或 S31返回 解鎖)
  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      }),
      AppErrorCodes.saveFailed,
    );
  }

  /// 通用部分更新 (Generic Partial Update)
  /// 支援 Dot Notation 更新巢狀欄位
  /// 例如: updateTaskPartial(taskId, {'settlement.receiverInfos': jsonString})
  /// 這樣只會更新 receiverInfos，不會覆蓋掉整個 settlement 物件
  Future<void> updateTaskReceiverInfos(
      String taskId, String captainPaymentInfoJson) async {
    await safeRun(
      () => _firestore.collection('tasks').doc(taskId).update({
        'settlement.receiverInfos': captainPaymentInfoJson,
        'updatedAt': FieldValue.serverTimestamp(), // 確保每次更新都有時間戳記
      }),
      AppErrorCodes.saveFailed,
    );
  }

  /// 擴充成員：同步更新人數與索引
  Future<void> addMemberToTask(
      String taskId, String virtualId, Map<String, dynamic> memberData) async {
    await safeRun(() async {
      final taskRef = _firestore.collection('tasks').doc(taskId);

      // 使用 Batch 確保原子性
      final batch = _firestore.batch();
      batch.update(taskRef, {
        'members.$virtualId': memberData,
        'memberIds': FieldValue.arrayUnion([virtualId]),
        'memberCount': FieldValue.increment(1),
        'maxMembers': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    }, AppErrorCodes.saveFailed);
  }

  /// 將純數值的增量 Map 轉換為 Firestore 原子增量更新格式
  Map<String, dynamic> buildBalanceIncrementData(
      Map<String, double> increments) {
    final Map<String, dynamic> updateData = {};
    increments.forEach((field, value) {
      updateData[field] = FieldValue.increment(value);
    });
    updateData['updatedAt'] = FieldValue.serverTimestamp();
    return updateData;
  }
}
