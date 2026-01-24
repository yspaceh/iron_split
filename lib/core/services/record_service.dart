import 'package:cloud_firestore/cloud_firestore.dart';

class RecordService {
  /// Deletes a record from Firestore.
  /// Path: tasks/{taskId}/records/{recordId}
  static Future<void> deleteRecord(String taskId, String recordId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .collection('records')
        .doc(recordId)
        .delete();
  }
}
