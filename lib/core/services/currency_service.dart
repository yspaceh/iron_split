import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  static Future<double?> fetchRate({
    required String from,
    required String to,
  }) async {
    // 1. 如果幣別相同，直接回傳 1.0 (不浪費流量)
    if (from == to) return 1.0;

    try {
      // 這個 API 支援 TWD，且不需要 API Key
      final urlString = 'https://open.er-api.com/v6/latest/$from';

      final url = Uri.parse(urlString);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Open ER 的結構也是 { "rates": { "TWD": 0.21, ... } }
        if (data['rates'] != null && data['rates'][to] != null) {
          final rate = data['rates'][to];
          // 確保轉型為 double
          return (rate as num).toDouble();
        }
      } else {
        // TODO: Handle non-200 status codes (e.g., log to Crashlytics)
        debugPrint(
            'API Error: Status ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // TODO: Log error to Crashlytics or Analytics
      debugPrint('API Exception: $e');
    }
    return null;
  }
}
