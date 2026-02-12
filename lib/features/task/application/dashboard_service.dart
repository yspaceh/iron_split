import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class DashboardService {
  /// 1. [核心計算]：完全依賴 BalanceCalculator
  BalanceSummaryState calculateBalanceState({
    required TaskModel task,
    required List<RecordModel> records,
    required String currentUserId,
  }) {
    try {
      // 1. [Pool Balance] 右上角大數字 (公款總值)
      final double poolBalance =
          BalanceCalculator.calculatePoolBalanceByBaseCurrency(records);

      // 2. [Chart Stats] 圖表用的總收入與總支出 (歷史總量)
      final double totalIncome =
          BalanceCalculator.calculateIncomeTotal(records);

      final double totalExpense =
          BalanceCalculator.calculateExpenseTotal(records);

      // 3. [Remainder] 零錢罐
      final double remainder =
          BalanceCalculator.calculateRemainderBuffer(records);

      // 4. [Pool Detail] 點擊後的各幣別庫存明細
      final Map<String, double> poolDetail =
          BalanceCalculator.calculatePoolBalancesByOriginalCurrency(records);

      // 5. [Chart Detail] 收入與支出的幣別分布 (給圓餅圖或詳情用)
      // 雖然 BalanceCalculator 沒直接給這個 map，但這只是單純分類加總，可以在這裡簡單做
      // 或者如果您希望連這個都封裝進 Calculator，我可以再加，
      // 但目前為了不改動 Calculator，我們在這裡做簡單的分類。
      final Map<String, double> expenseDetail = {};
      final Map<String, double> incomeDetail = {};

      for (var r in records) {
        if (r.type == 'income') {
          incomeDetail.update(
              r.originalCurrencyCode, (v) => v + r.originalAmount,
              ifAbsent: () => r.originalAmount);
        } else {
          expenseDetail.update(
              r.originalCurrencyCode, (v) => v + r.originalAmount,
              ifAbsent: () => r.originalAmount);
        }
      }

      // 6. [Flex] 計算圖表比例
      int expenseFlex = 0;
      int incomeFlex = 0;

      // 分母為兩者絕對值之和
      final totalVolume = totalExpense.abs() + totalIncome.abs();

      if (totalVolume > 0) {
        // 計算支出佔的比例 (乘 1000 轉整數)
        expenseFlex = ((totalExpense.abs() / totalVolume) * 1000).toInt();
        // 收入佔剩餘比例 (確保加起來是 1000)
        incomeFlex = 1000 - expenseFlex;
      }

      final baseCurrency =
          CurrencyConstants.getCurrencyConstants(task.baseCurrency);

      return BalanceSummaryState(
        currencyCode: task.baseCurrency,
        currencySymbol: baseCurrency.symbol,
        poolBalance: poolBalance,
        totalExpense: totalExpense,
        totalIncome: totalIncome,
        remainder: remainder,
        expenseFlex: expenseFlex,
        incomeFlex: incomeFlex,
        ruleKey: task.remainderRule,
        isLocked: task.status != 'ongoing',
        expenseDetail: expenseDetail,
        incomeDetail: incomeDetail,
        poolDetail: poolDetail,
        absorbedBy: null,
        absorbedAmount: null,
      );
    } catch (e) {
      throw AppErrorCodes.initFailed;
    }
  }

  // ... (其他方法保持不變)
  Map<DateTime, List<RecordModel>> groupRecordsByDate(
      List<RecordModel> records) {
    // ...
    final Map<DateTime, List<RecordModel>> grouped = {};
    for (var record in records) {
      final date =
          DateTime(record.date.year, record.date.month, record.date.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(record);
    }
    return grouped;
  }

  List<DateTime> generateDisplayDates({
    required DateTime startDate,
    required DateTime endDate,
    required Map<DateTime, List<RecordModel>> groupedRecords,
  }) {
    // ...
    List<DateTime> rangeDates = [];
    if (startDate.isAfter(endDate)) {
      rangeDates = [startDate];
    } else {
      final days = endDate.difference(startDate).inDays;
      rangeDates = List.generate(
          days + 1, (index) => endDate.subtract(Duration(days: index)));
    }
    final Set<DateTime> uniqueDates = {};
    uniqueDates.addAll(rangeDates);
    uniqueDates.addAll(groupedRecords.keys);
    return uniqueDates.toList()..sort((a, b) => b.compareTo(a));
  }

  DateTime calculateInitialTargetDate(DateTime start, DateTime end) {
    // ...
    final now = DateTime.now();
    final dStart = DateTime(start.year, start.month, start.day);
    final dEnd = DateTime(end.year, end.month, end.day);
    final dNow = DateTime(now.year, now.month, now.day);
    if (dNow.isBefore(dStart) || dNow.isAfter(dEnd)) {
      return start;
    } else {
      return now;
    }
  }

  List<RecordModel> filterPersonalRecords(List<RecordModel> allRecords,
      String uid, CurrencyConstants baseCurrency) {
    return allRecords.where((record) {
      return BalanceCalculator.isUserInvolved(record, uid, baseCurrency);
    }).toList();
  }

  DualAmount calculatePersonalNetBalance(
      {required List<RecordModel> allRecords,
      required String uid,
      required CurrencyConstants baseCurrency}) {
    return BalanceCalculator.calculatePersonalNetBalance(
        allRecords: allRecords, uid: uid, baseCurrency: baseCurrency);
  }

  DualAmount calculatePersonalDebit(
      {required List<RecordModel> allRecords,
      required String uid,
      required CurrencyConstants baseCurrency}) {
    DualAmount totalConsumed = DualAmount.zero;

    for (var record in allRecords) {
      totalConsumed +=
          BalanceCalculator.calculatePersonalDebit(record, uid, baseCurrency);
    }
    return totalConsumed;
  }

  DualAmount calculatePersonalCredit(
      {required List<RecordModel> allRecords,
      required String uid,
      required CurrencyConstants baseCurrency}) {
    DualAmount totalPaid = DualAmount.zero;

    for (var record in allRecords) {
      totalPaid +=
          BalanceCalculator.calculatePersonalCredit(record, uid, baseCurrency);
    }
    return totalPaid;
  }

  ({DualAmount expense, DualAmount income, DualAmount netBalance})
      calculatePersonalStats(Map<String, dynamic> memberData) {
    final double expense = (memberData['expense'] as num?)?.toDouble() ?? 0.0;
    final double prepaid = (memberData['prepaid'] as num?)?.toDouble() ?? 0.0;

    final totalExpense = DualAmount(original: 0, base: expense);
    final totalIncome = DualAmount(original: 0, base: prepaid);
    final netBalance = DualAmount(original: 0, base: prepaid - expense);
    return (expense: totalExpense, income: totalIncome, netBalance: netBalance);
  }
}
