import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyLastCurrency = 'last_used_currency';

  /// 儲存使用者最後使用的幣別
  static Future<void> saveLastCurrency(String currencyCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_keyLastCurrency, currencyCode);

      if (!success) {
        throw AppErrorCodes.saveFailed;
      }
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw AppErrorCodes.saveFailed;
    }
  }

  /// 取得上次幣別，若無則回傳 null
  static Future<String?> getLastCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyLastCurrency);
    } catch (e) {
      // 讀取本地設定失敗通常歸類為初始化異常
      throw AppErrorCodes.initFailed;
    }
  }
}
