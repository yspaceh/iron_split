import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:developer' as developer;

class LoggerService {
  LoggerService._();
  static final LoggerService instance = LoggerService._();

  /// 安全地記錄非致命錯誤
  Future<void> recordError(dynamic error, StackTrace stackTrace,
      {String? reason}) async {
    try {
      await FirebaseCrashlytics.instance
          .recordError(error, stackTrace, reason: reason);
    } catch (e) {
      // 測試環境或 Firebase 未初始化時，降級到本地 log。
      developer.log(
        reason ?? 'LoggerService failed to record error',
        error: error,
        stackTrace: stackTrace,
      );
      developer.log('LoggerService internal failure', error: e);
    }
  }
}
