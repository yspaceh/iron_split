// lib/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S31SettlementPaymentInfoViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;
  final SystemRepository _systemRepo;

  final String taskId;
  final double checkPointPoolBalance;
  final Map<String, List<String>> mergeMap;
  final SettlementService _settlementService;
  final PaymentInfoFormController formController = PaymentInfoFormController();

  TaskModel? _task;
  List<RecordModel> _records = [];

  StreamSubscription? _taskSubscription;
  StreamSubscription? _recordSubscription;

  // State
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _settlementStatus = LoadStatus.initial;

  // Sync Checkbox State
  bool _isSyncChecked = true;
  PaymentInfoModel? _loadedDefault; // 用來比對是否變更

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get settlementStatus => _settlementStatus;
  bool get isSyncChecked => _isSyncChecked;
  bool get isDataReady => _task != null;

  // 判斷是否需要顯示 Sync Checkbox (如果有變更 或 原本沒資料)
  bool get showSyncOption {
    if (formController.mode == PaymentMode.private) {
      return false; // 私訊模式通常不需存為預設銀行資料
    }
    final current = formController.buildModel();
    // 如果沒有預設值，或者目前輸入的跟預設值不一樣，就顯示
    return _loadedDefault == null || current != _loadedDefault;
  }

  // 用於顯示 Checkbox 文字
  bool get isUpdate => _loadedDefault != null;

  S31SettlementPaymentInfoViewModel({
    required this.taskId,
    required this.checkPointPoolBalance,
    required this.mergeMap,
    required SettlementService settlementService,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required AuthRepository authRepo,
    required SystemRepository systemRepo,
  })  : _settlementService = settlementService,
        _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo,
        _systemRepo = systemRepo {
    formController.addListener(notifyListeners);
  }

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 讀取 Secure Storage
      _loadedDefault = await _systemRepo.getDefaultPaymentInfo();
      // 初始化 Controller 並注入預設值
      formController.loadData(_loadedDefault);
      formController.addListener(notifyListeners);

      _taskSubscription = _taskRepo.streamTask(taskId).listen(
        (taskData) {
          if (taskData != null) {
            _task = taskData;
            if (_task != null) {
              _initStatus = LoadStatus.success;
              notifyListeners();
            }
          }
        },
        onError: (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        },
      );

      _recordSubscription = _recordRepo.streamRecords(taskId).listen(
        (records) {
          _records = records;
          // Records 更新通常不影響 S31 畫面顯示，但要確保變數是最新的
          // 如果需要像 S30 那樣有 _recalculate，可以在這裡呼叫
        },
        onError: (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        },
      );
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

  // --- Actions ---

  void toggleSync(bool? val) {
    _isSyncChecked = val ?? false;
    notifyListeners();
  }

  // --- Final Execution Logic ---

  Future<void> handleExecuteSettlement() async {
    if (_settlementStatus == LoadStatus.loading) return;
    _settlementStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 儲存個人偏好 (Local)
      final myPaymentInfo = formController.buildModel();
      await _saveLocalPreference(myPaymentInfo);

      // 3. 呼叫 Service
      await _settlementService.executeSettlement(
        task: _task!, // 直接用
        records: _records, // 直接用
        mergeMap: mergeMap,
        captainPaymentInfoJson: myPaymentInfo.toJson(), // 直接傳 JSON
        checkPointPoolBalance: checkPointPoolBalance,
      );
    } on AppErrorCodes {
      _settlementStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _settlementStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> _saveLocalPreference(PaymentInfoModel info) async {
    if (formController.mode == PaymentMode.specific &&
        showSyncOption &&
        _isSyncChecked) {
      try {
        await _systemRepo.saveDefaultPaymentInfo(info);
      } on AppErrorCodes {
        rethrow;
      } catch (e) {
        throw ErrorMapper.parseErrorCode(e);
      }
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    _recordSubscription?.cancel();
    try {
      formController.removeListener(notifyListeners);
      formController.dispose();
    } catch (_) {}
    super.dispose();
  }
}
