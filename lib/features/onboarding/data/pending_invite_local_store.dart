import 'dart:convert';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingInviteLocalStore {
  static const _key = 'pending_invite_data';

  /// 儲存邀請碼與當下時間戳記
  Future<void> saveCode(String code) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final data = {
        'code': code,
        'receivedAt': DateTime.now().toIso8601String(),
      };
      // setString 回傳 bool，若為 false 代表寫入失敗
      final success = await sp.setString(_key, jsonEncode(data));
      if (!success) {
        throw AppErrorCodes.saveFailed;
      }
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw AppErrorCodes.saveFailed;
    }
  }

  /// 讀取並驗證 15 分鐘 TTL
  Future<String?> getValidCode() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final jsonString = sp.getString(_key);
      if (jsonString == null) return null;

      try {
        final decodedData = jsonDecode(jsonString);
        if (decodedData is! Map<String, dynamic>) {
          await clear(); // 資料格式壞了，順手清掉
          return null;
        }
        final data = decodedData;
        final String? code = data['code'] as String?;
        final String? receivedAtString = data['receivedAt'] as String?;

        if (code == null || receivedAtString == null) {
          await clear();
          return null; // 資料不完整，視為無效
        }

        final DateTime? receivedAt = DateTime.tryParse(receivedAtString);
        if (receivedAt == null) {
          await clear();
          return null; // 日期格式錯誤，視為無效
        }

        // 檢查是否超過 15 分鐘
        if (DateTime.now().difference(receivedAt).inMinutes < 15) {
          return code;
        } else {
          await clear(); // 已過期則自動清空
          return null;
        }
      } catch (e) {
        // 解析失敗 (資料損壞)，清除並回傳 null
        await clear();
        return null;
      }
    } catch (e) {
      // 若是 SharedPreferences 本身初始化失敗，視為 initFailed
      // 但為了讓 App 能繼續執行，這裡通常也建議回傳 null (視為無邀請)
      return null;
    }
  }

  /// 清除落盤資料
  Future<void> clear() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.remove(_key);
    } catch (e) {
      // 清除失敗通常不影響業務，可選擇忽略或拋出 deleteFailed
      throw AppErrorCodes.deleteFailed;
    }
  }
}
