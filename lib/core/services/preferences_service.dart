import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  static const String _keyLastCurrency = 'last_used_currency';
  static const String _keyDefaultPaymentInfo = 'user_default_payment_info';

  /// 建構子：注入 SharedPreferences 與 SecureStorage
  PreferencesService(this._prefs, {FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// 清除所有本機資料 (登出或刪除帳號時使用)
  Future<void> clearAll() async {
    try {
      // 1. 清除一般設定 (SharedPreferences)
      await _prefs.clear();

      // 2. 清除敏感資料 (SecureStorage)
      await _secureStorage.deleteAll();
    } catch (e) {
      // 清除失敗通常不阻擋流程，但可以記錄 Log
      throw AppErrorCodes.unknown;
    }
  }

  /// 儲存使用者最後使用的幣別 (移除 static)
  Future<void> saveLastCurrency(String currencyCode) async {
    try {
      final success = await _prefs.setString(_keyLastCurrency, currencyCode);
      if (!success) throw AppErrorCodes.saveFailed;
    } catch (e) {
      throw AppErrorCodes.saveFailed;
    }
  }

  /// 取得上次幣別 (移除 static)
  String? getLastCurrency() {
    // 因為 _prefs 已經在 main 初始化過，這裡可以直接同步讀取，不需要 Future
    try {
      return _prefs.getString(_keyLastCurrency);
    } catch (e) {
      return null;
    }
  }

  /// 儲存預設收款資訊
  Future<void> saveDefaultPaymentInfo(String jsonString) async {
    try {
      await _secureStorage.write(
          key: _keyDefaultPaymentInfo, value: jsonString);
    } catch (e) {
      // 這裡可以考慮拋出 AppErrorCodes.storageWriteFailed
      throw AppErrorCodes.saveFailed;
    }
  }

  /// 讀取預設收款資訊
  Future<String?> getDefaultPaymentInfo() async {
    try {
      return await _secureStorage.read(key: _keyDefaultPaymentInfo);
    } catch (e) {
      // 讀取失敗視為無資料
      return null;
    }
  }
}
