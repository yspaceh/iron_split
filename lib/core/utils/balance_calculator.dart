import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/record_model.dart';

class SplitResult {
  final Map<String, double> sourceAmounts; // 顯示用 (原始幣別)
  final Map<String, double> baseAmounts; // 內部用 (基準幣別)
  final double remainder; // 零頭 (基準幣別)

  SplitResult({
    required this.sourceAmounts,
    required this.baseAmounts,
    required this.remainder,
  });
}

class BalanceCalculator {
  /// 計算特定使用者的淨餘額 (Net Balance)
  /// 公式：(總支付 Credit) - (總消費 Debit)
  static double calculatePersonalNetBalance(
      {required List<RecordModel> allRecords,
      required String uid,
      required bool isBaseCurrency}) {
    double totalPaid = 0.0;
    double totalConsumed = 0.0;

    for (var record in allRecords) {
      totalPaid +=
          calculatePersonalCredit(record, uid, isBaseCurrency: isBaseCurrency);
      totalConsumed +=
          calculatePersonalDebit(record, uid, isBaseCurrency: isBaseCurrency);
    }

    return totalPaid - totalConsumed;
  }

  /// 判斷使用者是否與此紀錄有關
  static bool isUserInvolved(RecordModel record, String uid) {
    if (calculatePersonalCredit(record, uid, isBaseCurrency: false) > 0) {
      return true;
    }
    if (calculatePersonalDebit(record, uid, isBaseCurrency: false) > 0) {
      return true;
    }

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
  static double calculatePersonalDebit(RecordModel record, String uid,
      {required bool isBaseCurrency}) {
    if (record.type == 'income') return 0.0;

    double totalDebit = 0.0;
    double exchangeRate = isBaseCurrency ? record.exchangeRate : 1.0;

    // 1. 處理細項分攤
    if (record.details.isNotEmpty) {
      for (var item in record.details) {
        totalDebit += _calculateItemDebit(item, uid, exchangeRate);
      }
    }

    // 2. 處理剩餘金額分攤 (Base Remaining)
    double amountCoveredByItems =
        record.details.fold(0.0, (sum, item) => sum + item.amount);
    double remainingAmount = record.originalAmount - amountCoveredByItems;

    if (remainingAmount > 0.001) {
      totalDebit += _calculateBaseRemainingDebit(
          record, uid, remainingAmount, exchangeRate);
    }

    return totalDebit;
  }

  /// 公開方法：計算單筆紀錄對使用者的貢獻/入金影響 (Credit)
  /// 1. 支援 Expense 類型的代墊計算 (Member Advance)
  /// 2. 支援 Mixed 支付中的代墊部分
  /// 3. 確保 Income 的指定金額 (splitDetails) 也有乘上匯率
  static double calculatePersonalCredit(RecordModel record, String uid,
      {required bool isBaseCurrency}) {
    // 取得匯率 (若不需要換算則為 1.0)
    double exchangeRate = isBaseCurrency ? record.exchangeRate : 1.0;

    // --- 處理支出 (Expense) 的代墊貢獻 ---
    if (record.type == 'expense') {
      // 情況 A: 單一成員全額代墊
      if (record.payerType == 'member' && record.payerId == uid) {
        return record.originalAmount * exchangeRate;
      }

      // 情況 B: 混合支付 (Mixed) 中的成員代墊部分
      if (record.payerType == 'mixed' && record.paymentDetails != null) {
        final advances = record.paymentDetails!['memberAdvances'];
        if (advances is Map && advances.containsKey(uid)) {
          double amount = (advances[uid] as num).toDouble();
          return amount * exchangeRate;
        }
      }

      // 情況 C: 公款支付 (Prepay) -> 個人貢獻為 0
      return 0.0;
    }

    // --- 處理收入 (Income) 的入金貢獻 ---
    if (record.type == 'income') {
      // 情況 A: 指定金額 (Exact)
      if (record.splitDetails != null &&
          record.splitDetails!.containsKey(uid)) {
        double amount = (record.splitDetails![uid] as num).toDouble();
        // 修正：原本漏了乘上匯率，這裡補上
        return amount * exchangeRate;
      }

      // 情況 B: 均分 (Even)
      if (record.splitMemberIds.contains(uid)) {
        return record.originalAmount *
            exchangeRate /
            record.splitMemberIds.length;
      }
    }

    return 0.0;
  }

  /// 計算零頭罐 (Remainder Buffer)
  /// 修正：加入正負號邏輯 (支出餘數為正，預收溢收為正/少收為負)
  static double calculateRemainderBuffer(List<RecordModel> records) {
    double totalBuffer = 0.0;
    for (var r in records) {
      // 直接累加，不再重跑分配演算法
      totalBuffer += r.remainder;
    }
    return double.parse(totalBuffer.toStringAsFixed(2));
  }

  // --- 私有計算邏輯 ---

  static double _calculateItemDebit(
      RecordDetail detail, String uid, double effectiveRate) {
    if (!detail.splitMemberIds.contains(uid)) return 0.0;

    switch (detail.splitMethod) {
      case SplitMethodConstants.even:
        return detail.amount * effectiveRate / detail.splitMemberIds.length;
      case SplitMethodConstants.exact:
        return detail.splitDetails?[uid] ?? 0.0;
      case SplitMethodConstants.percent:
        return _calculateWeightBasedAmount(
            detail.amount, detail.splitDetails, uid, effectiveRate);
      default:
        return 0.0;
    }
  }

  static double _calculateBaseRemainingDebit(
      RecordModel record, String uid, double amount, double effectiveRate) {
    if (!record.splitMemberIds.contains(uid)) return 0.0;

    switch (record.splitMethod) {
      case SplitMethodConstants.even:
        return amount * effectiveRate / record.splitMemberIds.length;
      case SplitMethodConstants.exact:
        return record.splitDetails?[uid] ?? 0.0;
      case SplitMethodConstants.percent:
        return _calculateWeightBasedAmount(
            amount, record.splitDetails, uid, effectiveRate);
      default:
        return 0.0;
    }
  }

  /// 權重/比例計算核心 (修正比例分攤顯示 JPY 2 的問題)
  static double _calculateWeightBasedAmount(double totalAmount,
      Map<String, dynamic>? details, String uid, double effectiveRate) {
    if (details == null || details.isEmpty) return 0.0;

    double myWeight = (details[uid] as num? ?? 0.0).toDouble();
    double totalWeights =
        details.values.fold(0.0, (sum, w) => sum + (w as num).toDouble());

    if (totalWeights > 0) {
      return totalAmount * effectiveRate * (myWeight / totalWeights);
    }
    return 0.0;
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

  /// [核心修正] 全站統一的分帳計算機
  /// 輸入：總金額、匯率、分帳設定
  /// 輸出：完整的分配結果 (包含 UI 要顯示的金額 + 存檔要用的零頭)
  static SplitResult calculateSplit({
    required double totalAmount,
    required double exchangeRate,
    required String splitMethod,
    required List<String> memberIds,
    required Map<String, double> details, // 權重或金額設定
  }) {
    final Map<String, double> sourceAmounts = {};
    final Map<String, double> baseAmounts = {};

    // 1. Base Total (四捨五入)
    final double baseTotal = (totalAmount * exchangeRate).roundToDouble();

    // 2. 計算總權重
    double totalWeight = 0.0;
    if (splitMethod == SplitMethodConstants.even) {
      totalWeight = memberIds.length.toDouble();
    } else if (splitMethod == SplitMethodConstants.percent) {
      for (var id in memberIds) {
        totalWeight += details[id] ?? 0.0;
      }
    }

    // 3. 計算分配
    double allocatedBaseSum = 0.0;

    // A. Exact Mode
    if (splitMethod == SplitMethodConstants.exact) {
      for (var id in memberIds) {
        final sourceAmount = details[id] ?? 0.0;
        sourceAmounts[id] = sourceAmount;

        // Exact 模式的零頭來自匯率換算的 floor
        final baseShare = (sourceAmount * exchangeRate).floorToDouble();
        baseAmounts[id] = baseShare;
        allocatedBaseSum += baseShare;
      }
    }
    // B. Even / Percent Mode
    else {
      if (totalWeight > 0) {
        for (var id in memberIds) {
          double weight = (splitMethod == SplitMethodConstants.even)
              ? 1.0
              : (details[id] ?? 0.0);

          final ratio = weight / totalWeight;

          // Source Share (Display): 顯示用，取小數點兩位 floor
          final sourceShare = (totalAmount * ratio * 100).floorToDouble() / 100;
          sourceAmounts[id] = sourceShare;

          // Base Share (Logic): 邏輯用，轉 Base Currency 後 floor
          final baseShare = (baseTotal * ratio).floorToDouble();
          baseAmounts[id] = baseShare;
          allocatedBaseSum += baseShare;
        }
      }
    }

    // 4. 算出零頭
    double remainder = baseTotal - allocatedBaseSum;
    remainder = double.parse(remainder.toStringAsFixed(3)); // 消除浮點誤差

    return SplitResult(
      sourceAmounts: sourceAmounts,
      baseAmounts: baseAmounts,
      remainder: remainder,
    );
  }
}
