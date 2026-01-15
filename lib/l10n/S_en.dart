// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'S.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get error_TASK_FULL_title => 'Task Full';

  @override
  String error_TASK_FULL_message(int limit) {
    return 'This task has reached its limit of $limit members. Please contact the captain.';
  }

  @override
  String get error_EXPIRED_CODE_title => 'Invite Expired';

  @override
  String error_EXPIRED_CODE_message(int minutes) {
    return 'This invite link has expired (TTL $minutes min). Please request a new one from the captain.';
  }

  @override
  String get error_INVALID_CODE_title => 'Invalid Code';

  @override
  String get error_INVALID_CODE_message =>
      'Invalid invite link. Please check if it\'s correct or has been deleted.';

  @override
  String get error_AUTH_REQUIRED_title => 'Auth Required';

  @override
  String get error_AUTH_REQUIRED_message => 'Please log in to join the task.';

  @override
  String get error_UNKNOWN_title => 'Error Occurred';

  @override
  String error_UNKNOWN_message(string code) {
    return 'Please try again or contact the captain. Code: $code';
  }

  @override
  String get action_confirm => 'Confirm';

  @override
  String get action_retry => 'Retry';

  @override
  String get action_back_home => 'Back to Home';

  @override
  String get p7_invite_subtitle => 'You are invited to join';
}
