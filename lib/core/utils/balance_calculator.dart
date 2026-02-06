import 'dart:math';

import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class SplitResult {
  final Map<String, DualAmount> memberAmounts;
  final double remainder; // 零頭 (基準幣別)

  SplitResult({
    required this.memberAmounts,
    required this.remainder,
  });
}

class BalanceCalculator {
  /// 計算特定使用者的淨餘額 (Net Balance)
  /// 公式：(總支付 Credit) - (總消費 Debit)
  static DualAmount calculatePersonalNetBalance(
      {required List<RecordModel> allRecords,
      required String uid,
      required CurrencyConstants baseCurrency}) {
    DualAmount totalPaid = DualAmount.zero;
    DualAmount totalConsumed = DualAmount.zero;

    for (var record in allRecords) {
      totalPaid += calculatePersonalCredit(record, uid, baseCurrency);
      totalConsumed += calculatePersonalDebit(record, uid, baseCurrency);
    }

    return totalPaid - totalConsumed;
  }

  /// 判斷使用者是否與此紀錄有關
  static bool isUserInvolved(
      RecordModel record, String uid, CurrencyConstants baseCurrency) {
    // 只要原幣或本幣大於 0 都算有關
    if (calculatePersonalCredit(record, uid, baseCurrency).original > 0) {
      return true;
    }
    if (calculatePersonalDebit(record, uid, baseCurrency).original > 0) {
      return true;
    }

    // 輔助判斷 (避免金額為 0 但仍在名單內的邊緣情況)
    if (record.details.isNotEmpty) {
      for (var detail in record.details) {
        if (detail.splitMemberIds.contains(uid)) return true;
      }
    }
    if (record.splitDetails != null && record.splitDetails!.containsKey(uid)) {
      return true;
    }
    if (record.splitMemberIds.contains(uid)) {
      return true;
    }

    return false;
  }

  /// 公開方法：計算單筆紀錄對使用者的消費影響 (Debit)
  static DualAmount calculatePersonalDebit(
      RecordModel record, String uid, CurrencyConstants baseCurrency) {
    // 收入不產生 Debit
    if (record.type == 'income') return DualAmount.zero;

    DualAmount totalDebit = DualAmount.zero;

    // 1. 處理細項分攤 (Items)
    if (record.details.isNotEmpty) {
      for (var item in record.details) {
        final itemSplitResult = calculateSplit(
          totalAmount: item.amount,
          exchangeRate: record.exchangeRate,
          splitMethod: item.splitMethod,
          memberIds: item.splitMemberIds,
          details: item.splitDetails ?? {},
          baseCurrency: baseCurrency,
        );

        if (itemSplitResult.memberAmounts.containsKey(uid)) {
          totalDebit += itemSplitResult.memberAmounts[uid]!;
        }
      }
    }

    // 2. 處理剩餘金額分攤 (Base Remaining)
    double amountCoveredByItems =
        record.details.fold(0.0, (sum, item) => sum + item.amount);
    double remainingAmount = record.originalAmount - amountCoveredByItems;

    // 容許些微誤差
    if (remainingAmount > 0.001) {
      final mainSplitResult = calculateSplit(
        totalAmount: remainingAmount,
        exchangeRate: record.exchangeRate,
        splitMethod: record.splitMethod,
        memberIds: record.splitMemberIds,
        details: record.splitDetails ?? {},
        baseCurrency: baseCurrency,
      );

      if (mainSplitResult.memberAmounts.containsKey(uid)) {
        totalDebit += mainSplitResult.memberAmounts[uid]!;
      }
    }

    return totalDebit;
  }

