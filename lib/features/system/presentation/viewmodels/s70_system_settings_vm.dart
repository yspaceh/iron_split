// lib/features/system/presentation/viewmodels/s70_system_settings_vm.dart

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
// 引入 AppLocale

class S70SystemSettingsViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final OnboardingService _onboardingService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _storageKey = 'user_default_payment_info';

  // --- Controllers & State ---
  final TextEditingController nameController = TextEditingController();

  bool _isLoading = false;

  PaymentInfoModel? _paymentInfo;

  // --- Getters ---
  bool get isLoading => _isLoading;
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
