// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'S.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get error_TASK_FULL_title => '名額已滿';

  @override
  String error_TASK_FULL_message(int limit) {
    return '此任務已達 $limit 人上限，請私訊隊長協助。';
  }

  @override
  String get error_EXPIRED_CODE_title => '邀請碼已過期';

  @override
  String error_EXPIRED_CODE_message(int minutes) {
    return '邀請連結已失效（有效時間 $minutes 分鐘），請向隊長索取新連結。';
  }

  @override
  String get error_INVALID_CODE_title => '邀請碼無效';

  @override
  String get error_INVALID_CODE_message => '無效的邀請連結，請確認連結是否正確或已遭刪除。';

  @override
  String get error_AUTH_REQUIRED_title => '需要登入';

  @override
  String get error_AUTH_REQUIRED_message => '請先完成匿名登入以加入任務。';

  @override
  String get error_UNKNOWN_title => '發生錯誤';

  @override
  String error_UNKNOWN_message(string code) {
    return '請再試一次，或聯絡隊長協助。代碼：$code';
  }

  @override
  String get action_confirm => '確認';

  @override
  String get action_retry => '重試';

  @override
  String get action_back_home => '回首頁';

  @override
  String get p7_invite_subtitle => '您受邀加入以下任務';
}
