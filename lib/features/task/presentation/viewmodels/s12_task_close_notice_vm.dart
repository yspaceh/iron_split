import 'package:flutter/material.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S12TaskCloseNoticeViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  S12TaskCloseNoticeViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
  }) : _taskRepo = taskRepo;

  /// 執行結束任務邏輯
  /// Returns: true if success
  Future<bool> closeTask() async {
    _isProcessing = true;
    notifyListeners();

    try {
      await _taskRepo.closeTask(taskId);

      // 2. 寫入 Log
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.closeTask,
        details: {},
      );

      return true;
    } catch (e) {
      // TODO: handle error
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
