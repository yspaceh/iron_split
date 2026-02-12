import 'package:cloud_firestore/cloud_firestore.dart'; // [新增]
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iron_split/core/base/base_repository.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';

class AuthRepository extends BaseRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // [新增]

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  /// 匿名登入
  Future<User> signInAnonymously() async {
    return await safeRun(() async {
      final cred = await _firebaseAuth.signInAnonymously();
      return cred.user!;
    }, AppErrorCodes.initFailed);
  }

  /// 同意最新條款 (寫入 User Profile)
  Future<void> acceptLegalTerms() async {
    await safeRun(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 1. 讀取系統目前的最新版本
      final configDoc =
          await _firestore.collection('config').doc('legal').get();
      final data = configDoc.data();

      // 如果資料庫還沒設定，預設為 1
      final int sysTos = data?['latest_tos_version'] ?? 1;
      final int sysPrivacy = data?['latest_privacy_version'] ?? 1;

      // 2. 寫入使用者紀錄
      await _firestore.collection('users').doc(user.uid).set({
        'agreed_tos_version': sysTos,
        'agreed_privacy_version': sysPrivacy,
        'agreed_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // merge: true 避免覆蓋其他欄位
    }, AppErrorCodes.saveFailed);
  }

  Future<void> updateDisplayName(String name) async {
    await safeRun(() async {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload();
      } else {
        throw AppErrorCodes.unauthorized;
      }
    }, AppErrorCodes.saveFailed);
  }

  /// 檢查使用者的條款版本是否過期
  /// 回傳 true 代表通過 (Pass)，false 代表需要更新 (Fail)
  Future<bool> isTermsValid() async {
    return await safeRun(() async {
      final user = _firebaseAuth.currentUser;
      if (user == null) return false;

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

      // 只要有一個過期，就回傳 false
      if (userTos < sysTos || userPrivacy < sysPrivacy) {
        return false;
      }
      return true; // 全部通過
    }, AppErrorCodes.initFailed);
  }
}
