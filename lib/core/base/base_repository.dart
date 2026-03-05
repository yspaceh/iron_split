// lib/core/base/base_repository.dart

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';

/// 所有 Repository 的基類
/// 負責統一處理底層 Exception 並轉換為 AppErrorCodes
abstract class BaseRepository {
  /// 通用錯誤攔截器
  /// [action]: 實際執行的資料庫動作
  /// [fallbackError]: 當發生未知錯誤時，賦予的「動作上下文」(如 saveFailed, deleteFailed)
  Future<T> safeRun<T>(
      Future<T> Function() action, AppErrorCodes fallbackError) async {
    try {
      return await action();
    } on AppErrorCodes {
      // 如果錯誤已經是 AppErrorCodes (例如：餘額不足、群組已滿)，
      // 代表這是我們主動拋出的業務邏輯阻擋。
      // 它不是系統崩潰，所以「不要」送交 Crashlytics，直接往上拋給 UI 處理即可。
      rethrow;
    } catch (e, stackTrace) {
      // 1. 先讓 ErrorMapper 試著解析這個錯誤
      final mappedError = ErrorMapper.parseErrorCode(e);

      // 2. 如果解析出來不是 unknown，代表這是我們預期的業務錯誤 (如權限不足、房間已滿)
      if (mappedError != AppErrorCodes.unknown) {
        throw mappedError;
      }

      // 3. 真的完全不認識的例外，才視為系統崩潰送 Crashlytics，並拋出 defaultError
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
      throw fallbackError;
    }
  }
}
