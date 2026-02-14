import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

class S74DeleteAccountNoticeViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;
  final PreferencesService _prefsService;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _deleteStatus = LoadStatus.initial;

  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get deleteStatus => _deleteStatus;

  S74DeleteAccountNoticeViewModel({
    required AuthRepository authRepo,
    required PreferencesService prefsService,
  })  : _authRepo = authRepo,
        _prefsService = prefsService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 3. 成功 (此頁面不需要撈資料，確認有人就好)
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

  /// 執行刪除帳號邏輯
  /// Returns: true if success
  Future<void> deleteAccount() async {
    if (_deleteStatus == LoadStatus.loading) return;
    _deleteStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 🔥 加入這兩行，直接檢查 Firebase Auth 真正的底層狀態
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 1. 呼叫後端 Cloud Function 執行資料清理 (移交隊長、轉為幽靈等)
      // 這對應我們在 index.ts 寫好的 deleteUserAccount
      await _authRepo.deleteUserAccountPermanently();

      // 2. 清除本機資料 (非關鍵)
      try {
        await _prefsService.clearAll();
      } catch (e) {
        // 如果清除失敗 (例如硬碟鎖死)，不影響"帳號已刪除"的事實
        // 記錄 Log 即可，不要拋出錯誤
      }

      // 3. 登出 (非關鍵)
      try {
        await _authRepo.signOut();
      } catch (e) {
        // 如果登出失敗 (例如網路剛好斷了)，也不要報錯
        // 因為帳號已經沒了，使用者下次進來一樣會被擋在門外
      }

      _deleteStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _deleteStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _deleteStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
