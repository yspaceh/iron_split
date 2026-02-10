// lib/features/system/presentation/viewmodels/s70_system_settings_vm.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/gen/strings.g.dart'; // 引入 AppLocale

class S70SystemSettingsViewModel extends ChangeNotifier {
  final OnboardingService _onboardingService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';

  // --- Controllers & State ---
  final TextEditingController nameController = TextEditingController();

  bool _isLoading = false;

  // [修改] 直接使用 AppLocale
  AppLocale _currentLocale = LocaleSettings.currentLocale;

  PaymentInfoModel? _paymentInfo;

  // --- Getters ---
  bool get isLoading => _isLoading;
  AppLocale get currentLocale => _currentLocale; // [修改] Getter 也是 AppLocale
  PaymentInfoModel? get paymentInfo => _paymentInfo;

  S70SystemSettingsViewModel({
    required OnboardingService onboardingService,
    required String initialName,
  }) : _onboardingService = onboardingService {
    nameController.text = initialName;
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. 初始化語言狀態
      _currentLocale = LocaleSettings.currentLocale;

      // 2. 讀取 Secure Storage
      final jsonStr = await _storage.read(key: _storageKey);
      if (jsonStr != null) {
        _paymentInfo = PaymentInfoModel.fromJson(jsonStr);
      }
    } catch (e) {
      debugPrint("Error initializing S70 settings: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Actions ---

  Future<void> updateName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final error = _onboardingService.validateName(newName);
      if (error == null) {
        await _onboardingService.submitName(newName);
      }
    } catch (e) {
      debugPrint("Update name failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // [修改] 更新語言設定 (直接接收 AppLocale)
  void updateLanguage(AppLocale newLocale) {
    if (newLocale == _currentLocale) return;

    // 1. 更新 UI 狀態
    _currentLocale = newLocale;

    // 2. 套用到 slang
    LocaleSettings.setLocale(newLocale);

    notifyListeners();
  }

  Future<void> refreshPaymentInfo() async {
    final jsonStr = await _storage.read(key: _storageKey);
    if (jsonStr != null) {
      _paymentInfo = PaymentInfoModel.fromJson(jsonStr);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
