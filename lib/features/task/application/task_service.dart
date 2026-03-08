// features/task/application/task_service.dart

import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/services/logger_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class TaskService {
  final TaskRepository _taskRepo;
  final AnalyticsService _analyticsService;
  final LoggerService _loggerService;

  TaskService({
    required TaskRepository taskRepo,
    AnalyticsService? analyticsService,
    LoggerService? loggerService,
  })  : _taskRepo = taskRepo,
        _loggerService = loggerService ?? LoggerService.instance,
        _analyticsService = analyticsService ?? AnalyticsService.instance;

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

  /// ==========================================
  /// 建立新任務 (包含寫入 DB 與 Analytics 埋點)
  /// ==========================================
  Future<String> createTask(Map<String, dynamic> taskData) async {
    // 1. 執行實際的資料庫寫入 (Repository 操作)
    final taskId = await _taskRepo.createTask(taskData);

    // 2. 寫入成功後，執行 Analytics 埋點
    try {
      // 從傳入的 Map 中計算出實際的人數，若沒有則預設 1 人
      final memberTotal = (taskData['members'] as Map?)?.length ?? 1;
      // 👉 直接從 taskData 提取時間並計算預期天數
      final startDate = taskData['startDate'] as DateTime;
      final endDate = taskData['endDate'] as DateTime;
      final expectedDays = endDate.difference(startDate).inDays.abs() + 1;

      await _analyticsService.logTaskCreate(
        expectedDays: expectedDays,
        memberTotal: memberTotal,
      );
    } catch (e, stackTrace) {
      _loggerService.recordError(
        e,
        stackTrace,
        reason:
            'AnalyticsService: TaskService - createTask: Failed to log task create event',
      );
    }

    // 3. 回傳建立成功的 ID 給 ViewModel 繼續執行後續動作
    return taskId;
  }

  /// S12: 執行刪除任務 (物理刪除)
  /// 適用於：任務內完全沒有記帳資料，直接清除
  Future<void> deleteTask(String taskId) async {
    final task = await _taskRepo.getTaskOnce(taskId);

    int durationDays = 0;

    if (task != null) {
      // 計算存活天數 (現在時間 - 建立時間)
      durationDays = DateTime.now().difference(task.createdAt).inDays;
    }
    await _taskRepo.deleteTask(taskId);

    if (task != null) {
      try {
        await _analyticsService.logTaskDeleteManual(
          durationDays: durationDays,
        );
      } catch (e, stackTrace) {
        _loggerService.recordError(
          e,
          stackTrace,
          reason:
              'AnalyticsService: TaskService - deleteTask: Failed to log task delete event',
        );
      }
    }
  }

  // 提供一個業務邏輯層的查詢
  Future<TaskModel?> getValidatedTask(String taskId) async {
    // 1. 透過 Repo 拿取原始資料
    final task = await _taskRepo.getTaskOnce(taskId);

    if (task == null) return null;

    return task;
  }
}
