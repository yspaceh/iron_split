import 'package:flutter/material.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';

class S51OnboardingNameViewModel extends ChangeNotifier {
  final OnboardingService _service;

  // UI State
  bool _isSaving = false;
  bool _isValid = false;
  String _currentName = '';

  // Getters
  bool get isSaving => _isSaving;
  bool get isValid => _isValid;
  int get currentLength => _currentName.length;

  S51OnboardingNameViewModel({required OnboardingService service})
      : _service = service;

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
  Future<void> saveName(
      {required VoidCallback onSuccess,
      required Function(String) onError}) async {
    if (!_isValid || _isSaving) return;

    _isSaving = true;
    notifyListeners();

    try {
      await _service.submitName(_currentName);
      onSuccess();
    } catch (e) {
      print('Error saving name: $e');
      // TODO: handle error
      onError(e.toString());
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
