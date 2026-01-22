import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyLastCurrency = 'last_used_currency';

  /// 儲存使用者最後使用的幣別
  static Future<void> saveLastCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastCurrency, currencyCode);
  }

  /// 取得上次幣別，若無則回傳 null
  static Future<String?> getLastCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastCurrency);
  }
}
