import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// 獲取當前使用者
  User? get currentUser => _firebaseAuth.currentUser;

  /// 更新使用者顯示名稱
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      await user.reload(); // 確保資料同步
    } else {
      throw Exception('No user signed in');
    }
  }
}
