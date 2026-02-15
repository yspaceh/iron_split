import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/data/system_repository.dart';

class S72TermsUpdateViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final SystemRepository _systemRepo;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _agreeStatus = LoadStatus.initial;
  LoadStatus _logoutStatus = LoadStatus.initial;
  UpdateType _type = UpdateType.none;
  LegalTab _currentTab = LegalTab.terms;

  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get agreeStatus => _agreeStatus;
  LoadStatus get logoutStatus => _logoutStatus;
  UpdateType get type => _type;
  LegalTab get currentTab => _currentTab;

  S72TermsUpdateViewModel({
    required AuthRepository authRepo,
    required SystemRepository systemRepo,
  })  : _authRepo = authRepo,
        _systemRepo = systemRepo;

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      final status = await _systemRepo.checkLegalVersionStatus(user.uid);

      if (status.tosOutdated && status.privacyOutdated) {
        _type = UpdateType.both;
        _currentTab = LegalTab.terms;
      } else if (status.tosOutdated) {
        _type = UpdateType.tosOnly;
        _currentTab = LegalTab.terms;
      } else if (status.privacyOutdated) {
        _type = UpdateType.privacyOnly;
        _currentTab = LegalTab.privacy;
      } else {
        _type = UpdateType.none;
      }

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

  /// 切換 Tab
  void setTab(LegalTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  /// 同意並繼續
  Future<void> agreeLatestTerms() async {
    if (_agreeStatus == LoadStatus.loading) return;
    _agreeStatus = LoadStatus.loading;
    notifyListeners();

    try {
      await _authRepo.acceptLegalTerms();
      _agreeStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _agreeStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _agreeStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_logoutStatus == LoadStatus.loading) return;
    _logoutStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 🔥 加入這兩行，直接檢查 Firebase Auth 真正的底層狀態
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 登出 (非關鍵)
      try {
        await _authRepo.signOut();
      } catch (e) {
        // 如果登出失敗 (例如網路剛好斷了)，也不要報錯
        // 因為帳號已經沒了，使用者下次進來一樣會被擋在門外
      }

      _logoutStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _logoutStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _logoutStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
