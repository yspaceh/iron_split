import 'dart:math';

import 'package:iron_split/core/constants/currency_constants.dart';
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
      required CurrencyConstants baseCurrency,
      required bool isBaseCurrency}) {
    double totalPaid = 0.0;
    double totalConsumed = 0.0;

    for (var record in allRecords) {
      totalPaid += calculatePersonalCredit(record, uid, baseCurrency,
          isBaseCurrency: isBaseCurrency);
      totalConsumed += calculatePersonalDebit(record, uid, baseCurrency,
          isBaseCurrency: isBaseCurrency);
    }

    return totalPaid - totalConsumed;
  }

  /// 判斷使用者是否與此紀錄有關
  static bool isUserInvolved(
      RecordModel record, String uid, CurrencyConstants baseCurrency) {
    if (calculatePersonalCredit(record, uid, baseCurrency,
            isBaseCurrency: false) >
        0) {
      return true;
    }
    if (calculatePersonalDebit(record, uid, baseCurrency,
            isBaseCurrency: false) >
        0) {
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
  static double calculatePersonalDebit(
      RecordModel record, String uid, CurrencyConstants baseCurrency,
      {required bool isBaseCurrency}) {
    if (record.type == 'income') return 0.0;

    double totalDebit = 0.0;
    double exchangeRate = isBaseCurrency ? record.exchangeRate : 1.0;

    // 1. 處理細項分攤 (Items)
    if (record.details.isNotEmpty) {
      for (var item in record.details) {
        // [關鍵改變] 直接呼叫 calculateSplit 算這一個 Item 的分配
        final itemSplitResult = calculateSplit(
          totalAmount: item.amount,
          exchangeRate: exchangeRate,
          splitMethod: item.splitMethod,
          memberIds: item.splitMemberIds,
          details: item.splitDetails ?? {}, // 權重 map
          baseCurrency: baseCurrency, // 傳入幣別以決定小數點精度
        );

        // 取出使用者的份額 (如果沒分到就是 0)
        totalDebit += itemSplitResult.baseAmounts[uid] ?? 0.0;
      }
    }

    // 2. 處理剩餘金額分攤 (Base Remaining)
    double amountCoveredByItems =
        record.details.fold(0.0, (sum, item) => sum + item.amount);
    double remainingAmount = record.originalAmount - amountCoveredByItems;

    if (remainingAmount > 0.001) {
      // [關鍵改變] 直接呼叫 calculateSplit 算剩餘金額的分配
      final mainSplitResult = calculateSplit(
        totalAmount: remainingAmount,
        exchangeRate: exchangeRate,
        splitMethod: record.splitMethod, // 使用 Record 主體的規則
        memberIds: record.splitMemberIds, // 使用 Record 主體的成員
        details: record.splitDetails ?? {}, // 使用 Record 主體的權重
        baseCurrency: baseCurrency,
      );

      // 取出使用者的份額
      totalDebit += mainSplitResult.baseAmounts[uid] ?? 0.0;
    }

    return totalDebit;
  }

  /// 公開方法：計算單筆紀錄對使用者的貢獻/入金影響 (Credit)
  /// 1. 支援 Expense 類型的代墊計算 (Member Advance)
  /// 2. 支援 Mixed 支付中的代墊部分
  /// 3. 確保 Income 的指定金額 (splitDetails) 也有乘上匯率
  static double calculatePersonalCredit(
      RecordModel record, String uid, CurrencyConstants baseCurrency,
      {required bool isBaseCurrency}) {
    // 取得匯率 (若不需要換算則為 1.0)
    double exchangeRate = isBaseCurrency ? record.exchangeRate : 1.0;

    // --- 處理支出 (Expense) 的代墊貢獻 ---
    if (record.type == 'expense') {
      double rawAmount = 0.0;

      // 情況 A: 單一成員全額代墊
      if (record.payerType == 'member' && record.payerId == uid) {
        rawAmount = record.originalAmount;
      }
      // 情況 B: 混合支付 (Mixed) 中的成員代墊部分
      else if (record.payerType == 'mixed' && record.paymentDetails != null) {
        // [修正] 這裡修正了之前提到的 Key 拼字錯誤 memberAdvances -> memberAdvance
        final advances = record.paymentDetails!['memberAdvance'];
        if (advances is Map && advances.containsKey(uid)) {
          rawAmount = (advances[uid] as num).toDouble();
        }
      }
      // 情況 C: 公款支付 (Prepay) -> 個人貢獻為 0
      else {
        return 0.0;
      }

      // [重點] 這裡也要模擬 calculateSplit 的總額計算邏輯
      // 必須使用同樣的 floorToPrecision，否則會出現 Payer 付了 300.9，但總 Split 只有 300 的狀況
      if (rawAmount > 0) {
        return floorToPrecision(rawAmount * exchangeRate, baseCurrency);
      }
      return 0.0;
    }

    // --- 處理收入 (Income) 的入金貢獻 ---
    if (record.type == 'income') {
      // 不管是 Even 還是 Exact，Income 的邏輯其實就是「把這筆錢分到參與者頭上」
      // 這與 calculateSplit 的邏輯完全共用
      final splitResult = calculateSplit(
        totalAmount: record.originalAmount,
        exchangeRate: exchangeRate,
        splitMethod: record.splitMethod, // 這裡通常是 Even 或 Exact
        memberIds: record.splitMemberIds,
        details: record.splitDetails ?? {},
        baseCurrency: baseCurrency,
      );

      // 直接取出該使用者的份額 (已經包含 Floor 處理)
      // 如果 isBaseCurrency 為 true，取 baseAmounts；否則取 sourceAmounts (雖然 Income 通常看 Base)
      if (isBaseCurrency) {
        return splitResult.baseAmounts[uid] ?? 0.0;
      } else {
        // 如果是要算原幣，理論上 calculateSplit 也有保留 sourceAmounts
        return splitResult.sourceAmounts[uid] ?? 0.0;
      }
    }

    return 0.0;
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
    required CurrencyConstants baseCurrency, // [修改] 改傳幣別代碼 (e.g. "TWD", "USD")
  }) {
    final Map<String, double> sourceAmounts = {};
    final Map<String, double> baseAmounts = {};

    // 2. Base Total
    // 使用 floorToPrecision 確保不會超過總額
    final double baseTotal =
        floorToPrecision(totalAmount * exchangeRate, baseCurrency);

    // 3. 計算總權重
    double totalWeight = 0.0;
    if (splitMethod == SplitMethodConstants.even) {
      totalWeight = memberIds.length.toDouble();
    } else if (splitMethod == SplitMethodConstants.percent) {
      for (var id in memberIds) {
        totalWeight += details[id] ?? 0.0;
      }
    }

    // 4. 計算分配
    double allocatedBaseSum = 0.0;

    // A. Exact Mode
    if (splitMethod == SplitMethodConstants.exact) {
      for (var id in memberIds) {
        final sourceAmount = details[id] ?? 0.0;
        sourceAmounts[id] = sourceAmount;

        // 這裡的邏輯：使用者輸入的原幣金額 -> 換算匯率 -> 依照目標幣別精度取整
        final baseShare =
            floorToPrecision(sourceAmount * exchangeRate, baseCurrency);

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

          // Source Share (Display): 顯示用，通常保持 2 位小數供參考
          final sourceShare = (totalAmount * ratio * 100).floorToDouble() / 100;
          sourceAmounts[id] = sourceShare;

          // Base Share (Logic):
          // 關鍵：依比例分配 baseTotal，並依照幣別精度取整
          final baseShare = floorToPrecision(baseTotal * ratio, baseCurrency);

          baseAmounts[id] = baseShare;
          allocatedBaseSum += baseShare;
        }
      }
    }

    // 5. 算出零頭
    double remainder = baseTotal - allocatedBaseSum;

    // [最終修整] 強制轉字串再轉回，消除二進制浮點數誤差 (如 0.00000004)
    // 直接使用從 getCurrencyConstants 拿到的 baseDecimals
    remainder =
        double.parse(remainder.toStringAsFixed(baseCurrency.decimalDigits));

    return SplitResult(
      sourceAmounts: sourceAmounts,
      baseAmounts: baseAmounts,
      remainder: remainder,
    );
  }
}
