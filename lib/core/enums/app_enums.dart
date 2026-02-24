enum LoadStatus { initial, loading, success, error }

enum UpdateType {
  none,
  tosOnly, // 只有條款更新
  privacyOnly, // 只有隱私更新
  both, // 兩個都更新
}

// 用於 CustomSlidingSegment 的 Key
enum LegalTab { terms, privacy }

enum TaskStatus { ongoing, pending, settled, closed }

enum BootstrapDestination {
  onboarding, // 去 S50 (同意條款)
  setupName, // 去 S51 (取名)
  confirmInvite, // 去 S11 (確認邀請)
  home, // 去 S10 (首頁)
  updateTerms, // 去 S72 (更新條款)
}

enum PayerType {
  member('member'), // 成員代墊 (單一或複數)
  prepay('prepay'), // 完全使用公款
  mixed('mixed'); // 混合付款 (公款 + 成員代墊)

  final String code;
  const PayerType(this.code);

  // 從資料庫字串轉回 Enum 的 Helper
  static PayerType fromCode(String? code) {
    return PayerType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => PayerType.prepay, // 預設防呆值
    );
  }
}

enum RecordType {
  prepay('prepay'),
  expense('expense');

  final String code;
  const RecordType(this.code);

  // 從資料庫字串轉回 Enum 的 Helper
  static RecordType fromCode(String? code) {
    return RecordType.values.firstWhere(
      (e) => e.code == code,
      orElse: () => RecordType.expense, // 預設防呆值
    );
  }
}
