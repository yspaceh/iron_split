// lib/core/base/base_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
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
    } on FirebaseException catch (e, stackTrace) {
      // 這裡可以過濾掉一些您認為「不需要紀錄的常態錯誤」
      // 例如：網路斷線 (unavailable) 或權限不足 (permission-denied)
      if (e.code != 'unavailable' && e.code != 'permission-denied') {
        FirebaseCrashlytics.instance.recordError(
          e,
          stackTrace,
          reason: 'Firestore 操作失敗 (safeRun)',
        );
      }
      throw ErrorMapper.parseErrorCode(e);
    } catch (e, stackTrace) {
      // 1. 先問 ErrorMapper 這是不是已知的底層錯誤 (如：沒權限、沒網路、額度滿了)
      final systemCode = ErrorMapper.parseErrorCode(e);

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: '未知的 Repository 錯誤 (safeRun)',
      );

      // 2. 如果是明確的系統/環境錯誤，直接往上拋 (保留精確原因，讓 UI 顯示「網路錯誤」而非「儲存失敗」)
      if (systemCode != AppErrorCodes.unknown) {
        throw systemCode;
      }

      // 3. 如果是未知錯誤，則拋出我們指定的「動作上下文」
      // 這樣 VM 層接到 deleteFailed，就能顯示「刪除失敗」，而不是 generic 的 unknown
      throw fallbackError;
    }
  }
}
