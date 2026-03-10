import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class S50OnboardingConsentViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final OnboardingService _service;
  final TextEditingController nameController = TextEditingController();

  // State
  LoadStatus _submitStatus = LoadStatus.initial;
  bool _isValid = false;

  // Getters
  LoadStatus get submitStatus => _submitStatus;
  bool get isValid => _isValid;
  int get currentLength => nameController.text.length;

  S50OnboardingConsentViewModel({
    required AuthRepository authRepo,
    required OnboardingService service,
  })  : _authRepo = authRepo,
        _service = service {
    // 2. 在建構子直接綁定監聽
    nameController.addListener(_validateName);
  }

  /// 處理文字輸入變更 (與原 S51 邏輯相同)
  void _validateName() {
    final value = nameController.text;
    bool newIsValid;

    try {
      _service.validateName(value);
      newIsValid = true;
    } catch (e) {
      newIsValid = false;
    }

    if (_isValid != newIsValid) {
      _isValid = newIsValid;
      notifyListeners();
    }
  }

  /// 一鍵完成：匿名登入 -> 寫入條款 -> 儲存名字
  Future<void> submit() async {
    if (!_isValid || _submitStatus == LoadStatus.loading) return;

    _submitStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 先執行匿名登入 (確保有 UID)
      await _authRepo.signInAnonymously();

      // 2. 寫入版本號到 Firestore
      await _authRepo.acceptLegalTerms();

      // 3. 儲存使用者名字
      await _service.submitName(nameController.text);

      // 4. 成功，通知 UI 跳轉
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

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
