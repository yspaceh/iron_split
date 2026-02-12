// error_mapper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/gen/strings.g.dart';

class ErrorMapper {
  // error_mapper.dart

  static AppErrorCodes parseErrorCode(dynamic error) {
    if (error == null) return AppErrorCodes.unknown;
    if (error is AppErrorCodes) return error;

    // ✅ 1. 完整還原並保留您提供的 Firebase 核心錯誤映射
    if (error is FirebaseException) {
      switch (error.code.toLowerCase()) {
        case 'permission-denied':
          return AppErrorCodes.permissionDenied;
        case 'not-found':
          return AppErrorCodes.dataNotFound; // 統一對應到 dataNotFound
        case 'resource-exhausted':
          return AppErrorCodes.quotaExceeded;
        case 'unavailable':
          return AppErrorCodes.unavailable;
        case 'deadline-exceeded':
          return AppErrorCodes.timeout;
        case 'unauthenticated':
          return AppErrorCodes.unauthorized;
      }
    }

    String eStr = error.toString().toUpperCase();

    // 1. 識別匯率相關錯誤
    if (eStr.contains('RATE') ||
        eStr.contains('EXCHANGE') ||
        eStr.contains('CURRENCY')) {
      return AppErrorCodes.rateFetchFailed;
    }

    if (eStr.contains('CLOSE_TASK')) return AppErrorCodes.taskCloseFailed;

    // 2. 動作關鍵字識別 (是什麼動作掛掉)
    // 當 Firebase 噴出一個 generic error 時，我們靠這些關鍵字轉譯
    if (eStr.contains('SAVE') ||
        eStr.contains('UPDATE') ||
        eStr.contains('CREATE')) {
      return AppErrorCodes.saveFailed;
    }
    if (eStr.contains('DELETE') || eStr.contains('REMOVE')) {
      return AppErrorCodes.deleteFailed;
    }

    // 2. 網路與連線類 (補強 Firebase 外的網路報錯)
    if (eStr.contains('NETWORK') || eStr.contains('CONNECTION')) {
      return AppErrorCodes.networkError;
    }

    // 3. 邀請相關關鍵字
    if (eStr.contains("TASK_FULL")) return AppErrorCodes.inviteTaskFull;
    if (eStr.contains("EXPIRED")) return AppErrorCodes.inviteExpired;
    if (eStr.contains("INVALID")) return AppErrorCodes.inviteInvalid;

    // 4. 業務與初始化收斂
    if (eStr.contains('INCOME_IS_USED')) return AppErrorCodes.incomeIsUsed;
    if (eStr.contains('TASK_LOCKED')) return AppErrorCodes.taskLocked;
    if (eStr.contains('INIT') ||
        eStr.contains('LOAD') ||
        eStr.contains('SPLIT')) {
      return AppErrorCodes.initFailed;
    }

    return AppErrorCodes.unknown;
  }

  static String map(BuildContext context,
      {AppErrorCodes? code, dynamic error}) {
    final t = Translations.of(context);
    final finalCode = code ?? parseErrorCode(error);

    switch (finalCode) {
      case AppErrorCodes.unauthorized:
        return t.error.message.unauthorized;
      case AppErrorCodes.permissionDenied:
        return t.error.message.permission_denied;
      case AppErrorCodes.dataNotFound:
        return t.error.message.data_not_found;
      case AppErrorCodes.initFailed:
        return t.error.message.init_failed;
      case AppErrorCodes.rateFetchFailed:
        return t.error.message.rate_fetch_failed;
      case AppErrorCodes.saveFailed:
        return t.error.message.save_failed;
      case AppErrorCodes.deleteFailed:
        return t.error.message.delete_failed;
      case AppErrorCodes.taskCloseFailed:
        return t.error.message.task_close_failed;

      // ✅ 這些精確錯誤即便對應到同一行文字，也能確保邏輯層級是分開的
      case AppErrorCodes.quotaExceeded:
      case AppErrorCodes.unavailable:
        return t.error.message.network_error; // 顯示為「伺服器連線問題」
      case AppErrorCodes.timeout:
        return t.error.message.timeout; // 顯示為「回應逾時，請重試」
      case AppErrorCodes.networkError:
        return t.error.message.network_error; // 顯示為「網路連線失敗」

      case AppErrorCodes.incomeIsUsed:
        return t.error.message.income_is_used;
      case AppErrorCodes.taskLocked:
        return t.error.message.task_locked;

      // 邀請流程
      case AppErrorCodes.inviteTaskFull:
        return t.error.dialog.task_full.message(limit: '15');
      case AppErrorCodes.inviteExpired:
        return t.error.dialog.expired_code.message(minutes: '30');
      case AppErrorCodes.inviteInvalid:
        return t.error.dialog.invalid_code.message;
      case AppErrorCodes.joinFailed:
        return t.error.message.join_failed;
      case AppErrorCodes.inviteCreateFailed:
        return t.error.message.invite_create_failed;

      case AppErrorCodes.nameLengthExceeded:
        return t.error.message.length_exceeded(max: 10);
      case AppErrorCodes.invalidChar:
        return t.error.message.invalid_char;
      case AppErrorCodes.fieldRequired:
        return t.error.message.required;
      case AppErrorCodes.dataConflict:
        return t.error.message.data_conflict;
      case AppErrorCodes.taskStatusError:
        return t.error.message.task_status_error;
      case AppErrorCodes.settlementFailed:
        return t.error.message.settlement_failed;
      case AppErrorCodes.exportFailed:
        return t.error.message.export_failed;

      case AppErrorCodes.unknown:
      default:
        // ✅ 保留偵錯模式：若無定義，則顯示原始字串 (Exception: xxx)
        String eStr = error?.toString() ?? "";
        if (eStr.startsWith("Exception: ")) {
          eStr = eStr.replaceFirst("Exception: ", "");
        }
        return eStr.isNotEmpty ? eStr : t.error.message.unknown;
    }
  }
}
