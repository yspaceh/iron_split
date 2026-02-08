import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';

class DualAmount {
  /// 原始幣別金額 (例如: 支付時的 JPY)
  final double original;

  /// 本位幣金額 (例如: 群組的 TWD)
  final double base;

  const DualAmount({
    required this.original,
    required this.base,
  });

  // --- 1. 便捷建構子 ---

  /// 建立一個「零」金額物件
  static const DualAmount zero = DualAmount(original: 0, base: 0);

  /// 當原幣 = 本幣時 (沒有匯差)
  factory DualAmount.same(double amount) {
    return DualAmount(original: amount, base: amount);
  }

  /// 透過匯率建立 (自動計算本幣)
  factory DualAmount.fromRate({
    required double original,
    required double exchangeRate,
    required CurrencyConstants currencyConstants,
  }) {
    return DualAmount(
      original: original,
      base: BalanceCalculator.floorToPrecision(
          original * exchangeRate, currencyConstants),
    );
  }

  // --- 2. 實用 Getter ---

  /// 反推隱含匯率 (Base / Original)
  /// 如果 original 為 0，回傳 0 (避免除以零錯誤)
  double get impliedRate => original == 0 ? 0.0 : base / original;

  // --- 3. 運算子重載 (讓程式碼更簡潔) ---

  /// 加法：兩個 DualAmount 相加
  DualAmount operator +(DualAmount other) {
    return DualAmount(
      original: original + other.original,
      base: base + other.base,
    );
  }

  /// 減法：兩個 DualAmount 相減
  DualAmount operator -(DualAmount other) {
    return DualAmount(
      original: original - other.original,
      base: base - other.base,
    );
  }

  /// 乘法：例如「均分給 3 人」，直接乘上 (1/3)
  DualAmount operator *(double factor) {
    return DualAmount(
      original: original * factor,
      base: base * factor,
    );
  }

  /// 除法
  DualAmount operator /(double divisor) {
    if (divisor == 0) return DualAmount.zero;
    return DualAmount(
      original: original / divisor,
      base: base / divisor,
    );
  }

  // --- 4. 比較與顯示 ---

  @override
  String toString() => 'DualAmount(original: $original, base: $base)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DualAmount &&
        other.original == original &&
        other.base == base;
  }

  @override
  int get hashCode => original.hashCode ^ base.hashCode;
}
