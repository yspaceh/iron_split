import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';

enum UpdateType {
  none,
  tosOnly, // 只有條款更新
  privacyOnly, // 只有隱私更新
  both, // 兩個都更新
}

// 用於 CustomSlidingSegment 的 Key
enum LegalTab { terms, privacy }

class S72TermsUpdateViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAgreed = false; // 按鈕 Loading
  bool get isAgreed => _isAgreed;

  UpdateType _type = UpdateType.none;
  UpdateType get type => _type;

  // [新增] 當前顯示的 Tab (預設先顯示 Terms)
  LegalTab _currentTab = LegalTab.terms;
  LegalTab get currentTab => _currentTab;

  /// 初始化：檢查版本
  Future<void> checkUpdateType() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _repo.currentUser;
      if (user == null) return;

      final results = await Future.wait([
        _firestore.collection('config').doc('legal').get(),
        _firestore.collection('users').doc(user.uid).get(),
      ]);

      final sysData = results[0].data();
      final userData = results[1].data();

      final int sysTos = sysData?['latest_tos_version'] ?? 1;
      final int sysPrivacy = sysData?['latest_privacy_version'] ?? 1;

      final int userTos = userData?['agreed_tos_version'] ?? 0;
      final int userPrivacy = userData?['agreed_privacy_version'] ?? 0;

      final bool tosOutdated = userTos < sysTos;
      final bool privacyOutdated = userPrivacy < sysPrivacy;

      if (tosOutdated && privacyOutdated) {
        _type = UpdateType.both;
        _currentTab = LegalTab.terms; // 兩個都有時，預設先看 Terms
      } else if (tosOutdated) {
        _type = UpdateType.tosOnly;
        _currentTab = LegalTab.terms;
      } else if (privacyOutdated) {
        _type = UpdateType.privacyOnly;
        _currentTab = LegalTab.privacy;
      } else {
        _type = UpdateType.none;
      }
    } catch (e) {
      debugPrint("S72 check failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 切換 Tab
  void setTab(LegalTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  /// 同意並繼續
  Future<void> agreeLatestTerms({required VoidCallback onSuccess}) async {
    if (_isAgreed) return;

    _isAgreed = true;
    notifyListeners();

    try {
      await _repo.acceptLegalTerms();
      onSuccess();
    } catch (e) {
      debugPrint("Agree failed: $e");
      _isAgreed = false;
      notifyListeners();
    }
  }
}
