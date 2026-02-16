import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';

class S12TaskCloseNoticeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final TaskService _taskService;
  final RecordRepository _recordRepo; // ✅ 新增：用來檢查是否有紀錄
  final String taskId;

  // State
  LoadStatus _initStatus = LoadStatus.initial; // 頁面狀態
  LoadStatus _closeStatus = LoadStatus.initial; // 按鈕狀態
  AppErrorCodes? _initErrorCode;

  // Getters
  LoadStatus get initStatus => _initStatus;
  LoadStatus get closeStatus => _closeStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  S12TaskCloseNoticeViewModel({
    required this.taskId,
    required AuthRepository authRepo,
    required RecordRepository record,
    required TaskService taskService,
  })  : _authRepo = authRepo,
        _recordRepo = record,
        _taskService = taskService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 3. 成功 (此頁面不需要撈資料，確認有人就好)
      _initStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes catch (code) {
      _initStatus = LoadStatus.error;
      _initErrorCode = code;
      notifyListeners();
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = ErrorMapper.parseErrorCode(e);
      notifyListeners();
    }
  }

  /// 執行結束任務邏輯
  /// Returns: true if success
  Future<void> closeTask() async {
    if (_closeStatus == LoadStatus.loading) return;
    _closeStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final records = await _recordRepo.getRecordsOnce(taskId);
      if (records.isEmpty) {
        await _taskService.deleteTask(taskId);
      } else {
        await _taskService.closeTaskWithRetention(taskId);
        // 2. 寫入 Log
        await ActivityLogService.log(
          taskId: taskId,
          action: LogAction.closeTask,
          details: {},
        );
      }

      _closeStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _closeStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _closeStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
