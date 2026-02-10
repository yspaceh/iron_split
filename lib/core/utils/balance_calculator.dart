import 'dart:math';

import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/record_model.dart';

class SplitResult {
  final Map<String, DualAmount> memberAmounts;
  final double remainder; // 零頭 (基準幣別)
  final DualAmount totalAmount;

  SplitResult({
    required this.memberAmounts,
    required this.remainder,
    required this.totalAmount,
  });
}

class RemainderDetail {
  final double consumer; // 消費端/分攤產生的零頭
  final double payer; // 支付端/匯率產生的零頭
  final double net; // 最終淨零頭 (存入資料庫的值)

  const RemainderDetail({
    this.consumer = 0.0,
    this.payer = 0.0,
    this.net = 0.0,
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

        final double baseTotal = roundToPrecision(
            record.originalAmount * record.exchangeRate, baseCurrency);
        final double ratio = rawAmount / record.originalAmount;

        // 使用 floor 確保不超支 (與分攤邏輯一致)
        final double baseAmount =
            floorToPrecision(baseTotal * ratio, baseCurrency);
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
      final CurrencyConstants currency =
          CurrencyConstants.getCurrencyConstants(r.currencyCode);
      // 1. 收入：全部視為公款增加
      if (r.type == 'income') {
        // originalAmount * exchangeRate
        totalPoolIncomeBase +=
            roundToPrecision(r.originalAmount * r.exchangeRate, currency);
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
          // [修正] 這裡改用與 calculatePersonalCredit 相同的比例算法
          // 這樣 "公款扣除額" + "個人代墊額" 才會剛好等於 "總費用"
          final double baseTotal =
              roundToPrecision(r.originalAmount * r.exchangeRate, currency);
          final double ratio = deductionInOriginal / r.originalAmount;

          // 使用 floor
          totalPoolExpenseBase += floorToPrecision(baseTotal * ratio, currency);
        }
      }
    }

