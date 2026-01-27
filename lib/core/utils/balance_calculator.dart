import 'package:iron_split/core/models/record_model.dart';

class BalanceCalculator {
  /// 計算特定使用者的淨餘額 (Net Balance)
  /// 公式：(總支付 Credit) - (總消費 Debit)
  static double calculatePersonalNetBalance({
    required List<RecordModel> allRecords,
    required String uid,
  }) {
    double totalPaid = 0.0;
    double totalConsumed = 0.0;

    for (var record in allRecords) {
      totalPaid += calculatePersonalCredit(record, uid);
      totalConsumed += calculatePersonalDebit(record, uid);
    }

    return totalPaid - totalConsumed;
  }

  /// 判斷使用者是否與此紀錄有關
  static bool isUserInvolved(RecordModel record, String uid) {
    if (calculatePersonalCredit(record, uid) > 0) return true;
    if (calculatePersonalDebit(record, uid) > 0) return true;

    if (record.items.isNotEmpty) {
      for (var item in record.items) {
        if (item.splitMemberIds.contains(uid)) return true;
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
  static double calculatePersonalDebit(RecordModel record, String uid) {
    if (record.type == 'income') return 0.0;

    double totalDebit = 0.0;

    // 1. 處理細項分攤
    if (record.items.isNotEmpty) {
      for (var item in record.items) {
        totalDebit += _calculateItemDebit(item, uid);
      }
    }

    // 2. 處理剩餘金額分攤 (Base Remaining)
    double amountCoveredByItems =
        record.items.fold(0.0, (sum, item) => sum + item.amount);
    double remainingAmount = record.amount - amountCoveredByItems;

    if (remainingAmount > 0.001) {
      totalDebit += _calculateBaseRemainingDebit(record, uid, remainingAmount);
    }

    return totalDebit;
  }

  /// 公開方法：計算單筆紀錄對使用者的貢獻/入金影響 (Credit)
  /// 修正：由私有 _calculateCredit 轉為公開，並處理預收邏輯
  static double calculatePersonalCredit(RecordModel record, String uid) {
    if (record.type == 'expense') return 0.0;

    // 預收(Income)的入金者由 splitDetails 或 splitMemberIds 決定
    if (record.splitDetails != null && record.splitDetails!.containsKey(uid)) {
      return (record.splitDetails![uid] as num).toDouble();
    }

    if (record.splitMemberIds.contains(uid)) {
      return record.amount / record.splitMemberIds.length;
    }

    return 0.0;
  }

  /// 計算零頭罐 (Remainder Buffer)
  /// 修正：加入正負號邏輯 (支出餘數為正，預收溢收為正/少收為負)
  static double calculateRemainderBuffer(List<RecordModel> records) {
    double totalBuffer = 0.0;
    for (var r in records) {
      final double baseTotal = r.amount * r.exchangeRate;
      double allocatedBase = 0.0;

      if (r.type == 'expense') {
        // 支出：算出實際分攤總額 (通常因 Floor 而小於 baseTotal)
        if (r.splitMethod == 'even' && r.splitMemberIds.isNotEmpty) {
          double perPerson =
              (baseTotal / r.splitMemberIds.length).floorToDouble();
          allocatedBase = perPerson * r.splitMemberIds.length;
        } else {
          allocatedBase = baseTotal;
        }
        totalBuffer += (baseTotal - allocatedBase); // 剩餘的錢進罐子 (+)
      } else {
        // 預收：算出實際收到的總額
        if (r.splitMethod == 'even' && r.splitMemberIds.isNotEmpty) {
          double perPerson =
              (baseTotal / r.splitMemberIds.length).floorToDouble();
          allocatedBase = perPerson * r.splitMemberIds.length;
        } else {
          allocatedBase = baseTotal;
        }
        totalBuffer += (allocatedBase - baseTotal); // 多收為正，少收為負
      }
    }
    return totalBuffer;
  }

  // --- 私有計算邏輯 ---

  static double _calculateItemDebit(RecordItem item, String uid) {
    if (!item.splitMemberIds.contains(uid)) return 0.0;

    switch (item.splitMethod) {
      case 'even':
        return item.amount / item.splitMemberIds.length;
      case 'exact':
        return item.splitDetails?[uid] ?? 0.0;
      case 'percent':
        return _calculateWeightBasedAmount(item.amount, item.splitDetails, uid);
      default:
        return 0.0;
    }
  }

  static double _calculateBaseRemainingDebit(
      RecordModel record, String uid, double amount) {
    if (!record.splitMemberIds.contains(uid)) return 0.0;

    switch (record.splitMethod) {
      case 'even':
        return amount / record.splitMemberIds.length;
      case 'exact':
        return record.splitDetails?[uid] ?? 0.0;
      case 'percent':
        return _calculateWeightBasedAmount(amount, record.splitDetails, uid);
      default:
        return 0.0;
    }
  }

  /// 權重/比例計算核心 (修正比例分攤顯示 JPY 2 的問題)
  static double _calculateWeightBasedAmount(
      double totalAmount, Map<String, dynamic>? details, String uid) {
    if (details == null || details.isEmpty) return 0.0;

    double myWeight = (details[uid] as num? ?? 0.0).toDouble();
    double totalWeights =
        details.values.fold(0.0, (sum, w) => sum + (w as num).toDouble());

    if (totalWeights > 0) {
      return totalAmount * (myWeight / totalWeights);
    }
    return 0.0;
  }

  /// 計算公款剩餘餘額 (Pool Balance / Cash on Hand)
  /// 邏輯：所有預收 (Income) - 由公款支付的費用 (Expense paid by prepay)
  /// 備註：成員代墊 (payerType != 'prepay') 不會減少公款餘額
  static double calculatePrepayBalance(
      {required List<RecordModel> allRecords,
      bool exchangeToBaseCurrency = false}) {
    double totalPoolIncome = 0.0;
    double totalPoolExpense = 0.0;

    for (var r in allRecords) {
      // 統一換算為結算幣別 (Base Currency)
      final exchangeRate = exchangeToBaseCurrency ? r.exchangeRate : 1.0;
      final double baseAmount = r.amount * exchangeRate;

      if (r.type == 'income') {
        // 1. 所有預收單據都視為公款收入 (+)
        totalPoolIncome += baseAmount;
      } else if (r.type == 'expense') {
        // 2. 只有「由公款支付」的費用才從餘額扣除 (-)
        // 檢查 RecordModel 的 payerType 是否為 'prepay'
        if (r.payerType == 'prepay') {
          totalPoolExpense += baseAmount;
        }
        // 若 payerType 是 'member' (代墊)，則不扣除
      }
    }

    // 回傳：總收入 - 公款支出
    return totalPoolIncome - totalPoolExpense;
  }

  /// 通用方法：計算單據列表在「結算幣別」下的總收支
  /// 適用於：Group View, Personal View (篩選後), Settlement
  /// 回傳：(總收入, 總支出, 淨餘額)
  static ({double totalIncome, double totalExpense, double netBalance})
      calculateBaseTotals(List<RecordModel> records,
          {bool exchangeToBaseCurrency = false}) {
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (var r in records) {
      // 核心邏輯：每一筆都乘上自己的匯率，轉為 Base Currency
      final exchangeRate = exchangeToBaseCurrency ? r.exchangeRate : 1.0;
      final double baseAmount = r.amount * exchangeRate;

      if (r.type == 'income') {
        totalIncome += baseAmount;
      } else {
        totalExpense += baseAmount;
      }
    }

    return (
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense
    );
  }
}
