import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class S74DeleteAccountNoticeViewModel extends ChangeNotifier {
  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  S74DeleteAccountNoticeViewModel();

  /// 執行刪除帳號邏輯
  /// Returns: true if success
  Future<bool> deleteAccount() async {
    _isProcessing = true;
    notifyListeners();

    try {
      // 🔥 加入這兩行，直接檢查 Firebase Auth 真正的底層狀態
      final user = FirebaseAuth.instance.currentUser;
      debugPrint(
          "🔥 [Debug] Firebase真實登入狀態: ${user != null ? '已登入' : '未登入 (兇手就是這個！)'}");
      debugPrint("🔥 [Debug] Firebase UID: ${user?.uid}");

      // 1. 呼叫後端 Cloud Function 執行資料清理 (移交隊長、轉為幽靈等)
      // 這對應我們在 index.ts 寫好的 deleteUserAccount
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('deleteUserAccount');
      await callable.call();

      // 2. 清除本機儲存資料 (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. 清除安全儲存資料 (如果有用到的話，建議一併清除)
      const storage = FlutterSecureStorage();
      await storage.deleteAll();

      // 4. Firebase 登出
      // 雖然 Cloud Function 已經刪除了 Auth User，但前端狀態可能還沒更新
      // 手動登出確保前端狀態重置
      await FirebaseAuth.instance.signOut();

      return true;
    } catch (e) {
      debugPrint("Delete Account Failed: $e");
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