    return totalPoolIncomeBase - totalPoolExpenseBase;
  }

  /// 通用方法：計算單據列表在「結算幣別」下的總收支
  /// 適用於：Group View, Personal View (篩選後), Settlement
  /// 回傳：(總收入, 總支出, 淨餘額)
  static ({double totalIncome, double totalExpense, double netBalance})
      calculateBaseTotals(List<RecordModel> records) {
    double totalIncome = calculateIncomeTotal(records);
    double totalExpense = calculateExpenseTotal(records);

    return (
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense
    );
  }

  static double calculateExpenseTotal(List<RecordModel> records) {
    double total = 0.0;
    for (var r in records) {
      if (r.type == 'expense') {
        final currency = CurrencyConstants.getCurrencyConstants(r.currencyCode);
        total += roundToPrecision(r.originalAmount * r.exchangeRate, currency);
      }
    }
    return total;
  }

  static double calculateIncomeTotal(List<RecordModel> records) {
    double total = 0.0;
    for (var r in records) {
      if (r.type == 'income') {
        final currency = CurrencyConstants.getCurrencyConstants(r.currencyCode);
        total += roundToPrecision(r.originalAmount * r.exchangeRate, currency);
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

  /// [核心] 通用無條件捨去邏輯
  /// 將金額換算並無條件捨去到該幣別的小數位數
  static double floorToPrecision(
      double amount, CurrencyConstants currencyConstants) {
    final int precision = currencyConstants.decimalDigits;
    final double multiplier = pow(10, precision).toDouble();
    return (amount * multiplier).floorToDouble() / multiplier;
  }

  /// 用於計算 "總金額" 的換算，確保最接近真實價值
  static double roundToPrecision(
      double amount, CurrencyConstants currencyConstants) {
    final int precision = currencyConstants.decimalDigits;
    final double multiplier = pow(10, precision).toDouble();
    return (amount * multiplier).roundToDouble() / multiplier;
  }

  /// [核心修正] 全站統一的分帳計算機
  /// 輸入：總金額、匯率、分帳設定
  /// 輸出：完整的分配結果 (包含 UI 要顯示的金額 + 存檔要用的零頭)
  static SplitResult calculateSplit({
    required double totalAmount, // 原始總金額
    required double exchangeRate, // 匯率
    required String splitMethod,
    required List<String> memberIds,
    required Map<String, double> details, // 權重或指定金額
    required CurrencyConstants baseCurrency,
  }) {
    // 1. 計算基準總額 (Total Base) - 無條件捨去
    final double baseTotal =
        roundToPrecision(totalAmount * exchangeRate, baseCurrency);

    final Map<String, DualAmount> memberAmounts = {};

    // 準備計算總權重 (僅用於 Percent 模式)
    double totalWeight = 0.0;
    if (splitMethod == SplitMethodConstant.even) {
      totalWeight = memberIds.length.toDouble();
    } else if (splitMethod == SplitMethodConstant.percent) {
      for (var id in memberIds) {
        totalWeight += details[id] ?? 0.0;
      }
    }

    double allocatedBaseSum = 0.0;

    // 2. 分配邏輯
    if (splitMethod == SplitMethodConstant.exact) {
      // 指定金額模式
      for (var id in memberIds) {
        final sourceAmount = details[id] ?? 0.0;
        // 每個人的 Base 也各自 Floor
        final baseShare =
            floorToPrecision(sourceAmount * exchangeRate, baseCurrency);

        memberAmounts[id] = DualAmount(original: sourceAmount, base: baseShare);
        allocatedBaseSum += baseShare;
      }
    } else {
      // 均分或比例模式
      if (totalWeight > 0) {
        for (var id in memberIds) {
          double weight = (splitMethod == SplitMethodConstant.even)
              ? 1.0
              : (details[id] ?? 0.0);
          final ratio = weight / totalWeight;

          // 原始金額分配 (保留2位小數或依照原幣別精度? 這裡通常保留2位足夠)
          final sourceShare = (totalAmount * ratio * 100).floorToDouble() / 100;

          // 基準金額分配 (Floor)
          // 注意：這裡用 baseTotal * ratio，而不是 totalAmount * rate * ratio
          // 確保分攤總和趨近於 baseTotal
          final baseShare = floorToPrecision(baseTotal * ratio, baseCurrency);

          memberAmounts[id] =
              DualAmount(original: sourceShare, base: baseShare);
          allocatedBaseSum += baseShare;
        }
      }
    }

    // 3. 計算餘額 (Remainder)
    // Remainder = Base Total - Sum(Allocated Base)
    double baseRemainder = baseTotal - allocatedBaseSum;

    // 修正精度問題 (雖然理論上整數運算不會有，但 double 運算還是保險起見)
    baseRemainder = floorToPrecision(baseRemainder, baseCurrency);

    return SplitResult(
      memberAmounts: memberAmounts,
      remainder: baseRemainder,
      totalAmount: DualAmount(original: totalAmount, base: baseTotal), // 回傳總額
    );
  }

  // 在 BalanceCalculator class 內新增

  /// 計算詳細的零頭結構 (用於 S15 編輯頁面顯示)
  /// 回傳: (consumer: 消費端餘數, payer: 支付端餘數, net: 淨結果)
  static RemainderDetail calculateDetailedRemainder(RecordModel record) {
    final currency =
        CurrencyConstants.getCurrencyConstants(record.currencyCode);

    // 1. Income (通常只有分攤餘數)
    if (record.type == 'income') {
      final splitRes = calculateSplit(
          totalAmount: record.originalAmount,
          exchangeRate: record.exchangeRate,
          splitMethod: record.splitMethod,
          memberIds: record.splitMemberIds,
          details: record.splitDetails ?? {},
          baseCurrency: currency);
      return RemainderDetail(
          consumer: splitRes.remainder, payer: 0.0, net: splitRes.remainder);
    }

    // 2. Expense
    if (record.type == 'expense') {
      final double baseTotal = roundToPrecision(
          record.originalAmount * record.exchangeRate, currency);

      // A. 消費端
      final splitRes = calculateSplit(
          totalAmount: record.originalAmount,
          exchangeRate: record.exchangeRate,
          splitMethod: record.splitMethod,
          memberIds: record.splitMemberIds,
          details: record.splitDetails ?? {},
          baseCurrency: currency);
      final double consumerRemainder = splitRes.remainder;

      // B. 支付端 (Mixed/Multiple)
      double allocatedPayerSum = 0.0;
      if (record.payerType == 'member' || record.payerType == 'prepay') {
        allocatedPayerSum = baseTotal;
      } else if (record.payerType == 'mixed' && record.paymentDetails != null) {
        final prepay =
            (record.paymentDetails!['prepayAmount'] as num?)?.toDouble() ?? 0.0;
        final advances = record.paymentDetails!['memberAdvance'] as Map? ?? {};

        if (prepay > 0) {
          final ratio = prepay / record.originalAmount;
          allocatedPayerSum += floorToPrecision(baseTotal * ratio, currency);
        }
        advances.forEach((key, val) {
          final amount = (val as num).toDouble();
          final ratio = amount / record.originalAmount;
          allocatedPayerSum += floorToPrecision(baseTotal * ratio, currency);
        });
      }
      final double payerRemainder = baseTotal - allocatedPayerSum;

      // C. 回傳物件
      return RemainderDetail(
        consumer: consumerRemainder,
        payer: payerRemainder,
        net: consumerRemainder - payerRemainder, // 淨結果
      );
    }

    return const RemainderDetail();
  }
}
