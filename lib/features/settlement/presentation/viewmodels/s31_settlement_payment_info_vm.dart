// lib/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/core/models/payment_info_model.dart';

class S31SettlementPaymentInfoViewModel extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';

  final String taskId;

  // UI States
  bool _isLoading = true;
  PaymentMode _mode = PaymentMode.private;

  // Specific Info States
  bool _acceptCash = true;
  bool _enableBank = false;
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAccountCtrl = TextEditingController();

  bool _enableApps = false;
  // 為了方便編輯，這裡用 List<Map> 或 Controller Group，簡單起見直接操作 Model
  List<PaymentAppEditingController> _appControllers = [];

  // Sync Checkbox State
  bool _isSyncChecked = true;
  PaymentInfoModel? _loadedDefault; // 用來比對是否變更

  // Getters
  bool get isLoading => _isLoading;
  PaymentMode get mode => _mode;
  bool get acceptCash => _acceptCash;
  bool get enableBank => _enableBank;
  bool get enableApps => _enableApps;
  List<PaymentAppEditingController> get appControllers => _appControllers;
  bool get isSyncChecked => _isSyncChecked;

  // 判斷是否需要顯示 Sync Checkbox (如果有變更 或 原本沒資料)
  bool get showSyncOption {
    if (_mode == PaymentMode.private) return false; // 私訊模式通常不需存為預設銀行資料
    final current = _buildCurrentModel();
    // 如果沒有預設值，或者目前輸入的跟預設值不一樣，就顯示
    return _loadedDefault == null || current != _loadedDefault;
  }

  // 用於顯示 Checkbox 文字
  bool get isUpdate => _loadedDefault != null;

  S31SettlementPaymentInfoViewModel({required this.taskId});

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 讀取 Secure Storage
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        final data = PaymentInfoModel.fromJson(jsonStr);
        _loadedDefault = data;

        // 填入 UI
        _mode = data.mode;
        _acceptCash = data.acceptCash;

        if (data.bankName != null || data.bankAccount != null) {
          _enableBank = true;
          bankNameCtrl.text = data.bankName ?? '';
          bankAccountCtrl.text = data.bankAccount ?? '';
        }

        if (data.paymentApps.isNotEmpty) {
          _enableApps = true;
          _appControllers = data.paymentApps
              .map((e) =>
                  PaymentAppEditingController(name: e.name, link: e.link))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error loading payment info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Actions ---

  void setMode(PaymentMode val) {
    _mode = val;
    notifyListeners();
  }

  void toggleAcceptCash(bool? val) {
    _acceptCash = val ?? false;
    notifyListeners();
  }

  void toggleEnableBank(bool? val) {
    _enableBank = val ?? false;
    notifyListeners();
  }

  void toggleEnableApps(bool? val) {
    _enableApps = val ?? false;
    if (_enableApps && _appControllers.isEmpty) {
      addApp(); // 預設新增一行
    }
    notifyListeners();
  }

  void addApp() {
    _appControllers.add(PaymentAppEditingController());
    notifyListeners();
  }

  void removeApp(int index) {
    _appControllers.removeAt(index);
    if (_appControllers.isEmpty) {
      // 若刪光了，是否要自動關閉 checkbox? 視 UX 而定，這裡保留
    }
    notifyListeners();
  }

  void toggleSync(bool? val) {
    _isSyncChecked = val ?? false;
    notifyListeners();
  }

  // --- Submit Logic ---

  Future<PaymentInfoModel> submit() async {
    final currentModel = _buildCurrentModel();

    // 如果使用者勾選了同步，寫入 Secure Storage
    if (_mode == PaymentMode.specific && _isSyncChecked && showSyncOption) {
      await _storage.write(key: _storageKey, value: currentModel.toJson());
    }

    return currentModel;
  }

  PaymentInfoModel _buildCurrentModel() {
    if (_mode == PaymentMode.private) {
      return const PaymentInfoModel(mode: PaymentMode.private);
    }

    final apps = _enableApps
        ? _appControllers
            .where((c) => c.nameCtrl.text.isNotEmpty) // 過濾空的
            .map((c) =>
                PaymentAppInfo(name: c.nameCtrl.text, link: c.linkCtrl.text))
            .toList()
        : <PaymentAppInfo>[];

    return PaymentInfoModel(
      mode: PaymentMode.specific,
      acceptCash: _acceptCash,
      bankName: _enableBank ? bankNameCtrl.text : null,
      bankAccount: _enableBank ? bankAccountCtrl.text : null,
      paymentApps: apps,
    );
  }

  @override
  void dispose() {
    bankNameCtrl.dispose();
    bankAccountCtrl.dispose();
    for (var c in _appControllers) {
      c.dispose();
    }
    super.dispose();
  }
}

// Helper Controller for Dynamic List
class PaymentAppEditingController {
  final TextEditingController nameCtrl;
  final TextEditingController linkCtrl;

  PaymentAppEditingController({String name = '', String link = ''})
      : nameCtrl = TextEditingController(text: name),
        linkCtrl = TextEditingController(text: link);

  void dispose() {
    nameCtrl.dispose();
    linkCtrl.dispose();
  }
}
