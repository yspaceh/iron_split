import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/error/exceptions.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class SettlementService {
  final TaskRepository _taskRepo;

  SettlementService(this._taskRepo);

  /// 隨機選出一位餘額得主 (用於 S32 初始化時)
  String pickRandomRemainderWinner(List<String> memberIds) {
    if (memberIds.isEmpty) return '';
    final random = Random();
    return memberIds[random.nextInt(memberIds.length)];
  }

  /// S30 預覽用：計算當前金額 (若為 Random 且未結算，remainderAbsorberId 傳 null)
  /// 此時 Random 模式下，餘額不會分配給任何人，大家只看到 Base Amount
  List<SettlementMember> calculateSettlementMembers({
    required TaskModel task,
    required List<RecordModel> records,
    required String remainderRule,
    String? remainderAbsorberId,
    required Map<String, List<String>> mergeMap,
  }) {
    // 1. 取得 Base Net Balance
    // 因為 D09 已經更新了 DB 裡的匯率，所以這裡算出來的就是最新幣別的淨額
    final baseBalances = _calculateBaseNetBalances(task, records);

    final double totalRemainder =
        BalanceCalculator.calculateRemainderBuffer(records);

    // 2. 餘額發牌 (Card Dealing)
    final memberResults = _applyRemainderAllocation(
        task: task,
        baseBalances: baseBalances,
        remainderRule: remainderRule,
        remainderAbsorberId: remainderAbsorberId,
        totalRemainder: totalRemainder);

    // 3. 處理合併
    return _processMerging(rawMembers: memberResults, mergeMap: mergeMap);
  }

  Map<String, double> _calculateBaseNetBalances(
      TaskModel task, List<RecordModel> records) {
    final Map<String, double> balances = {};
    for (var uid in task.members.keys) {
      balances[uid] = BalanceCalculator.calculatePersonalNetBalance(
        allRecords: records,
        uid: uid,
        baseCurrency: CurrencyConstants.getCurrencyConstants(task.baseCurrency),
      ).base;
    }
    return balances;
  }

  /// 核心分配邏輯
  /// 職責：將傳入的 [totalRemainder] 依照規則分配給成員
  /// 不再自行推算餘額，而是完全信任外部傳入的 source of truth
  Map<String, SettlementMember> _applyRemainderAllocation({
    required TaskModel task,
    required Map<String, double> baseBalances,
    required String remainderRule,
    String? remainderAbsorberId,
    required double totalRemainder, // <--- 這是重點：拿這包確定的錢來分
  }) {
    final Map<String, SettlementMember> results = {};

    // 1. 準備工具：取得最小貨幣單位 (Step)
    final currency = CurrencyConstants.getCurrencyConstants(task.baseCurrency);
    final int exponent = currency.decimalDigits;
    final double stepValue = 1 / pow(10, exponent); // e.g., 0.01

    // 2. 準備 Base Amount (每個人的基本盤)
    // 這裡只做 Floor (無條件捨去)，不做任何餘額計算
    Map<String, double> baseAmountMap = {};
    baseBalances.forEach((uid, val) {
      double multiplier = pow(10, exponent).toDouble();
      baseAmountMap[uid] = (val * multiplier).floorToDouble() / multiplier;
    });

    // 3. 準備分配表 (誰拿到多少零頭)
    Map<String, double> allocatedRemMap = {};
    // 初始化為 0
    for (var uid in task.members.keys) {
      allocatedRemMap[uid] = 0.0;
    }

    // 4. 開始分配 (根據你的三條規則)

    // --- 規則 A: Random (輪盤) ---
    if (remainderRule == RemainderRuleConstants.random) {
      // S30 邏輯：完全不計算分配。
      // 餘額懸浮在空中，沒人拿到。 allocatedRemMap 全是 0。
    }

    // --- 規則 B: Member (指定) ---
    else if (remainderRule == RemainderRuleConstants.member &&
        remainderAbsorberId != null) {
      // S30 邏輯：零頭總額直接歸屬到指定成員身上
      if (allocatedRemMap.containsKey(remainderAbsorberId)) {
        allocatedRemMap[remainderAbsorberId] = totalRemainder;
      }
    }

    // --- 規則 C: Order (輪流) ---
    else if (remainderRule == RemainderRuleConstants.order) {
      // S30 邏輯：零頭總額用發牌邏輯把零頭發完

      // 計算有幾張牌 (幾分錢)
      int steps = (totalRemainder / stepValue).round();

      if (steps != 0) {
        // 決定發牌順序 (依照加入時間或 ID 排序)
        List<String> sortedIds = task.members.keys.toList()..sort();

        int count = steps.abs();
        double unit = stepValue * (steps > 0 ? 1 : -1); // 處理負餘額的情況
        int idx = 0;

        // 一張一張發
        for (int i = 0; i < count; i++) {
          String uid = sortedIds[idx];
          allocatedRemMap[uid] = (allocatedRemMap[uid] ?? 0) + unit;
          idx = (idx + 1) % sortedIds.length; // 繞圈圈
        }
      }
    }

    // 5. 組裝最終結果
    baseAmountMap.forEach((uid, base) {
      double rem = allocatedRemMap[uid] ?? 0.0;
      final memberData = task.members[uid] ?? {};

      // 檢查是否為 Random 模式 (決定是否要在 UI 上標示為隱藏/抽獎中)
      bool isRandom = (remainderRule == RemainderRuleConstants.random);

      results[uid] = SettlementMember(
        id: uid,
        displayName: memberData['displayName'] ?? 'Unknown',
        avatar: memberData['avatar'],
        isLinked: memberData['isLinked'] ?? false,
        // 最終金額 = 基本盤 + 分配到的零頭
        finalAmount: double.parse((base + rem).toStringAsFixed(exponent)),
        baseAmount: base,
        remainderAmount: rem,
        isRemainderAbsorber: rem.abs() > 0.0000001, // 拿到錢的人就是吸收者
        isRemainderHidden: isRandom, // Random 模式 UI 會顯示特殊狀態
      );
    });

    return results;
  }

  List<SettlementMember> _processMerging({
    required Map<String, SettlementMember> rawMembers,
    required Map<String, List<String>> mergeMap,
  }) {
    List<SettlementMember> list = [];

    // 1. 先找出所有「被合併的子成員」ID (這些人不該出現在列表最外層)
    final Set<String> allChildIds =
        mergeMap.values.expand((ids) => ids).toSet();

    // 2. [關鍵修正] 依照 rawMembers 的順序 (即 TaskModel 的全域順序) 進行遍歷
    // 不要先跑 mergeMap，否則會破壞順序
    for (var entry in rawMembers.entries) {
      final currentId = entry.key;
      final currentModel = entry.value;

      // Case A: 如果他是別人的子成員 -> 跳過 (因為他會被包在 Head 裡面)
      if (allChildIds.contains(currentId)) {
        continue;
      }

      // Case B: 如果他是合併群組的代表 (Head) -> 執行合併計算
      if (mergeMap.containsKey(currentId)) {
        final childrenIds = mergeMap[currentId]!;

        List<SettlementMember> subs = [];
        double mergedFinal = currentModel.finalAmount;
        double mergedBase = currentModel.baseAmount;
        double mergedRem = currentModel.remainderAmount;

        for (var childId in childrenIds) {
          if (rawMembers.containsKey(childId)) {
            var child = rawMembers[childId]!;
            subs.add(child); // 把子成員加入 subMembers

            mergedFinal += child.finalAmount;
            mergedBase += child.baseAmount;
            mergedRem += child.remainderAmount;
          }
        }

        // 建立合併後的 Head 物件
        list.add(SettlementMember(
            id: currentId,
            displayName: currentModel.displayName,
            avatar: currentModel.avatar,
            isLinked: currentModel.isLinked,
            finalAmount: mergedFinal,
            baseAmount: mergedBase,
            remainderAmount: mergedRem,
            isRemainderAbsorber: mergedRem.abs() > 0.0000001,
            isRemainderHidden: currentModel.isRemainderHidden,
            isMergedHead: true,
            subMembers: subs)); // 這裡 subs 只有子成員，不含 Head 自己 (依你的需求可調整)
      }
      // Case C: 普通獨立成員 -> 直接加入
      else {
        list.add(currentModel);
      }
    }

    return list;
  }

  Future<String?> executeSettlement({
    required TaskModel task, // 需要它，是因為要讀取 baseCurrency 和 remainderRule
    required List<RecordModel> records,
    required Map<String, List<String>> mergeMap,
    String? captainPaymentInfoJson, // [修正] 直接接收 JSON
    required double checkPointPoolBalance,
  }) async {
    // 0. 狀態檢查
    if (task.status == 'settled' || task.status == 'closed') {
      throw SettlementStatusInvalidException(task.status);
    }

    // 1. 檢查點驗證 (公款水位)
    final double currentPoolBalance =
        BalanceCalculator.calculatePoolBalanceByBaseCurrency(records);

    if ((currentPoolBalance - checkPointPoolBalance).abs() > 0.01) {
      throw SettlementDataConflictException();
    }

    try {
      // 2. 準備計算資料 (需用到 task.baseCurrency)
      final baseBalances = _calculateBaseNetBalances(task, records);
      final double currentTotalRemainder =
          BalanceCalculator.calculateRemainderBuffer(records);

      // 3. 決定得主 (Random 模式邏輯)
      String? finalWinnerId = task.remainderAbsorberId;

      if (task.remainderRule == RemainderRuleConstants.random) {
        final Set<String> childIds = mergeMap.values.expand((e) => e).toSet();
        final candidateIds =
            baseBalances.keys.where((id) => !childIds.contains(id)).toList();

        if (candidateIds.isNotEmpty) {
          finalWinnerId = pickRandomRemainderWinner(candidateIds);
        }
      }

      // 4. 執行歸戶 (使用共用的分配邏輯)
      // 這裡需用到 task.remainderRule
      String ruleToApply = task.remainderRule;
      String? absorberToApply = task.remainderAbsorberId;

      if (task.remainderRule == RemainderRuleConstants.random) {
        ruleToApply = RemainderRuleConstants.member;
        absorberToApply = finalWinnerId;
      }

      final Map<String, SettlementMember> finalRawMap =
          _applyRemainderAllocation(
        task: task,
        baseBalances: baseBalances,
        remainderRule: ruleToApply,
        remainderAbsorberId: absorberToApply,
        totalRemainder: currentTotalRemainder,
      );

      // 5. 處理合併
      final finalMergedList =
          _processMerging(rawMembers: finalRawMap, mergeMap: mergeMap);

      // 6. 準備存檔資料
      final Map<String, double> allocations = {};
      final Map<String, bool> memberStatus = {};

      for (var m in finalMergedList) {
        allocations[m.id] = m.finalAmount;
        memberStatus[m.id] = false;
      }

      // 7. [新增] 產生 Dashboard 快照
      // 使用與 DashboardService 完全相同的邏輯計算
      final snapshotState = _generateDashboardSnapshot(
        task: task,
        records: records,
        finalWinnerId: finalWinnerId,
      );

      // 8. 寫入 Firestore
      await _taskRepo.settleTask(
        taskId: task.id,
        settlementData: {
          "finalizedAt": Timestamp.now(),
          "baseCurrency": task.baseCurrency, // 這裡用到了 task
          "remainderWinnerId": finalWinnerId,
          "allocations": allocations,
          "memberStatus": memberStatus,
          "receiverInfos": captainPaymentInfoJson,
          "dashboardSnapshot": snapshotState.toMap(),
        },
      );

      return finalWinnerId;
    } catch (e) {
      // TODO: handle error
      if (e is SettlementException) rethrow;
      throw SettlementTransactionFailedException(e.toString());
    }
  }

  // ==========================================
  // [新增] 內部產生快照邏輯
  // 保持與 DashboardService 計算邏輯一致
  // ==========================================
  BalanceSummaryState _generateDashboardSnapshot({
    required TaskModel task,
    required List<RecordModel> records,
    String? finalWinnerId,
  }) {
    // 1. 核心數值 (使用 Calculator)
    final double poolBalance =
        BalanceCalculator.calculatePoolBalanceByBaseCurrency(records);
    final double totalIncome =
        BalanceCalculator.calculateIncomeTotal(records, isBaseCurrency: true);
    final double totalExpense =
        BalanceCalculator.calculateExpenseTotal(records, isBaseCurrency: true);
    final double remainder =
        BalanceCalculator.calculateRemainderBuffer(records);
    final Map<String, double> poolDetail =
        BalanceCalculator.calculatePoolBalancesByOriginalCurrency(records);

    // 2. 詳細分類 (同 DashboardService)
    final Map<String, double> expenseDetail = {};
    final Map<String, double> incomeDetail = {};

    for (var r in records) {
      if (r.type == 'income') {
        incomeDetail.update(r.originalCurrencyCode, (v) => v + r.originalAmount,
            ifAbsent: () => r.originalAmount);
      } else {
        expenseDetail.update(
            r.originalCurrencyCode, (v) => v + r.originalAmount,
            ifAbsent: () => r.originalAmount);
      }
    }

    // 3. Flex 計算 (同 DashboardService)
    int expenseFlex = 0;
    int incomeFlex = 0;
    final totalVolume = totalExpense.abs() + totalIncome.abs();

    if (totalVolume > 0) {
      expenseFlex = ((totalExpense.abs() / totalVolume) * 1000).toInt();
      incomeFlex = 1000 - expenseFlex;
    }

    // 4. 取得得主名稱 (用於 S17 顯示 Absorbed By)
    String? winnerName;
    if (finalWinnerId != null) {
      final winner = task.members[finalWinnerId];
      if (winner != null) {
        winnerName = winner['displayName'];
      }
    }

    return BalanceSummaryState(
      currencyCode: task.baseCurrency,
      currencySymbol: '\$', // 如果需要動態符號，可引入 CurrencyConstants
      poolBalance: poolBalance,
      totalExpense: totalExpense,
      totalIncome: totalIncome,
      remainder: remainder,
      expenseFlex: expenseFlex,
      incomeFlex: incomeFlex,
      ruleKey: task.remainderRule,
      isLocked: true, // 快照永遠是鎖定狀態
      expenseDetail: expenseDetail,
      incomeDetail: incomeDetail,
      poolDetail: poolDetail,
      absorbedBy: winnerName,
      absorbedAmount: null, // S17 通常不顯示具體吸收金額，只顯示人名，如有需要可在此計算
    );
  }

  /// S17: 更新成員的付款狀態 (Pending <-> Cleared)
  /// 只有隊長有權限呼叫此方法
  Future<void> updateMemberStatus({
    required String taskId,
    required String memberId,
    required bool isCleared,
  }) async {
    // 使用 Dot Notation 直接更新 Map 中的特定 Key，不影響其他資料
    await _taskRepo.updateTask(taskId, {
      'settlement.memberStatus.$memberId': isCleared,
    });
  }
}
