import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';

class BrightnessService {
  static const platform = MethodChannel('com.ironsplit/brightness');
  static double? _originalBrightness;

  /// 調到最亮 (1.0)
  static Future<void> setMaxBrightness() async {
    try {
      if (Platform.isIOS) {
        // iOS: 調亮前，先向原生端取得當前亮度並存起來
        _originalBrightness =
            await platform.invokeMethod<double>('getBrightness');
      }
      await platform.invokeMethod('setBrightness', {'brightness': 1.0});
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason:
            'BrightnessService - setMaxBrightness: Failed to set max brightness',
      );
    }
  }

  /// 恢復原本亮度
  static Future<void> restoreBrightness() async {
    try {
      if (Platform.isAndroid) {
        // Android: 傳入 -1.0 交給系統自動恢復
        await platform.invokeMethod('setBrightness', {'brightness': -1.0});
      } else if (Platform.isIOS && _originalBrightness != null) {
        // iOS: 把剛剛記住的亮度設定回去
        await platform
            .invokeMethod('setBrightness', {'brightness': _originalBrightness});
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason:
            'BrightnessService - restoreBrightness: Failed to restore brightness',
      );
    }
  }
}
