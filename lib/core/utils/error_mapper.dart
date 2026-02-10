import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 引入以支援 FirebaseException
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/gen/strings.g.dart';

class ErrorMapper {
  static String map(BuildContext context, dynamic error) {
    final t = Translations.of(context);
    String eStr = error.toString();

    //  優先處理 FirebaseException，取出 code
    if (error is FirebaseException) {
      eStr = error.code;
    }

    // --- [新增] 邀請流程錯誤處理 ---
    if (eStr.contains(AppErrorCodes.inviteTaskFull) ||
        eStr.contains('failed-precondition')) {
      return t.error.dialog.task_full.message(limit: '15'); // 假設有此翻譯 key
    }
    if (eStr.contains(AppErrorCodes.inviteExpired) ||
        eStr.contains('deadline-exceeded')) {
      return t.error.dialog.expired_code.message(minutes: '30');
    }
    if (eStr.contains(AppErrorCodes.inviteInvalid) ||
        eStr.contains('not-found')) {
      return t.error.dialog.invalid_code.message;
    }
    if (eStr.contains(AppErrorCodes.inviteAlreadyJoined) ||
        eStr.contains('already-exists')) {
      return t.error.dialog.already_in_task.message;
    }
    if (eStr.contains(AppErrorCodes.inviteAuthRequired) ||
        eStr.contains('unauthenticated')) {
      return t.error.dialog.auth_required.message;
    }

    // 1. 邏輯阻擋類
    if (eStr.contains(AppErrorCodes.incomeIsUsed)) {
      return t.error.message.income_is_used;
    }

    // 2. 資料同步類
    if (eStr.contains(AppErrorCodes.recordNotFound)) {
      return t.error.message.data_not_found;
    }
    if (eStr.contains(AppErrorCodes.taskNotFound)) {
      return t.error.message.data_not_found;
    }

    // 載入失敗類
    if (eStr.contains(AppErrorCodes.taskLoadFailed)) {
      return t.error.message.load_failed; // "載入失敗"
    }

    // 儲存與刪除
    if (eStr.contains(AppErrorCodes.saveFailed)) {
      return t.error.message.save_failed; // "儲存失敗，請稍後再試"
    }
    if (eStr.contains(AppErrorCodes.deleteFailed)) {
      return t.error.message.delete_failed; // "刪除失敗，請稍後再試"
    }
    if (eStr.contains(AppErrorCodes.rateFetchFailed)) {
      return t.error.message.rate_fetch_failed; // "匯率更新失敗"
    }

    // 3. 系統/Firebase 類
    if (eStr.contains(AppErrorCodes.permissionDenied)) {
      return t.error.message.permission_denied;
    }

    if (eStr.contains(AppErrorCodes.networkError) ||
        eStr.contains("SocketException") ||
        eStr.contains("unavailable")) {
      return t.error.message.network_error;
    }

    // 4. 清理 Exception 前綴
    if (eStr.startsWith("Exception: ")) {
      return eStr.replaceFirst("Exception: ", "");
    }

    // 5. Fallback
    return "${t.error.message.unknown} ($eStr)";
  }
}
