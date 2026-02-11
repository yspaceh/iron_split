class MemberService {
  /// 產生標準的幽靈成員資料
  static Map<String, dynamic> createGhost({
    required String displayName,
  }) {
    return {
      'uid': null, // 幽靈成員沒有 UID
      'displayName': displayName,
      'avatar': null,
      'role': 'member',
      'isLinked': false,
      'hasSeenRoleIntro': false, // 確保源頭就是 false
      'prepaid': 0.0,
      'expense': 0.0,
      'joinedAt': null,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// 統一 ID 產生規則
  static String generateVirtualId() {
    return 'virtual_${DateTime.now().microsecondsSinceEpoch}';
  }
}
