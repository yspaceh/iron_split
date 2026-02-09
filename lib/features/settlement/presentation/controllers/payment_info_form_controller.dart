// 路徑: lib/features/common/presentation/controllers/payment_info_form_controller.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/models/payment_info_model.dart';

// [保留] 使用您原始的命名 PaymentAppEditingController
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

/// [Controller] 用於管理 PaymentInfoForm 的狀態
/// 讓 S31VM 和 B05VM 都可以直接操作表單數據
class PaymentInfoFormController extends ChangeNotifier {
  PaymentMode _mode = PaymentMode.private;
  bool _acceptCash = true;
  bool _enableBank = false;
  bool _enableApps = false;

  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController bankAccountCtrl = TextEditingController();

  // [保留] 使用您原始的命名 appControllers
  final List<PaymentAppEditingController> appControllers = [];

  // [重點] 保留您原始的建構子邏輯，用於載入初始資料
  PaymentInfoFormController({
    PaymentInfoModel? initialData,
  }) {
    if (initialData != null) {
      _mode = initialData.mode;

      if (_mode == PaymentMode.specific) {
        _acceptCash = initialData.acceptCash;

        if (initialData.bankName != null || initialData.bankAccount != null) {
          _enableBank = true;
          bankNameCtrl.text = initialData.bankName ?? '';
          bankAccountCtrl.text = initialData.bankAccount ?? '';
        }

        if (initialData.paymentApps.isNotEmpty) {
          _enableApps = true;
          for (var app in initialData.paymentApps) {
            appControllers.add(
                PaymentAppEditingController(name: app.name, link: app.link));
          }
        }
      }
    }
  }

  // Getters
  PaymentMode get mode => _mode;
  bool get acceptCash => _acceptCash;
  bool get enableBank => _enableBank;
  bool get enableApps => _enableApps;

  // Setters
  void setMode(PaymentMode value) {
    _mode = value;
    notifyListeners();
  }

  void toggleAcceptCash(bool? value) {
    _acceptCash = value ?? false;
    notifyListeners();
  }

  void toggleEnableBank(bool? value) {
    _enableBank = value ?? false;
    notifyListeners();
  }

  void toggleEnableApps(bool? value) {
    _enableApps = value ?? false;
    if (_enableApps && appControllers.isEmpty) {
      addApp();
    }
    notifyListeners();
  }

  void addApp() {
    appControllers.add(PaymentAppEditingController());
    notifyListeners();
  }

  void removeApp(int index) {
    if (index >= 0 && index < appControllers.length) {
      appControllers[index].dispose();
      appControllers.removeAt(index);
      notifyListeners();
    }
  }

  // [保留] 額外提供 loadData 方法，方便非建構子注入的情況 (例如 S31 異步載入)
  void loadData(PaymentInfoModel? data) {
    if (data == null) return;

    // 清除舊狀態
    _mode = data.mode;
    if (_mode == PaymentMode.specific) {
      _acceptCash = data.acceptCash;

      if (data.bankName != null || data.bankAccount != null) {
        _enableBank = true;
        bankNameCtrl.text = data.bankName ?? '';
        bankAccountCtrl.text = data.bankAccount ?? '';
      }

      if (data.paymentApps.isNotEmpty) {
        _enableApps = true;
        appControllers.clear();
        for (var app in data.paymentApps) {
          appControllers
              .add(PaymentAppEditingController(name: app.name, link: app.link));
        }
      }
    }
    notifyListeners();
  }

  PaymentInfoModel buildModel() {
    if (_mode == PaymentMode.private) {
      return const PaymentInfoModel(mode: PaymentMode.private);
    }

    final apps = _enableApps
        ? appControllers
            .where((c) => c.nameCtrl.text.isNotEmpty)
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
    for (var c in appControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
