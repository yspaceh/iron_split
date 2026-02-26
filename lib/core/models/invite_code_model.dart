class InviteCodeDetail {
  final String code;
  final DateTime expiresAt;

  InviteCodeDetail({
    required this.code,
    required this.expiresAt,
  });

  // 直接在這裡把後端的 Milliseconds 轉成 Flutter 認識的 DateTime
  factory InviteCodeDetail.fromMap(Map<String, dynamic> map) {
    return InviteCodeDetail(
      code: map['code'] as String,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] as int),
    );
  }
}
