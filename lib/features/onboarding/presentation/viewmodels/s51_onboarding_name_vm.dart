import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class S51OnboardingNameViewModel extends ChangeNotifier {
  final OnboardingService _service;
  final AuthRepository _authRepo;

  // State
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _submitStatus = LoadStatus.initial;

  // UI State
  bool _isValid = false;
  String _currentName = '';

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get submitStatus => _submitStatus;
  bool get isValid => _isValid;
  int get currentLength => _currentName.length;

  S51OnboardingNameViewModel(
      {required OnboardingService service, required AuthRepository authRepo})
      : _service = service,
        _authRepo = authRepo;

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

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

  /// 處理文字輸入變更
  void onNameChanged(String value) {
    _currentName = value;

    // 呼叫 Service 驗證規則
    // 只有當 Service 說沒問題，且長度 > 0 時，才算 Valid
    final validationError = _service.validateName(value);
    final isValidFormat = validationError == null;
    final isNotEmpty = value.trim().isNotEmpty;

    _isValid = isNotEmpty && isValidFormat;

    notifyListeners();
  }

  /// 處理儲存動作
  /// onSuccess: 儲存成功後的回調 (通常是用於導航)
  Future<void> saveName() async {
    if (!_isValid || _submitStatus == LoadStatus.loading) return;

    _submitStatus = LoadStatus.loading;
    notifyListeners();

    try {
      await _service.submitName(_currentName);
      _submitStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _submitStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _submitStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
