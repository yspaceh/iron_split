import 'package:flutter/material.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

/// B05 VM
class B05PaymentInfoEditViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final SystemRepository _systemRepo;
  final AuthRepository _authRepo;
  final String taskId;

  late PaymentInfoFormController formController;

// UI States
  LoadStatus _saveStatus = LoadStatus.initial;
  LoadStatus _initStatus = LoadStatus.initial; // 頁面狀態// 按鈕狀態
  AppErrorCodes? _initErrorCode;

  // Sync Logic States
  PaymentInfoModel? _loadedDefault; // 手機裡目前的預設值
  bool _isSyncChecked = true;

  // Getters
  bool get isSyncChecked => _isSyncChecked;

  // 判斷是否顯示同步選項 (邏輯與 S31 一致)
  bool get showSyncOption {
    final current = formController.buildModel();
    // 如果沒有預設值，或者目前輸入的跟預設值不一樣，就顯示
    return _loadedDefault == null || current != _loadedDefault;
  }

  // 顯示文字判定: "更新" vs "儲存"
  bool get isUpdate => _loadedDefault != null;

  LoadStatus get saveStatus => _saveStatus;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  B05PaymentInfoEditViewModel({
    required TaskRepository taskRepo,
    required SystemRepository systemRepo,
    required AuthRepository authRepo,
    required TaskModel task,
  })  : _taskRepo = taskRepo,
        _systemRepo = systemRepo,
        _authRepo = authRepo,
        taskId = task.id {
    formController = PaymentInfoFormController();
  }

  // 初始化: 讀取 SecureStorage
  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      _loadedDefault = await _systemRepo.getDefaultPaymentInfo();
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

  void toggleSync(bool? val) {
    final newSyncChecked = val ?? false;
    if (_isSyncChecked != newSyncChecked) {
      _isSyncChecked = newSyncChecked;
      notifyListeners();
    }
  }

  Future<void> save() async {
    if (_saveStatus == LoadStatus.loading) return;
    _saveStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final newData = formController.buildModel();
      final newDataMap = newData.toJson();

      // 1. 更新 Firestore (部分更新)
      await _taskRepo.updateTaskReceiverInfos(taskId, newDataMap);

      if (formController.mode == PaymentMode.specific &&
          _isSyncChecked &&
          showSyncOption) {
        await _systemRepo.saveDefaultPaymentInfo(newData);
      }

      _saveStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }
}
