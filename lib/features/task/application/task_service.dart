// features/task/application/task_service.dart

import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepo;

  TaskService({
    required TaskRepository taskRepo,
  }) : _taskRepo = taskRepo;

  /// 根據 Tab 索引與時間排序過濾任務
  List<TaskModel> filterAndSortTasks(List<TaskModel> tasks, int filterIndex) {
    // 1. Filter Logic
    final filtered = tasks.where((task) {
      if (filterIndex == 0) {
        // 進行中
        return task.status == TaskStatus.ongoing ||
            task.status == TaskStatus.pending;
      } else {
        // 已完成
        return task.status == TaskStatus.settled ||
            task.status == TaskStatus.closed;
      }
    }).toList();

    // 2. Sort Logic (Descending by updatedAt)
    filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return filtered;
  }

  /// S12: 執行結束任務的完整業務流程
  Future<void> closeTaskWithRetention(String taskId) async {
    await _taskRepo.closeTaskWithRetention(taskId);
  }

  /// S12: 執行刪除任務 (物理刪除)
  /// 適用於：任務內完全沒有記帳資料，直接清除
  Future<void> deleteTask(String taskId) async {
    await _taskRepo.deleteTask(taskId);
  }
}
