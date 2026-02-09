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
}
