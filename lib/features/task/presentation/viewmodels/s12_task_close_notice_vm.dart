import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';

class S12TaskCloseNoticeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final TaskService _service;
  final String taskId;

  // State
  LoadStatus _initStatus = LoadStatus.initial; // 頁面狀態
  LoadStatus _actionStatus = LoadStatus.initial; // 按鈕狀態
  AppErrorCodes? _initErrorCode;

  // Getters
  LoadStatus get initStatus => _initStatus;
  LoadStatus get actionStatus => _actionStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  bool get isProcessing => _actionStatus == LoadStatus.loading;

  S12TaskCloseNoticeViewModel({
    required this.taskId,
    required AuthRepository authRepo,
    required TaskService service,
  })  : _authRepo = authRepo,
        _service = service;

  void init() {
    _initStatus = LoadStatus.loading;
    notifyListeners();

    // 登入確認移到 VM
    final user = _authRepo.currentUser;
    if (user == null) {
      _initStatus = LoadStatus.error;
      _initErrorCode = AppErrorCodes.unauthorized;
      notifyListeners();
      return;
    }

    // 這裡若是純靜態頁面，檢查完登入即可設為 success
    _initStatus = LoadStatus.success;
    notifyListeners();
  }

  /// 執行結束任務邏輯
  /// Returns: true if success
  Future<void> closeTask() async {
    _actionStatus = LoadStatus.loading;
    notifyListeners();

    try {
      await _service.closeTask(taskId);

      // 2. 寫入 Log
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.closeTask,
        details: {},
      );

      _actionStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _actionStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _actionStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
