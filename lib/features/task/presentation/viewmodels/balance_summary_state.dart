import 'package:equatable/equatable.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';

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
  final double totalPrepay; // 總預收 (綠點)
  final double remainder; // 餘額罐

  // 3. 圖表比例 (0~1000) - Service 已經算好，UI 直接用
  final int expenseFlex;
  final int prepayFlex;

  // 4. UI 狀態旗標
  final String ruleKey; // 'random', 'order', 'member' (UI 負責翻譯)
  final bool isLocked; // 是否鎖定 (決定顯示箭頭/隱藏部分資訊)

  // 5. 彈窗所需的明細資料 (Map<幣別代碼, 金額>)
  final Map<String, double> expenseDetail;
  final Map<String, double> prepayDetail;
  final Map<String, double> poolDetail;

  // 6. 鎖定模式專用資訊 (S17)
  final String? absorbedBy; // 吸收餘額的人名
  final double? absorbedAmount; // 被吸收的金額

  const BalanceSummaryState({
    required this.currencyCode,
    required this.currencySymbol,
    required this.poolBalance,
    required this.totalExpense,
    required this.totalPrepay,
    required this.remainder,
    required this.expenseFlex,
    required this.prepayFlex,
    required this.ruleKey,
    required this.isLocked,
    required this.expenseDetail,
    required this.prepayDetail,
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
      totalPrepay: 0,
      remainder: 0,
      expenseFlex: 0,
      prepayFlex: 0,
      ruleKey: RemainderRuleConstants.defaultRule,
      isLocked: false,
      expenseDetail: {},
      prepayDetail: {},
      poolDetail: {},
    );
  }

  BalanceSummaryState copyWith({
    String? currencyCode,
    String? currencySymbol,
    double? poolBalance,
    double? totalExpense,
    double? totalPrepay,
    double? remainder,
    int? expenseFlex,
    int? prepayFlex,
    String? ruleKey,
    bool? isLocked,
    Map<String, double>? expenseDetail,
    Map<String, double>? prepayDetail,
    Map<String, double>? poolDetail,
    String? absorbedBy,
    double? absorbedAmount,
  }) {
    return BalanceSummaryState(
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      poolBalance: poolBalance ?? this.poolBalance,
      totalExpense: totalExpense ?? this.totalExpense,
      totalPrepay: totalPrepay ?? this.totalPrepay,
      remainder: remainder ?? this.remainder,
      expenseFlex: expenseFlex ?? this.expenseFlex,
      prepayFlex: prepayFlex ?? this.prepayFlex,
      ruleKey: ruleKey ?? this.ruleKey,
      isLocked: isLocked ?? this.isLocked,
      expenseDetail: expenseDetail ?? this.expenseDetail,
      prepayDetail: prepayDetail ?? this.prepayDetail,
      poolDetail: poolDetail ?? this.poolDetail,
      absorbedBy: absorbedBy ?? this.absorbedBy,
      absorbedAmount: absorbedAmount ?? this.absorbedAmount,
    );
  }

  //  2. toMap: 轉成 JSON 存入 Firestore
  Map<String, dynamic> toMap() {
    return {
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'poolBalance': poolBalance,
      'totalExpense': totalExpense,
      'totalPrepay': totalPrepay,
      'remainder': remainder,
      'expenseFlex': expenseFlex,
      'prepayFlex': prepayFlex,
      'ruleKey': ruleKey,
      'isLocked': isLocked,
      'expenseDetail': expenseDetail,
      'prepayDetail': prepayDetail,
      'poolDetail': poolDetail,
      'absorbedBy': absorbedBy,
      'absorbedAmount': absorbedAmount,
    };
  }

  //  3. fromMap: 從 Firestore 讀回物件
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
      totalPrepay: toDouble(map['totalPrepay']),
      remainder: toDouble(map['remainder']),
      expenseFlex: map['expenseFlex'] as int? ?? 0,
      prepayFlex: map['prepayFlex'] as int? ?? 0,
      ruleKey: map['ruleKey'] ?? '',
      isLocked: map['isLocked'] ?? false,
      expenseDetail: toMapDouble(map['expenseDetail']),
      prepayDetail: toMapDouble(map['prepayDetail']),
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
        totalPrepay,
        remainder,
        expenseFlex,
        prepayFlex,
        ruleKey,
        isLocked,
        expenseDetail,
        prepayDetail,
        poolDetail,
        absorbedBy,
        absorbedAmount,
      ];
}
