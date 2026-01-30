import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PendingInviteLocalStore {
  static const _key = 'pending_invite_data';

  /// 儲存邀請碼與當下時間戳記
  Future<void> saveCode(String code) async {
    final sp = await SharedPreferences.getInstance();
    final data = {
      'code': code,
      'receivedAt': DateTime.now().toIso8601String(),
    };
    await sp.setString(_key, jsonEncode(data));
  }

  /// 讀取並驗證 15 分鐘 TTL
  Future<String?> getValidCode() async {
    final sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(_key);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final String code = data['code'];
      final DateTime receivedAt = DateTime.parse(data['receivedAt']);

      // 檢查是否超過 15 分鐘
      if (DateTime.now().difference(receivedAt).inMinutes < 15) {
        return code;
      } else {
        await clear(); // 已過期則自動清空
        return null;
      }
    } catch (e) {
      await clear();
      return null;
    }
  }

  /// 清除落盤資料
  Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_key);
  }
}