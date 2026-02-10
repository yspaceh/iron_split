// lib/features/system/presentation/viewmodels/s70_system_settings_vm.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 引入 AppLocale

class S70SystemSettingsViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
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
    required AuthRepository authRepo,
  })  : _onboardingService = onboardingService,
        _authRepo = authRepo {
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

      final currentUser = _authRepo.currentUser; // 需注入 AuthRepo
      if (currentUser != null && currentUser.displayName != null) {
        nameController.text = currentUser.displayName!;
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
  Future<void> updateLanguage(AppLocale newLocale) async {
    if (newLocale == _currentLocale) return;

    // 1. 更新 UI 狀態
    _currentLocale = newLocale;

    // 2. 套用到 slang
    LocaleSettings.setLocale(newLocale);

    notifyListeners();
    // 3. [新增] 持久化儲存到手機
    try {
      final prefs = await SharedPreferences.getInstance();
      // 儲存語言代碼 (例如 'zh', 'en', 'ja')
      // AppLocale 轉字串的方法通常是 .languageCode 或是 toString()
      // slang 產生的 AppLocale enum 通常可以直接 name 屬性
      await prefs.setString('app_locale', newLocale.languageCode);
      // 注意：如果是 zh_Hant 這種含地區的，可能要存 full tag
    } catch (e) {
      debugPrint("Failed to save locale: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