  /// 公開方法：計算單筆紀錄對使用者的貢獻/入金影響 (Credit)
  /// 回傳：DualAmount (同時包含原幣與本幣)
  static DualAmount calculatePersonalCredit(
      RecordModel record, String uid, CurrencyConstants baseCurrency) {
    // --- 處理支出 (Expense) 的代墊貢獻 ---
    if (record.type == 'expense') {
      double rawAmount = 0.0;

      // 情況 A: 單一成員全額代墊
      if (record.payerType == 'member' && record.payerId == uid) {
        rawAmount = record.originalAmount;
      }
      // 情況 B: 混合支付 (Mixed) 中的成員代墊部分
      else if (record.payerType == 'mixed' && record.paymentDetails != null) {
        final advances = record.paymentDetails!['memberAdvance'];
        if (advances is Map && advances.containsKey(uid)) {
          rawAmount = (advances[uid] as num).toDouble();
        }
      }
      // 情況 C: 公款支付 (Prepay) -> 個人貢獻為 0
      else {
        return DualAmount.zero;
      }

      if (rawAmount > 0) {
        // [關鍵] 手動建構 DualAmount
        // baseAmount 必須經過與 calculateSplit 相同的 floorToPrecision 處理
        // 確保 "代墊總額" 與 "消費分攤總額" 的精度一致
        final baseAmount =
            floorToPrecision(rawAmount * record.exchangeRate, baseCurrency);
        return DualAmount(original: rawAmount, base: baseAmount);
      }
      return DualAmount.zero;
    }

    // --- 處理收入 (Income) 的入金貢獻 ---
    if (record.type == 'income') {
      // Income 的邏輯是：將錢「分」給出資者
      final splitResult = calculateSplit(
        totalAmount: record.originalAmount,
        exchangeRate: record.exchangeRate,
        splitMethod: record.splitMethod,
        memberIds: record.splitMemberIds,
        details: record.splitDetails ?? {},
        baseCurrency: baseCurrency,
      );

      return splitResult.memberAmounts[uid] ?? DualAmount.zero;
    }

    return DualAmount.zero;
  }

  /// 計算零頭罐 (Remainder Buffer)
  /// 修正：加入正負號邏輯 (支出餘數為正，預收溢收為正/少收為負)
  static double calculateRemainderBuffer(List<RecordModel> records) {
    double totalBuffer = 0.0;
    for (var r in records) {
      if (r.type == 'income') {
        // 預收：加項
        totalBuffer += r.remainder;
      } else if (r.type == 'expense') {
        // 費用：減項
        totalBuffer -= r.remainder;
      }
    }
    return double.parse(totalBuffer.toStringAsFixed(2));
  }

  /// 計算公款剩餘總價值 (Pool Value in Base Currency)
  /// 用於：Dashboard 大標題 (顯示總資產價值)
  /// 邏輯：所有預收 - 公款支付 (含混合支付中的公款部分)，全部換算回 Base
  static double calculatePoolBalanceByBaseCurrency(
      List<RecordModel> allRecords) {
    double totalPoolIncomeBase = 0.0;
    double totalPoolExpenseBase = 0.0;

    for (var r in allRecords) {
      // 1. 收入：全部視為公款增加
      if (r.type == 'income') {
        // originalAmount * exchangeRate
        totalPoolIncomeBase += r.baseAmount;
      }
      // 2. 支出：檢查是否有用到公款
      else if (r.type == 'expense') {
        double deductionInOriginal = 0.0;

        if (r.payerType == 'prepay') {
          // 全額公款：扣除整筆金額
          deductionInOriginal = r.originalAmount;
        } else if (r.payerType == 'mixed' && r.paymentDetails != null) {
          // 混合支付：只扣除定義在 details 裡的 prepayAmount
          deductionInOriginal =
              (r.paymentDetails!['prepayAmount'] as num?)?.toDouble() ?? 0.0;
        }

        // 如果有扣除額，將其換算為 Base Currency 後累加到總支出
        if (deductionInOriginal > 0) {
          totalPoolExpenseBase += deductionInOriginal * r.exchangeRate;
        }
      }
    }

    return totalPoolIncomeBase - totalPoolExpenseBase;
  }

  /// 通用方法：計算單據列表在「結算幣別」下的總收支
  /// 適用於：Group View, Personal View (篩選後), Settlement
  /// 回傳：(總收入, 總支出, 淨餘額)
  static ({double totalIncome, double totalExpense, double netBalance})
      calculateBaseTotals(List<RecordModel> records,
          {required bool isBaseCurrency}) {
    double totalIncome =
        calculateIncomeTotal(records, isBaseCurrency: isBaseCurrency);
    double totalExpense =
        calculateExpenseTotal(records, isBaseCurrency: isBaseCurrency);

    return (
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense
    );
  }

  static double calculateExpenseTotal(List<RecordModel> records,
      {required bool isBaseCurrency}) {
    double total = 0.0;
    for (var r in records) {
      final exchangeRate = isBaseCurrency ? r.exchangeRate : 1.0;
      final double baseAmount = r.originalAmount * exchangeRate;
      if (r.type == 'expense') {
        total += baseAmount;
      }
    }
    return total;
  }

  static double calculateIncomeTotal(List<RecordModel> records,
      {required bool isBaseCurrency}) {
    double total = 0.0;
    for (var r in records) {
      final exchangeRate = isBaseCurrency ? r.exchangeRate : 1.0;
      final double baseAmount = r.originalAmount * exchangeRate;
      if (r.type == 'income') {
        total += baseAmount;
      }
    }
    return total;
  }

