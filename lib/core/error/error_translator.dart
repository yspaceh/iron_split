// lib/utils/error_translator.dart
import 'package:flutter/material.dart';
import '../generated/l10n.dart'; // 引用生成的翻譯類別
import '../core/error/app_error.dart';

class ErrorTranslator {
  /// 第一段：邏輯映射 (與 BuildContext 無關，方便單元測試)
  static AppErrorType mapBackendCode(String code) {
    switch (code) {
      case 'TASK_FULL': return AppErrorType.taskFull;
      case 'EXPIRED_CODE': return AppErrorType.expiredCode;
      case 'INVALID_CODE': return AppErrorType.invalidCode;
      case 'AUTH_REQUIRED': return AppErrorType.authRequired;
      default: return AppErrorType.unknown;
    }
  }

  /// 第二段：UI 渲染 (根據 Context 與參數回傳在地化文字)
  static String getTitle(AppErrorType type, BuildContext context) {
    final s = S.of(context);
    switch (type) {
      case AppErrorType.taskFull: return s.error_TASK_FULL_title;
      case AppErrorType.expiredCode: return s.error_EXPIRED_CODE_title;
      case AppErrorType.invalidCode: return s.error_INVALID_CODE_title;
      case AppErrorType.authRequired: return s.error_AUTH_REQUIRED_title;
      case AppErrorType.unknown: return s.error_UNKNOWN_title;
    }
  }

  static String getMessage(AppErrorType type, BuildContext context, {Map<String, dynamic>? meta}) {
    final s = S.of(context);
    switch (type) {
      case AppErrorType.taskFull:
        return s.error_TASK_FULL_message(meta?['limit'] ?? 15); // 使用 Placeholder
      case AppErrorType.expiredCode:
        return s.error_EXPIRED_CODE_message(meta?['minutes'] ?? 15);
      case AppErrorType.invalidCode:
        return s.error_INVALID_CODE_message;
      case AppErrorType.authRequired:
        return s.error_AUTH_REQUIRED_message;
      case AppErrorType.unknown:
        return s.error_UNKNOWN_message(meta?['code'] ?? 'N/A');
    }
  }
}