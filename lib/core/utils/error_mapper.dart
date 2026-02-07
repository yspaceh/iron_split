import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/app_error_codes.dart'; // [新增]
import 'package:iron_split/gen/strings.g.dart';

class ErrorMapper {
  static String map(BuildContext context, dynamic error) {
    final t = Translations.of(context);
    final eStr = error.toString();

    // 1. 邏輯阻擋類
    if (eStr.contains(AppErrorCodes.incomeIsUsed)) {
      return t.error.message.income_is_used;
    }

    // 2. 資料同步類
    if (eStr.contains(AppErrorCodes.recordNotFound)) {
      // 如果沒有對應的 i18n key，這裡暫時回傳通用錯誤
      return t.error.message.record_not_found;
    }

    // 3. 系統/Firebase 類
    if (eStr.contains(AppErrorCodes.permissionDenied)) {
      return t.error.message.permission_denied;
    }

    // 網路錯誤通常包含多種關鍵字，這裡統一檢查
    if (eStr.contains(AppErrorCodes.networkError) ||
        eStr.contains("SocketException")) {
      return t.error.message.network_error;
    }

    // 4. 清理 Exception 前綴 (讓未知錯誤好看一點)
    if (eStr.startsWith("Exception: ")) {
      return eStr.replaceFirst("Exception: ", "");
    }

    // 5. Fallback
    return "${t.error.message.unknown} ($eStr)";
  }
}
