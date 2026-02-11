// error_mapper.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/gen/strings.g.dart';

class ErrorMapper {
  /// 將後端各種奇怪的 Exception 轉化為標準的 AppErrorCode
  /// 所有的 VM 都可以呼叫這個方法來獲得乾淨的狀態碼
  static String parseErrorCode(dynamic error) {
    if (error == null) return AppErrorCodes.unknown;

    String eStr = error.toString().toUpperCase();
    if (error is FirebaseException) {
      eStr = "${error.code} ${error.message}".toUpperCase();
    }

    // 邀請相關
    // 邀請相關
    if (eStr.contains('TASK_FULL') || eStr.contains('FAILED-PRECONDITION')) {
      return AppErrorCodes.inviteTaskFull;
    }
    if (eStr.contains('EXPIRED') || eStr.contains('DEADLINE-EXCEEDED')) {
      return AppErrorCodes.inviteExpired;
    }

    // [修正] 加入 INVALID-ARGUMENT 和 NOT-FOUND
    if (eStr.contains('INVALID') ||
        eStr.contains('NOT-FOUND') ||
        eStr.contains('INVALID-ARGUMENT')) {
      return AppErrorCodes.inviteInvalid;
    }

    if (eStr.contains('ALREADY') || eStr.contains('ALREADY-EXISTS')) {
      return AppErrorCodes.inviteAlreadyJoined;
    }
    if (eStr.contains('AUTH') || eStr.contains('UNAUTHENTICATED')) {
      return AppErrorCodes.inviteAuthRequired;
    }

    // 其他現存的錯誤 (如果 eStr 已經是標準 Code，就直接回傳)
    if (eStr.contains(AppErrorCodes.incomeIsUsed)) {
      return AppErrorCodes.incomeIsUsed;
    }
    if (eStr.contains(AppErrorCodes.recordNotFound)) {
      return AppErrorCodes.recordNotFound;
    }
    if (eStr.contains(AppErrorCodes.taskNotFound)) {
      return AppErrorCodes.taskNotFound;
    }
    if (eStr.contains(AppErrorCodes.taskLoadFailed)) {
      return AppErrorCodes.taskLoadFailed;
    }
    if (eStr.contains(AppErrorCodes.saveFailed)) {
      return AppErrorCodes.saveFailed;
    }
    if (eStr.contains(AppErrorCodes.deleteFailed)) {
      return AppErrorCodes.deleteFailed;
    }
    if (eStr.contains(AppErrorCodes.rateFetchFailed)) {
      return AppErrorCodes.rateFetchFailed;
    }
    if (eStr.contains(AppErrorCodes.permissionDenied)) {
      return AppErrorCodes.permissionDenied;
    }

    if (eStr.contains(AppErrorCodes.networkError) ||
        eStr.contains("SocketException") ||
        eStr.contains("unavailable")) {
      return AppErrorCodes.networkError;
    }

    return AppErrorCodes.unknown;
  }

  /// 負責將標準 Code 轉成多國語系字串 (UI 顯示用)
  static String map(BuildContext context, dynamic error) {
    final t = Translations.of(context);

    // 先將不管什麼格式的 error，都先洗成標準的 AppErrorCode
    final standardCode = parseErrorCode(error);

    // 現在這裡的判斷變得非常乾淨，不用再去檢查 'failed-precondition' 了
    switch (standardCode) {
      case AppErrorCodes.inviteTaskFull:
        return t.error.dialog.task_full.message(limit: '15');
      case AppErrorCodes.inviteExpired:
        return t.error.dialog.expired_code.message(minutes: '30');
      case AppErrorCodes.inviteInvalid:
        return t.error.dialog.invalid_code.message;
      case AppErrorCodes.inviteAlreadyJoined:
        return t.error.dialog.already_in_task.message;
      case AppErrorCodes.inviteAuthRequired:
        return t.error.dialog.auth_required.message;

      case AppErrorCodes.incomeIsUsed:
        return t.error.message.income_is_used;
      case AppErrorCodes.recordNotFound:
      case AppErrorCodes.taskNotFound:
        return t.error.message.data_not_found;
      case AppErrorCodes.taskLoadFailed:
        return t.error.message.load_failed;
      case AppErrorCodes.saveFailed:
        return t.error.message.save_failed;
      case AppErrorCodes.deleteFailed:
        return t.error.message.delete_failed;
      case AppErrorCodes.rateFetchFailed:
        return t.error.message.rate_fetch_failed;
      case AppErrorCodes.permissionDenied:
        return t.error.message.permission_denied;
      case AppErrorCodes.networkError:
        return t.error.message.network_error;

      default:
        // 清理 Exception 前綴的 Fallback
        String eStr = error.toString();
        if (eStr.startsWith("Exception: ")) {
          return eStr.replaceFirst("Exception: ", "");
        }
        return "${t.error.message.unknown} ($eStr)";
    }
  }
}
