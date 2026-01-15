// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'S.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get error_TASK_FULL_title => '定員に達しました';

  @override
  String error_TASK_FULL_message(int limit) {
    return 'このタスクは上限の $limit 名に達しています。リーダーに連絡して枠を増やしてもらってください。';
  }

  @override
  String get error_EXPIRED_CODE_title => '期限切れのコード';

  @override
  String error_EXPIRED_CODE_message(int minutes) {
    return '招待コードの期限（$minutes 分）が切れています。リーダーに新しいリンクを依頼してください。';
  }

  @override
  String get error_INVALID_CODE_title => '無効なコード';

  @override
  String get error_INVALID_CODE_message =>
      '無効な招待コードです。リンクが正しいか、または削除されていないか確認してください。';

  @override
  String get error_AUTH_REQUIRED_title => 'ログインが必要';

  @override
  String get error_AUTH_REQUIRED_message => 'タスクに参加するにはログインを完了してください。';

  @override
  String get error_UNKNOWN_title => 'エラーが発生しました';

  @override
  String error_UNKNOWN_message(string code) {
    return 'もう一度試すか、リーダーに連絡してください。コード：$code';
  }

  @override
  String get action_confirm => '確定';

  @override
  String get action_retry => '再試行';

  @override
  String get action_back_home => 'ホームに戻る';

  @override
  String get p7_invite_subtitle => '以下のタスクに招待されました';
}
