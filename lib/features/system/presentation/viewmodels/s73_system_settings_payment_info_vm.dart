// lib/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';

class S73SystemSettingsPaymentInfoViewModel extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';
  final PaymentInfoFormController formController = PaymentInfoFormController();

  // UI States
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  S73SystemSettingsPaymentInfoViewModel() {
    formController.addListener(notifyListeners);
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      final jsonStr = await _storage.read(key: _storageKey);
      PaymentInfoModel? loadedData;

      if (jsonStr != null) {
        // 使用 try-catch 避免 JSON 格式錯誤導致崩潰
        try {
          loadedData = PaymentInfoModel.fromJson(jsonStr);
        } catch (e) {
          debugPrint("JSON parse error: $e");
        }
      }

      // 將讀取到的資料填入表單
      formController.loadData(loadedData);
    } catch (e) {
      debugPrint("Error loading payment info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 儲存設定
  /// [onSuccess] 儲存成功後的回呼 (通常是 pop 頁面)
  Future<void> save(VoidCallback onSuccess) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. 從 Controller 產生最新的 Model
      final currentInfo = formController.buildModel();

      // 2. 轉成 JSON 字串並寫入 Secure Storage
      await _storage.write(
        key: _storageKey,
        value: currentInfo.toJson(),
      );

      // 3. 成功回調
      onSuccess();
    } catch (e) {
      debugPrint("Error saving payment info: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
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
