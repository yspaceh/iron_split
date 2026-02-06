import 'package:iron_split/gen/strings.g.dart';
import 'app_error.dart';

class ErrorTranslator {
  // 對齊 Firebase Functions 錯誤碼與 AppErrorType
  static AppErrorType mapBackendCode(String code) {
    switch (code) {
      case 'already-exists':
        return AppErrorType.alreadyInTask;
      case 'failed-precondition':
        return AppErrorType.taskFull;
      case 'deadline-exceeded':
        return AppErrorType.expiredCode;
      case 'unauthenticated':
        return AppErrorType.authRequired;
      case 'not-found':
        return AppErrorType.invalidCode;
      default:
        return AppErrorType.unknown;
    }
  }

  static String getTitle(AppErrorType type) {
    switch (type) {
      case AppErrorType.alreadyInTask:
        return t.error.dialog.already_in_task.title;
      case AppErrorType.taskFull:
        return t.error.dialog.task_full.title;
      case AppErrorType.expiredCode:
        return t.error.dialog.expired_code.title;
      case AppErrorType.invalidCode:
        return t.error.dialog.invalid_code.title;
      case AppErrorType.authRequired:
        return t.error.dialog.auth_required.title;
      case AppErrorType.unknown:
        return t.error.dialog.unknown.title;
    }
  }

  static String getMessage(AppErrorType type, {Map<String, dynamic>? meta}) {
    switch (type) {
      case AppErrorType.alreadyInTask:
        return t.error.dialog.already_in_task.message;
      case AppErrorType.taskFull:
        return t.error.dialog.task_full
            .message(limit: meta?['limit']?.toString() ?? '15');
      case AppErrorType.expiredCode:
        return t.error.dialog.expired_code
            .message(minutes: meta?['minutes']?.toString() ?? '30');
      case AppErrorType.unknown:
        return t.error.dialog.unknown.message;
      case AppErrorType.invalidCode:
        return t.error.dialog.invalid_code.message;
      case AppErrorType.authRequired:
        return t.error.dialog.auth_required.message;
    }
  }
}
