// lib/features/system/presentation/viewmodels/s70_system_settings_vm.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
// 引入 AppLocale

class S70SystemSettingsViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final OnboardingService _onboardingService;
  final SystemRepository _systemRepo;

  // --- Controllers & State ---
  final TextEditingController nameController = TextEditingController();

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _updateStatus = LoadStatus.initial;

  PaymentInfoModel? _paymentInfo;

  // --- Getters ---
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get updateStatus => _updateStatus;
  PaymentInfoModel? get paymentInfo => _paymentInfo;

  S70SystemSettingsViewModel({
    required OnboardingService onboardingService,
    required SystemRepository systemRepo,
    required String initialName,
    required AuthRepository authRepo,
  })  : _onboardingService = onboardingService,
        _systemRepo = systemRepo,
        _authRepo = authRepo {
    nameController.text = initialName;
  }

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;
      if (user.displayName == null) throw AppErrorCodes.dataNotFound;
      nameController.text = user.displayName!;

      // 2. 讀取 Secure Storage
      _paymentInfo = await _systemRepo.getDefaultPaymentInfo();

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

  // --- Actions ---

  Future<void> updateName() async {
    if (_updateStatus == LoadStatus.loading) return;
    _updateStatus = LoadStatus.loading;
    notifyListeners();
    final newName = nameController.text.trim();
    if (newName.isEmpty) throw AppErrorCodes.fieldRequired;

    try {
      _onboardingService.validateName(newName);
      await _onboardingService.submitName(newName);
      _updateStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _updateStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _updateStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
