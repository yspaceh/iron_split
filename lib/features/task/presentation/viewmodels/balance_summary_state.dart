import 'package:equatable/equatable.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';

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
  }) {
    return DualAmount(
      original: original,
      base: original * exchangeRate,
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

/// [ViewModel State]
/// 這是 BalanceCard 唯一認識的資料結構。
/// 它不包含任何計算邏輯，只包含顯示所需的數值與旗標。
class BalanceSummaryState extends Equatable {
  // 1. 基礎幣別資訊
  final String currencyCode; // e.g. "TWD"
  final String currencySymbol; // e.g. "$"

  // 2. 核心金額 (原始數值，UI 負責格式化)
  final double poolBalance; // 公款餘額 (大字)
  final double totalExpense; // 總支出 (紅點)
  final double totalIncome; // 總預收 (綠點)
  final double remainder; // 餘額罐

  // 3. 圖表比例 (0~1000) - Service 已經算好，UI 直接用
  final int expenseFlex;
  final int incomeFlex;

  // 4. UI 狀態旗標
  final String ruleKey; // 'random', 'order', 'member' (UI 負責翻譯)
  final bool isLocked; // 是否鎖定 (決定顯示箭頭/隱藏部分資訊)

  // 5. 彈窗所需的明細資料 (Map<幣別代碼, 金額>)
  final Map<String, double> expenseDetail;
  final Map<String, double> incomeDetail;
  final Map<String, double> poolDetail;

  // 6. 鎖定模式專用資訊 (S17)
  final String? absorbedBy; // 吸收餘額的人名
  final double? absorbedAmount; // 被吸收的金額

  const BalanceSummaryState({
    required this.currencyCode,
    required this.currencySymbol,
    required this.poolBalance,
    required this.totalExpense,
    required this.totalIncome,
    required this.remainder,
    required this.expenseFlex,
    required this.incomeFlex,
    required this.ruleKey,
    required this.isLocked,
    required this.expenseDetail,
    required this.incomeDetail,
    required this.poolDetail,
    this.absorbedBy,
    this.absorbedAmount,
  });

  // 初始空狀態 (避免 UI null check)
  factory BalanceSummaryState.initial() {
    return const BalanceSummaryState(
      currencyCode: CurrencyConstants.defaultCode,
      currencySymbol: CurrencyConstants.defaultSymbol,
      poolBalance: 0,
      totalExpense: 0,
      totalIncome: 0,
      remainder: 0,
      expenseFlex: 0,
      incomeFlex: 0,
      ruleKey: RemainderRuleConstants.defaultRule,
      isLocked: false,
      expenseDetail: {},
      incomeDetail: {},
      poolDetail: {},
    );
  }

  BalanceSummaryState copyWith({
    String? currencyCode,
    String? currencySymbol,
    double? poolBalance,
    double? totalExpense,
    double? totalIncome,
    double? remainder,
    int? expenseFlex,
    int? incomeFlex,
    String? ruleKey,
    bool? isLocked,
    Map<String, double>? expenseDetail,
    Map<String, double>? incomeDetail,
    Map<String, double>? poolDetail,
    String? absorbedBy,
    double? absorbedAmount,
  }) {
    return BalanceSummaryState(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      poolBalance: poolBalance ?? this.poolBalance,
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      remainder: remainder ?? this.remainder,
      expenseFlex: expenseFlex ?? this.expenseFlex,
      incomeFlex: incomeFlex ?? this.incomeFlex,
      ruleKey: ruleKey ?? this.ruleKey,
      isLocked: isLocked ?? this.isLocked,
      expenseDetail: expenseDetail ?? this.expenseDetail,
      incomeDetail: incomeDetail ?? this.incomeDetail,
      poolDetail: poolDetail ?? this.poolDetail,
      absorbedBy: absorbedBy ?? this.absorbedBy,
      absorbedAmount: absorbedAmount ?? this.absorbedAmount,
    );
  }

  // [新增] 2. toMap: 轉成 JSON 存入 Firestore
  Map<String, dynamic> toMap() {
    return {
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'poolBalance': poolBalance,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
      'remainder': remainder,
      'expenseFlex': expenseFlex,
      'incomeFlex': incomeFlex,
      'ruleKey': ruleKey,
      'isLocked': isLocked,
      'expenseDetail': expenseDetail,
      'incomeDetail': incomeDetail,
      'poolDetail': poolDetail,
      'absorbedBy': absorbedBy,
      'absorbedAmount': absorbedAmount,
    };
  }

  // [新增] 3. fromMap: 從 Firestore 讀回物件
  factory BalanceSummaryState.fromMap(Map<String, dynamic> map) {
    // Helper to safely parse double from Firestore (can be int or double)
    double toDouble(dynamic val) => (val as num?)?.toDouble() ?? 0.0;

    // Helper to parse Map<String, double>
    Map<String, double> toMapDouble(dynamic val) {
      if (val == null) return {};
      return Map<String, dynamic>.from(val).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      );
    }

    return BalanceSummaryState(
      currencyCode: map['currencyCode'] ?? CurrencyConstants.defaultCode,
      currencySymbol: map['currencySymbol'] ?? CurrencyConstants.defaultSymbol,
      poolBalance: toDouble(map['poolBalance']),
      totalExpense: toDouble(map['totalExpense']),
      totalIncome: toDouble(map['totalIncome']),
      remainder: toDouble(map['remainder']),
      expenseFlex: map['expenseFlex'] as int? ?? 0,
      incomeFlex: map['incomeFlex'] as int? ?? 0,
      ruleKey: map['ruleKey'] ?? '',
      isLocked: map['isLocked'] ?? false,
      expenseDetail: toMapDouble(map['expenseDetail']),
      incomeDetail: toMapDouble(map['incomeDetail']),
      poolDetail: toMapDouble(map['poolDetail']),
      absorbedBy: map['absorbedBy'] as String?,
      absorbedAmount: (map['absorbedAmount'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        currencyCode,
        poolBalance,
        totalExpense,
        totalIncome,
        remainder,
        expenseFlex,
        incomeFlex,
        ruleKey,
        isLocked,
        expenseDetail,
        incomeDetail,
        poolDetail,
        absorbedBy,
        absorbedAmount,
      ];
}
