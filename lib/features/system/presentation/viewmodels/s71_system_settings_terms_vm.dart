import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';

class S71SystemSettingsTermsViewModel extends ChangeNotifier {
  // 狀態管理 (Rule 5)
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  String? _targetUrl;

  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String? get targetUrl => _targetUrl;

  S71SystemSettingsTermsViewModel();

  /// 初始化：生成 URL 並檢查權限
  /// [locale] 從 UI 傳入，用於判斷語系
  Future<void> init(bool isTerms, Locale locale) async {
    // 避免重複載入
    if (_initStatus == LoadStatus.loading ||
        _initStatus == LoadStatus.success) {
      return;
    }

    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 2. 處理 URL 生成邏輯 (Rule 1: 邏輯移出 UI)
      final String folder = isTerms ? 'terms' : 'privacy';

      String filename = 'en_us';
      if (locale.languageCode == 'zh') {
        filename = 'zh_tw';
      } else if (locale.languageCode == 'ja') {
        filename = 'ja_jp';
      }

      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      _targetUrl =
          '${AppConstants.baseUrl}/legal/$folder/$filename.html?v=$timestamp';

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
