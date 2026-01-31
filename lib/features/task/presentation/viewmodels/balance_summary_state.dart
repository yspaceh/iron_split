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
      currencySymbol: '\$',
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
