import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';

/// B05 VM
class B05PaymentInfoEditViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;

  // Storage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';

  late PaymentInfoFormController formController;

// UI States
  bool isSaving = false;
  bool _isLoading = true; // 用於等待 Storage 讀取

  // Sync Logic States
  PaymentInfoModel? _loadedDefault; // 手機裡目前的預設值
  bool _isSyncChecked = true;

  B05PaymentInfoEditViewModel({
    required TaskRepository taskRepo,
    required TaskModel task,
  })  : _taskRepo = taskRepo,
        taskId = task.id {
    // 解析現有資料
    PaymentInfoModel? initialData;
    try {
      final settlement = task.settlement;
      if (settlement != null && settlement['receiverInfos'] != null) {
        final rawData = settlement['receiverInfos'];
        initialData = PaymentInfoModel.fromJson(rawData);
      }
    } catch (e) {
      // TODO: handle error
      debugPrint("Error parsing receiverInfos in B05: $e");
    }

    formController = PaymentInfoFormController(initialData: initialData);
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isSyncChecked => _isSyncChecked;

  // 判斷是否顯示同步選項 (邏輯與 S31 一致)
  bool get showSyncOption {
    final current = formController.buildModel();
    // 如果沒有預設值，或者目前輸入的跟預設值不一樣，就顯示
    return _loadedDefault == null || current != _loadedDefault;
  }

  // 顯示文字判定: "更新" vs "儲存"
  bool get isUpdate => _loadedDefault != null;

  // 初始化: 讀取 SecureStorage
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        _loadedDefault = PaymentInfoModel.fromJson(jsonStr);
      }
    } catch (e) {
      // TODO: handle error
      debugPrint("Error loading local preference: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSync(bool? val) {
    _isSyncChecked = val ?? false;
    notifyListeners();
  }

  Future<void> save(Translations t) async {
    isSaving = true;
    notifyListeners();

    try {
      final newData = formController.buildModel();
      final newDataMap = newData.toJson();

      // 1. 更新 Firestore (部分更新)
      await _taskRepo.updateTaskReceiverInfos(taskId, newDataMap);

      // 2. 如果勾選同步，更新 Local Storage
      if (formController.mode == PaymentMode.specific &&
          _isSyncChecked &&
          showSyncOption) {
        await _storage.write(key: _storageKey, value: newData.toJson());
      }

      isSaving = false;
      notifyListeners();
    } catch (e) {
      // TODO: handle error
      isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    formController.dispose();
    super.dispose();
  }
}
