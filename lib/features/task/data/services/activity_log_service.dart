import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';

class ActivityLogService {
  final LoggerService _loggerService;

  ActivityLogService([
    LoggerService? loggerService,
  ]) : _loggerService = loggerService ?? LoggerService.instance;

  /// 寫入一筆活動紀錄
  Future<void> log({
    required String taskId,
    required LogAction action,
    required Map<String, dynamic> details,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final logRef = FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .collection('activity_logs')
          .doc();

      final logData = {
        'operatorUid': user.uid,
        'actionType': _getActionString(action),
        'details': details,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await logRef.set(logData);
    } catch (e, stackTrace) {
      try {
        _loggerService.recordError(
          e,
          stackTrace,
          reason: 'ActivityLogService - log: Failed to record activity log',
        );
      } catch (_) {
        // Ignore when Firebase isn't initialized (e.g. widget tests).
      }
    }
  }

  static String _getActionString(LogAction action) {
    switch (action) {
      case LogAction.createTask:
        return 'create_task';
      case LogAction.updateSettings:
        return 'update_settings';
      case LogAction.addMember:
        return 'add_member';
      case LogAction.removeMember:
        return 'remove_member';
      case LogAction.createRecord:
        return 'create_record';
      case LogAction.updateRecord:
        return 'update_record';
      case LogAction.deleteRecord:
        return 'delete_record';
      case LogAction.settleUp:
        return 'settle_up';
      case LogAction.closeTask:
        return 'close_task';
      default:
        return 'unknown';
    }
  }
}
