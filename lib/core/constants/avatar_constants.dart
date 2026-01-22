class AvatarConstants {
  // 原始完整 ID 列表 (供選擇器使用)
  static const List<String> allAvatars = [
    '01_cow',
    '02_pig',
    '03_deer',
    '04_horse',
    '05_sheep',
    '06_goat',
    '07_duck',
    '08_stoat',
    '09_rabbit',
    '10_mouse',
    '11_cat',
    '12_dog',
    '13_otter',
    '14_owl',
    '15_fox',
    '16_hedgehog',
    '17_donkey',
    '18_squirrel',
    '19_badger',
    '20_robin',
  ];

  // 簡寫對照表 (供舊資料修正使用)
  // 如果資料庫只存了 "badger"，這裡可以幫忙對應回 "19_badger"
  static const Map<String, String> _shortNameMap = {
    'cow': '01_cow',
    'pig': '02_pig',
    'deer': '03_deer',
    'horse': '04_horse',
    'sheep': '05_sheep',
    'goat': '06_goat',
    'duck': '07_duck',
    'stoat': '08_stoat',
    'rabbit': '09_rabbit',
    'mouse': '10_mouse',
    'cat': '11_cat',
    'dog': '12_dog',
    'otter': '13_otter',
    'owl': '14_owl',
    'fox': '15_fox',
    'hedgehog': '16_hedgehog',
    'donkey': '17_donkey',
    'squirrel': '18_squirrel',
    'badger': '19_badger',
    'robin': '20_robin',
  };

  /// 傳入 ID (可能是 "19_badger" 也可能是 "badger")
  /// 回傳完整的 Asset 路徑
  static String getAssetPath(String? id) {
    if (id == null || id.isEmpty) return '';

    // 1. 先嘗試從簡寫表找 (e.g. "badger" -> "19_badger")
    String fullId = _shortNameMap[id] ?? id;

    // 2. 如果傳進來的已經是 fullId (e.g. "19_badger")，上面的 map 會回傳 null??id -> 也就是原值
    // 但為了保險，如果傳入 "19_badger"，map 找不到，我們就直接用它

    // 3. 組合路徑
    return 'assets/images/avatars/avatar_$fullId.png';
  }
}
