import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';

class ActivityLogService {
  /// 寫入一筆活動紀錄
  static Future<void> log({
    required String taskId,
    required LogAction action,
    required Map<String, dynamic> details,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
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
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: '紀錄活動記錄失敗 (ActivityLogService log)',
      );
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
