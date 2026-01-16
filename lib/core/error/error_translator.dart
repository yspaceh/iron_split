import 'package:iron_split/gen/strings.g.dart';
import 'app_error.dart';

class ErrorTranslator {
  // 對齊 Firebase Functions 錯誤碼與 AppErrorType
  static AppErrorType mapBackendCode(String code) {
    switch (code) {
      case 'already-exists': return AppErrorType.alreadyInTask;
      case 'failed-precondition': return AppErrorType.taskFull;
      case 'deadline-exceeded': return AppErrorType.expiredCode;
      case 'unauthenticated': return AppErrorType.authRequired;
      case 'not-found': return AppErrorType.invalidCode;
      default: return AppErrorType.unknown;
    }
  }

  static String getTitle(AppErrorType type) {
    switch (type) {
      case AppErrorType.alreadyInTask: return t.error.alreadyInTask.title;
      case AppErrorType.taskFull: return t.error.taskFull.title;
      case AppErrorType.expiredCode: return t.error.expiredCode.title;
      case AppErrorType.invalidCode: return t.error.invalidCode.title;
      case AppErrorType.authRequired: return t.error.authRequired.title;
      case AppErrorType.unknown: return t.error.unknown.title;
    }
  }

  static String getMessage(AppErrorType type, {Map<String, dynamic>? meta}) {
    switch (type) {
      case AppErrorType.alreadyInTask:
        return t.error.alreadyInTask.message;
      case AppErrorType.taskFull: 
        return t.error.taskFull.message(limit: meta?['limit']?.toString() ?? '15');
      case AppErrorType.expiredCode:
        return t.error.expiredCode.message(minutes: meta?['minutes']?.toString() ?? '30');
      case AppErrorType.unknown:
        return t.error.unknown.message;
      case AppErrorType.invalidCode:
        return t.error.invalidCode.message;
      case AppErrorType.authRequired:
        return t.error.authRequired.message;
    }
  }
}