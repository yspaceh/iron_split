enum LoadStatus { initial, loading, success, error }

enum UpdateType {
  none,
  tosOnly, // 只有條款更新
  privacyOnly, // 只有隱私更新
  both, // 兩個都更新
}

// 用於 CustomSlidingSegment 的 Key
enum LegalTab { terms, privacy }

enum BootstrapDestination {
  onboarding, // 去 S50 (同意條款)
  setupName, // 去 S51 (取名)
  confirmInvite, // 去 S11 (確認邀請)
  home, // 去 S10 (首頁)
  updateTerms, // 去 S72 (更新條款)
}
