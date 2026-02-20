import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:http/http.dart' as http;
import 'package:iron_split/core/enums/app_error_codes.dart';

class CurrencyService {
  static Future<double> fetchRate({
    required String from,
    required String to,
  }) async {
    // 1. 如果幣別相同，直接回傳 1.0 (不浪費流量)
    if (from == to) return 1.0;

    try {
      // 使用第三方匯率 API (Open ER API)
      final urlString = 'https://open.er-api.com/v6/latest/$from';
      final url = Uri.parse(urlString);

      // 增加逾時控制 (10秒)，避免無限等待
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Open ER 的結構也是 { "rates": { "TWD": 0.21, ... } }
        if (data['rates'] != null && data['rates'][to] != null) {
          final rate = data['rates'][to];
          // 確保轉型為 double
          return (rate as num).toDouble();
        }
        // 找不到對應的目標匯率 (例如 API 暫時沒資料)
        throw AppErrorCodes.rateFetchFailed;
      } else {
        throw AppErrorCodes.rateFetchFailed;
      }
    } on AppErrorCodes {
      rethrow;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: '取得匯率失敗 (CurrencyService fetchRate)',
      );
      throw AppErrorCodes.rateFetchFailed; // 其他系統錯誤轉化後拋出
    }
  }
}
