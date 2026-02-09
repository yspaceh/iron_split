import 'dart:math';

import 'package:iron_split/gen/strings.g.dart';

class AvatarConstants {
  static const String defaultAvatar = 'cow';
  // 原始完整 ID 列表 (供選擇器使用)
  static const List<String> allAvatars = [
    'cow',
    'pig',
    'deer',
    'horse',
    'sheep',
    'goat',
    'duck',
    'stoat',
    'rabbit',
    'mouse',
    'cat',
    'dog',
    'otter',
    'owl',
    'fox',
    'hedgehog',
    'donkey',
    'squirrel',
    'badger',
    'robin',
  ];

  static String getName(Translations t, String? id) {
    switch (id) {
      case 'cow':
        return t.common.avatar.cow;
      case 'pig':
        return t.common.avatar.pig;
      case 'deer':
        return t.common.avatar.deer;
      case 'horse':
        return t.common.avatar.horse;
      case 'sheep':
        return t.common.avatar.sheep;
      case 'goat':
        return t.common.avatar.goat;
      case 'duck':
        return t.common.avatar.duck;
      case 'stoat':
        return t.common.avatar.stoat;
      case 'rabbit':
        return t.common.avatar.rabbit;
      case 'mouse':
        return t.common.avatar.mouse;
      case 'cat':
        return t.common.avatar.cat;
      case 'dog':
        return t.common.avatar.dog;
      case 'otter':
        return t.common.avatar.otter;
      case 'owl':
        return t.common.avatar.owl;
      case 'fox':
        return t.common.avatar.fox;
      case 'hedgehog':
        return t.common.avatar.hedgehog;
      case 'donkey':
        return t.common.avatar.donkey;
      case 'squirrel':
        return t.common.avatar.squirrel;
      case 'badger':
        return t.common.avatar.badger;
      case 'robin':
        return t.common.avatar.robin;
      default:
        return t.common.avatar.cow;
    }
  }

  /// 傳入 ID
  /// 回傳完整的 Asset 路徑
  static String getAssetPath(String? id) {
    if (id == null || id.isEmpty) return '';
    return 'assets/images/avatars/avatar_$id.png';
  }

  // --- 統一邏輯區域 ---

  /// [S16 專用] 一次產生 N 個不重複頭像
  /// 如果 count > 20，超過的部分會開始重複
  static List<String> generateInitialAvatars(int count) {
    final pool = List<String>.from(allAvatars)..shuffle(); // 洗牌

    if (count <= pool.length) {
      return pool.take(count).toList();
    } else {
      // 如果需要的人數超過動物總數，就重複循環
      List<String> result = [];
      for (int i = 0; i < count; i++) {
        result.add(pool[i % pool.length]);
      }
      return result;
    }
  }

  /// [D01 專用] 從可用池中挑選一個不重複的
  /// [exclude] : 目前 Task 中已經被佔用的頭像清單
  static String pickUniqueAvatar({required Set<String> exclude}) {
    // 找出還沒被用過的
    final available = allAvatars.where((a) => !exclude.contains(a)).toList();

    if (available.isNotEmpty) {
      // 還有剩，隨機選一個
      return available[Random().nextInt(available.length)];
    } else {
      // 全部都用光了 (極端狀況)，只好從全部裡面隨機選一個 (除了自己目前這個以外)
      // 這裡簡單處理：直接從 allAvatars 隨機選，雖然會重複但至少不會當機
      return allAvatars[Random().nextInt(allAvatars.length)];
    }
  }
}
