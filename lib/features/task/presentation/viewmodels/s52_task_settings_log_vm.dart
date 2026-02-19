import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
// 需要 context 翻譯

class S52TaskSettingsLogViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final AuthRepository _authRepo;
  final ExportService _exportService;
  final ShareService _shareService;
  final String taskId;
  final Map<String, TaskMember> membersData;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;

  LoadStatus _exportStatus = LoadStatus.initial;

  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get exportStatus => _exportStatus;

  S52TaskSettingsLogViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required AuthRepository authRepo,
    required ExportService exportService,
    required ShareService shareService,
    required this.membersData,
  })  : _taskRepo = taskRepo,
        _authRepo = authRepo,
        _exportService = exportService,
        _shareService = shareService;

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

  // Logs Stream Getter
  Stream<List<ActivityLogModel>> get logsStream =>
      _taskRepo.streamActivityLogs(taskId);

  Future<void> exportCsv({
    required String header,
    required String fileName,
    required String subject,
    required String defaultMemberName,
    // 透過 Callback 由 Page 處理翻譯邏輯
    required String Function(ActivityLogModel) getAction,
    required String Function(ActivityLogModel) getDetails,
  }) async {
    if (_exportStatus == LoadStatus.loading) return;
    _exportStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 登入確認 (Move login check here)
      if (_authRepo.currentUser == null) throw AppErrorCodes.unauthorized;

      // 2. 透過 Repository 讀取資料
      final logs = await _taskRepo.getActivityLogs(taskId);

      // 3. 透過業務 Service 生成 CSV 字串 (不簡化欄位)
      final csvContent = _exportService.generateActivityLogCsv(
        logs: logs,
        header: header,
        getAction: getAction,
        getDetails: getDetails,
        getMemberName: (uid) =>
            membersData[uid]?.displayName ?? defaultMemberName,
      );

      // 4. 透過基礎 Service 分享檔案
      await _shareService.shareFile(
        content: csvContent,
        fileName: fileName,
        subject: subject,
      );

      _exportStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _exportStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _exportStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