  /// 計算分幣別的公款餘額 (物理庫存)
  /// 用於：S15 記帳頁面的 Smart Picker (顯示我有多少日幣、多少台幣)
  /// 回傳：{'JPY': 30000.0, 'TWD': 1000.0}
  static Map<String, double> calculatePoolBalancesByOriginalCurrency(
      List<RecordModel> allRecords) {
    Map<String, double> balances = {};

    for (var r in allRecords) {
      final currency = r.originalCurrencyCode;
      final amount = r.originalAmount;

      if (r.type == 'income') {
        // 收入：增加庫存
        balances.update(currency, (val) => val + amount,
            ifAbsent: () => amount);
      } else if (r.type == 'expense') {
        // 支出：判斷支付方式
        double prepayDeduction = 0.0;

        if (r.payerType == 'prepay') {
          // 全額公款
          prepayDeduction = amount;
        } else if (r.payerType == 'mixed' && r.paymentDetails != null) {
          // [修正] 混合支付：需讀取其中的 prepayAmount
          prepayDeduction =
              (r.paymentDetails!['prepayAmount'] as num?)?.toDouble() ?? 0.0;
        }

        // 如果有用到公款，從該幣別庫存中扣除
        if (prepayDeduction > 0) {
          balances.update(currency, (val) => val - prepayDeduction,
              ifAbsent: () => -prepayDeduction);
        }
      }
    }
    return balances;
  }

  // [工具函式] 依照幣別精度進行無條件捨去
  // 邏輯：先乘倍數變整數 -> floor -> 再除回倍數
  static double floorToPrecision(double value, CurrencyConstants baseCurrency) {
    // 1. 取得該幣別的小數點位數 (與 formatAmount 邏輯同步)
    // 假設 getCurrencyConstants 是全域可用或已 import 的函式
    final int baseDecimals = baseCurrency.decimalDigits;

    // [工具] 計算精度倍數 (例如 2位小數 -> factor = 100)
    final double factor = pow(10, baseDecimals).toDouble();
    if (baseDecimals == 0) return value.floorToDouble(); // 優化效能
    return (value * factor).floorToDouble() / factor;
  }

  /// [核心修正] 全站統一的分帳計算機
  /// 輸入：總金額、匯率、分帳設定
  /// 輸出：完整的分配結果 (包含 UI 要顯示的金額 + 存檔要用的零頭)
  static SplitResult calculateSplit({
    required double totalAmount,
    required double exchangeRate,
    required String splitMethod,
    required List<String> memberIds,
    required Map<String, double> details,
    required CurrencyConstants baseCurrency,
  }) {
    final Map<String, DualAmount> memberAmounts = {};

    final double baseTotal =
        floorToPrecision(totalAmount * exchangeRate, baseCurrency);

    double totalWeight = 0.0;
    if (splitMethod == SplitMethodConstants.even) {
      totalWeight = memberIds.length.toDouble();
    } else if (splitMethod == SplitMethodConstants.percent) {
      for (var id in memberIds) {
        totalWeight += details[id] ?? 0.0;
      }
    }

    double allocatedBaseSum = 0.0;

    if (splitMethod == SplitMethodConstants.exact) {
      for (var id in memberIds) {
        final sourceAmount = details[id] ?? 0.0;
        final baseShare =
            floorToPrecision(sourceAmount * exchangeRate, baseCurrency);
        memberAmounts[id] = DualAmount(original: sourceAmount, base: baseShare);
        allocatedBaseSum += baseShare;
      }
    } else {
      if (totalWeight > 0) {
        for (var id in memberIds) {
          double weight = (splitMethod == SplitMethodConstants.even)
              ? 1.0
              : (details[id] ?? 0.0);
          final ratio = weight / totalWeight;
          final sourceShare = (totalAmount * ratio * 100).floorToDouble() / 100;
          final baseShare = floorToPrecision(baseTotal * ratio, baseCurrency);
          memberAmounts[id] =
              DualAmount(original: sourceShare, base: baseShare);
          allocatedBaseSum += baseShare;
        }
      }
    }

    double baseRemainder = baseTotal - allocatedBaseSum;
    baseRemainder =
        double.parse(baseRemainder.toStringAsFixed(baseCurrency.decimalDigits));

    return SplitResult(
      memberAmounts: memberAmounts,
      remainder: baseRemainder,
    );
  }
}
