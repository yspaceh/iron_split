import 'package:flutter/material.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart'; // [新增]

class S50OnboardingConsentViewModel extends ChangeNotifier {
  // 建立 Repo 實例
  final AuthRepository _repo = AuthRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// 同意條款並繼續
  Future<void> agreeAndContinue({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      // 1. 先執行匿名登入 (確保有 UID)
      await _repo.signInAnonymously();

      // 2. 寫入版本號到 Firestore
      await _repo.acceptLegalTerms();

      // 3. 成功，通知 UI 跳轉
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
