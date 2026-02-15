// lib/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/features/system/data/system_repository.dart';

class S73SystemSettingsPaymentInfoViewModel extends ChangeNotifier {
  final PaymentInfoFormController formController = PaymentInfoFormController();
  final AuthRepository _authRepo;
  final SystemRepository _systemRepo;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _saveStatus = LoadStatus.initial;

  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get saveStatus => _saveStatus;

  S73SystemSettingsPaymentInfoViewModel({
    required AuthRepository authRepo,
    required SystemRepository systemRepo,
  })  : _authRepo = authRepo,
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

      final loadedData = await _systemRepo.getDefaultPaymentInfo();

      // 將讀取到的資料填入表單
      formController.loadData(loadedData);
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

  /// 儲存設定
  Future<void> save() async {
    if (_saveStatus == LoadStatus.loading) return;
    _saveStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 從 Controller 產生最新的 Model
      final currentInfo = formController.buildModel();

      // 2. 轉成 JSON 字串並寫入 Secure Storage
      await _systemRepo.saveDefaultPaymentInfo(currentInfo);

      _saveStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _saveStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    try {
      formController.removeListener(notifyListeners);
      formController.dispose();
    } catch (_) {}
    super.dispose();
  }
}
