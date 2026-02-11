import 'package:flutter/foundation.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

enum BootstrapDestination {
  onboarding, // 去 S50 (同意條款)
  setupName, // 去 S51 (取名)
  confirmInvite, // 去 S11 (確認邀請)
  home, // 去 S10 (首頁)
  updateTerms, // 去 S72 (更新條款)
}

class S00SystemBootstrapViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  /// 初始化 App 狀態，決定去向
  /// [pendingInviteCode] 從 Provider 傳入，如果有值代表有點擊邀請連結
  Future<BootstrapDestination> initApp(
      {required String? Function() getPendingCode}) async {
    // 1. 人為延遲 (為了讓 Logo 展示一下)
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _repo.currentUser;

    final pendingInviteCode = getPendingCode();

    // 2. 檢查登入狀態
    if (user == null) {
      return BootstrapDestination.onboarding;
    }

    // 3. 檢查條款版本 (使用剛剛封裝好的 Repo 方法)
    final isValid = await _repo.isTermsValid();
    if (!isValid) {
      return BootstrapDestination.updateTerms; // 過期了，踢回去重簽
    }
    // 4. 檢查是否有名字
    if (user.displayName == null || user.displayName!.isEmpty) {
      return BootstrapDestination.setupName;
    }
    // 5. 檢查是否有邀請碼
    if (pendingInviteCode != null) {
      return BootstrapDestination.confirmInvite;
    }

    // 6. 一切正常
    return BootstrapDestination.home;
  }
}
