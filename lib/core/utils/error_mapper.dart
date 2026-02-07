import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 引入以支援 FirebaseException
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/gen/strings.g.dart';

class ErrorMapper {
  static String map(BuildContext context, dynamic error) {
    final t = Translations.of(context);
    String eStr = error.toString();

    // [新增] 優先處理 FirebaseException，取出 code
    if (error is FirebaseException) {
      eStr = error.code;
    }

    // 1. 邏輯阻擋類
    if (eStr.contains(AppErrorCodes.incomeIsUsed)) {
      return t.error.message.income_is_used;
    }

    // 2. 資料同步類
    if (eStr.contains(AppErrorCodes.recordNotFound)) {
      return t.error.message.data_not_found; // 需確認 i18n key 是否存在
    }

    // [新增] 載入失敗類
    if (eStr.contains(AppErrorCodes.taskLoadFailed)) {
      return t.error.message.load_failed; // "載入失敗"
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
