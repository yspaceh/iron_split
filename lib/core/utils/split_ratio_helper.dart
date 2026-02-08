class SplitRatioHelper {
  // 集中管理常數，以後要改範圍或步進，改這裡就好，全 App 生效
  static const double min = 0.0;
  static const double max = 2.0;
  static const double step = 0.5;

  /// 計算增加後的數值
  static double increase(double current) {
    final newValue = current + step;
    return newValue.clamp(min, max);
  }

  /// 計算減少後的數值
  static double decrease(double current) {
    final newValue = current - step;
    return newValue.clamp(min, max);
  }

  /// 統一的顯示格式 (例如 "1.0x")
  static String format(double value) {
    return "${value.toStringAsFixed(1)}x";
  }
}
