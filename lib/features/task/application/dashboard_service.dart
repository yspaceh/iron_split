import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart'; // 核心引用
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class DashboardService {
  /// 1. [核心計算]：依賴 BalanceCalculator 算出 State
  BalanceSummaryState calculateBalanceState({
    required TaskModel task,
    required List<RecordModel> records,
    required String currentUserId,
  }) {
    // 1. [修正] 直接使用 BalanceCalculator 計算各幣別公款餘額 (Pool Detail)
    // 這取代了原本的手動迴圈加總，確保與舊 Page 邏輯完全一致
    final Map<String, double> poolDetail =
        BalanceCalculator.calculatePoolBalancesByOriginalCurrency(records);

    // 2. 計算核心金額 (維持不變)
    final double remainder =
        BalanceCalculator.calculateRemainderBuffer(records);
    final double totalExpense =
        BalanceCalculator.calculateExpenseTotal(records, isBaseCurrency: true);

    // Pool Balance (主幣別總額)
    // 從算好的 map 裡直接取，取不到就 0
    final double poolBalance = poolDetail[task.baseCurrency] ?? 0.0;

    // 3. 計算圖表比例 (維持不變)
    int expenseFlex = 0;
    int incomeFlex = 0;
    if (totalExpense.abs() > 0) {
      expenseFlex = 1000;
      incomeFlex = 0;
    }

    return BalanceSummaryState(
      currencyCode: task.baseCurrency,
      currencySymbol: '\$',
      poolBalance: poolBalance,
      totalExpense: totalExpense,
      totalIncome: 0,
      remainder: remainder,
      expenseFlex: expenseFlex,
      incomeFlex: incomeFlex,
      ruleKey: task.remainderRule,
      isLocked: task.status != 'ongoing',
      expenseDetail: {}, // RecordModel 沒 currency，暫空
      incomeDetail: {},
      poolDetail: poolDetail, // ✅ 這裡現在裝的是 BalanceCalculator 算出來的正確結果
      absorbedBy: null,
      absorbedAmount: null,
    );
  }

  /// 新增：完全對齊 S13 Page 的計算邏輯
  Map<String, double> calculatePoolBalances(List<RecordModel> records) {
    return BalanceCalculator.calculatePoolBalancesByOriginalCurrency(records);
  }

  /// 2. [列表分組]：完全移植 S13GroupView._groupRecords
  Map<DateTime, List<RecordModel>> groupRecordsByDate(
      List<RecordModel> records) {
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

  /// 3. [日期生成]：完全移植 S13GroupView._generateFullDateRangeDescending
  List<DateTime> generateDisplayDates({
    required DateTime startDate,
    required DateTime endDate,
    required Map<DateTime, List<RecordModel>> groupedRecords,
  }) {
    // 1. 產生範圍內的所有日期 (移植邏輯)
    List<DateTime> rangeDates = [];
    if (startDate.isAfter(endDate)) {
      rangeDates = [startDate];
    } else {
      final days = endDate.difference(startDate).inDays;
      rangeDates = List.generate(
          days + 1, (index) => endDate.subtract(Duration(days: index)));
    }

    // 2. 合併有紀錄的日期
    final Set<DateTime> uniqueDates = {};
    uniqueDates.addAll(rangeDates);
    uniqueDates.addAll(groupedRecords.keys);

    // 3. 排序 (Desc)
    return uniqueDates.toList()..sort((a, b) => b.compareTo(a));
  }

  /// 4. [捲動目標計算]：移植 Auto-Scroll 判定
  DateTime calculateInitialTargetDate(DateTime start, DateTime end) {
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

  /// 新增：過濾出與特定使用者有關的紀錄 (S13PersonalView 邏輯)
  List<RecordModel> filterPersonalRecords(
      List<RecordModel> allRecords, String uid) {
    return allRecords.where((record) {
      return BalanceCalculator.isUserInvolved(record, uid);
    }).toList();
  }

  /// 新增：計算個人淨額 (S13PersonalView Card 邏輯)
  double calculatePersonalNetBalance({
    required List<RecordModel> allRecords,
    required String uid,
  }) {
    return BalanceCalculator.calculatePersonalNetBalance(
      allRecords: allRecords,
      uid: uid,
      isBaseCurrency: true,
    );
  }

  /// 新增：計算當日個人消費總額 (S13PersonalView DailyHeader 邏輯)
  double calculateDailyPersonalDebit(List<RecordModel> dayRecords, String uid) {
    double dayMyDebit = 0;
    for (var r in dayRecords) {
      // 1. Get personal share in original currency
      double myShareOriginal = BalanceCalculator.calculatePersonalDebit(r, uid,
          isBaseCurrency: false);
      // 2. Convert to Base Currency
      dayMyDebit += myShareOriginal * r.exchangeRate;
    }
    return dayMyDebit;
  }
}
