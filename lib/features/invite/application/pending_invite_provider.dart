import 'package:flutter/material.dart';
import '../data/pending_invite_local_store.dart';

class PendingInviteProvider extends ChangeNotifier {
  final PendingInviteLocalStore _store = PendingInviteLocalStore();
  String? _pendingCode;

  String? get pendingCode => _pendingCode;

  /// 初始化：從磁碟載入並檢查 TTL
  Future<void> init() async {
    _pendingCode = await _store.getValidCode();
    notifyListeners();
  }

  /// 儲存邀請碼：同步更新記憶體與磁碟
  Future<void> saveInvite(String code) async {
    _pendingCode = code;
    await _store.saveCode(code);
    notifyListeners();
  }

  /// 清除邀請碼：成功加入或判定失效時執行
  Future<void> clear() async {
    _pendingCode = null;
    await _store.clear();
    notifyListeners();
  }
}