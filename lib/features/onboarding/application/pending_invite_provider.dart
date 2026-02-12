import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import '../data/pending_invite_local_store.dart';

class PendingInviteProvider extends ChangeNotifier {
  final PendingInviteLocalStore _store = PendingInviteLocalStore();
  String? _pendingCode;

  String? get pendingCode => _pendingCode;

  /// 初始化：從磁碟載入並檢查 TTL
  Future<void> init() async {
    final storedCode = await _store.getValidCode();
    if (_pendingCode == null && storedCode != null) {
      _pendingCode = storedCode;
      notifyListeners();
    }
  }

  /// 儲存邀請碼：同步更新記憶體與磁碟
  Future<void> saveInvite(String code) async {
    try {
      // (若 _store 拋出 saveFailed，這裡就會中斷，不會誤更新 UI)
      await _store.saveCode(code);

      // 2. 寫入成功後，才更新記憶體狀態
      _pendingCode = code;
      notifyListeners();
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw AppErrorCodes.saveFailed;
    }
  }

  /// 清除邀請碼：成功加入或判定失效時執行
  Future<void> clear() async {
    try {
      await _store.clear();

      // 清除成功才更新 UI
      _pendingCode = null;
      notifyListeners();
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw AppErrorCodes.deleteFailed;
    }
  }
}
