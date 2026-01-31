import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';

class S12TaskCloseNoticeViewModel extends ChangeNotifier {
  final String taskId;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  S12TaskCloseNoticeViewModel({required this.taskId});

  /// 執行結束任務邏輯
  /// Returns: true if success
  Future<bool> closeTask() async {
    _isProcessing = true;
    notifyListeners();

    try {
      // 1. 更新 Firestore 狀態
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': 'closed',
        'closedAt': FieldValue.serverTimestamp(),
      });

      // 2. 寫入 Log
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.closeTask,
        details: {},
      );

      return true;
    } catch (e) {
      debugPrint("Close task failed: $e");
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
