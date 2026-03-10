import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';

class S20TaskLeaveNoticeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final TaskService _taskService;
  final ActivityLogService _activityLogService;
  final String taskId;

  String _currentUserId = '';
  // State
  LoadStatus _initStatus = LoadStatus.initial; // 頁面狀態
  LoadStatus _leaveStatus = LoadStatus.initial; // 按鈕狀態
  AppErrorCodes? _initErrorCode;

  // Getters
  LoadStatus get initStatus => _initStatus;
  LoadStatus get leaveStatus => _leaveStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  S20TaskLeaveNoticeViewModel({
    required this.taskId,
    required AuthRepository authRepo,
    required ActivityLogService activityLogService,
    required TaskService taskService,
  })  : _authRepo = authRepo,
        _activityLogService = activityLogService,
        _taskService = taskService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      _currentUserId = user.uid;

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

  /// 執行離開任務邏輯
  /// Returns: true if success
  Future<void> leaveTask() async {
    if (_leaveStatus == LoadStatus.loading) return;
    _leaveStatus = LoadStatus.loading;
    notifyListeners();

    try {
      await _taskService.leaveTask(taskId, _currentUserId);
      // 2. 寫入 Log
      await _activityLogService.log(
        taskId: taskId,
        action: LogAction.leaveTask,
        details: {},
      );

      _leaveStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _leaveStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _leaveStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
