import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart'; // [新增]

class S50OnboardingConsentViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;

  LoadStatus _agreeStatus = LoadStatus.initial;

  LoadStatus get agreeStatus => _agreeStatus;

  S50OnboardingConsentViewModel({
    required AuthRepository authRepo,
  }) : _authRepo = authRepo;

  /// 同意條款並繼續
  Future<void> agreeAndContinue() async {
    if (_agreeStatus == LoadStatus.loading) return;

    _agreeStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 先執行匿名登入 (確保有 UID)
      await _authRepo.signInAnonymously();

      // 2. 寫入版本號到 Firestore
      await _authRepo.acceptLegalTerms();

      // 3. 成功，通知 UI 跳轉
      _agreeStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _agreeStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _agreeStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
