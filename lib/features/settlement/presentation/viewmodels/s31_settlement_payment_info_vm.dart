// lib/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S31SettlementPaymentInfoViewModel extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';

  final String taskId;
  final double checkPointPoolBalance;
  final Map<String, List<String>> mergeMap;

  final SettlementService _settlementService;
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;

  TaskModel? _task;
  List<RecordModel> _records = [];

  StreamSubscription? _taskSubscription;
  StreamSubscription? _recordSubscription;

  // UI States
  bool _isLoading = true;

  // 這裡使用 late，在 init() 讀取完 Storage 後再初始化
  late PaymentInfoFormController formController;

  // Sync Checkbox State
  bool _isSyncChecked = true;
  PaymentInfoModel? _loadedDefault; // 用來比對是否變更

  // Getters
  bool get isLoading => _isLoading;
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
  })  : _settlementService = settlementService,
        _taskRepo = taskRepo,
        _recordRepo = recordRepo;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 讀取 Secure Storage
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        final data = PaymentInfoModel.fromJson(jsonStr);
        _loadedDefault = data;
      }
      // 初始化 Controller 並注入預設值
      formController = PaymentInfoFormController(initialData: _loadedDefault);

      // [關鍵] 監聽 Controller 變化 -> 通知 View 更新 (影響 showSyncOption 的顯示)
      formController.addListener(notifyListeners);

      _taskSubscription = _taskRepo.streamTask(taskId).listen((taskData) {
        if (taskData != null) {
          _task = taskData;
          if (_task != null) {
            _isLoading = false;
            notifyListeners();
          }
        }
      });

      _recordSubscription = _recordRepo.streamRecords(taskId).listen((records) {
        _records = records;
        // Records 更新通常不影響 S31 畫面顯示，但要確保變數是最新的
        // 如果需要像 S30 那樣有 _recalculate，可以在這裡呼叫
      });
    } catch (e) {
      // TODO: handle error
      debugPrint("Error loading payment info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Actions ---

  void toggleSync(bool? val) {
    _isSyncChecked = val ?? false;
    notifyListeners();
  }

  // --- Final Execution Logic ---

  Future<bool> handleExecuteSettlement() async {
    _isLoading = true;
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

      return true;
    } catch (e) {
      // TODO: handle error
      debugPrint("Settlement Execution Failed: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveLocalPreference(PaymentInfoModel info) async {
    if (formController.mode == PaymentMode.specific &&
        _isSyncChecked &&
        showSyncOption) {
      await _storage.write(key: _storageKey, value: info.toJson());
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    _recordSubscription?.cancel();
    formController.removeListener(notifyListeners);
    formController.dispose();
    super.dispose();
  }
}
