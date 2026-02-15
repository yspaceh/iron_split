import 'package:flutter/foundation.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class S00SystemBootstrapViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final PendingInviteProvider _pendingProvider;

  // 1. 使用 LoadStatus 管理狀態
  LoadStatus _initStatus = LoadStatus.initial;

  // 2. 儲存決定好的去向
  BootstrapDestination? _destination;

  // 3. 錯誤處理
  AppErrorCodes? _initErrorCode;

  // --- Getters ---
  LoadStatus get initStatus => _initStatus;
  BootstrapDestination? get destination => _destination;
  AppErrorCodes? get initErrorCode => _initErrorCode;

  // 簡化 Getter，直接回傳字串即可，不需要回傳 Function
  String? get pendingCode => _pendingProvider.pendingCode;

  S00SystemBootstrapViewModel({
    required AuthRepository authRepo,
    required PendingInviteProvider pendingProvider,
  })  : _authRepo = authRepo,
        _pendingProvider = pendingProvider;

  /// 初始化 App 狀態，決定去向
  Future<void> initApp() async {
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 1. 人為延遲 (為了讓 Logo 展示一下，避免閃爍)
      await Future.delayed(const Duration(milliseconds: 800));

      final user = _authRepo.currentUser;
      final code = pendingCode; // 使用 getter

      // 2. 檢查登入狀態 (移到 VM)
      if (user == null) {
        _destination = BootstrapDestination.onboarding;
        _initStatus = LoadStatus.success;
        notifyListeners();
        return;
      }

      // 3. 檢查條款版本 (Repository)
      // 這是一個非同步操作，可能會因為網路問題失敗，所以放在 try-catch 裡
      final isValid = await _authRepo.isTermsValid();
      if (!isValid) {
        _destination = BootstrapDestination.updateTerms;
        _initStatus = LoadStatus.success;
        notifyListeners();
        return;
      }

      // 4. 檢查是否有名字
      if (user.displayName == null || user.displayName!.isEmpty) {
        _destination = BootstrapDestination.setupName;
        _initStatus = LoadStatus.success;
        notifyListeners();
        return;
      }

      // 5. 檢查是否有邀請碼
      if (code != null) {
        _destination = BootstrapDestination.confirmInvite;
        _initStatus = LoadStatus.success;
        notifyListeners();
        return;
      }

      // 6. 一切正常，進入首頁
      _destination = BootstrapDestination.home;
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
}
