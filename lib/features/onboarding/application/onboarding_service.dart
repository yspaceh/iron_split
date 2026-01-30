import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class OnboardingService {
  final AuthRepository _authRepository;

  OnboardingService({required AuthRepository authRepository})
      : _authRepository = authRepository;

  /// 驗證名字格式 (業務規則)
  /// 回傳錯誤訊息，若為 null 代表驗證通過
  String? validateName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return null; // 空值不回傳錯誤，只是未完成
    }

    if (trimmed.length > 10) {
      return 'Name too long'; // 雖然 UI 有擋，後端邏輯也要擋
    }

    // 禁止控制字元 (Regex 規則從原本 UI 搬過來)
    final hasControlChars = trimmed.contains(RegExp(r'[\x00-\x1F\x7F]'));
    if (hasControlChars) {
      return 'Contains invalid characters';
    }

    return null; // Valid
  }

  /// 提交名字
  Future<void> submitName(String name) async {
    // 再次確認驗證 (防禦性程式設計)
    if (validateName(name) != null) {
      throw Exception('Invalid name format');
    }
    await _authRepository.updateDisplayName(name.trim());
  }
}
