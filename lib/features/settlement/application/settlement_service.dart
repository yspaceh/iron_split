import 'dart:math';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';

class SettlementService {
  /// 計算結算成員列表
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

    // 2. 餘額發牌 (Card Dealing)
    final memberResults = _applyRemainderAllocation(
      task: task,
      baseBalances: baseBalances,
      remainderRule: remainderRule,
      remainderAbsorberId: remainderAbsorberId,
    );

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
          isBaseCurrency: true // 這會使用 record.exchangeRate (已被 D09 更新)
          );
    }
    return balances;
  }

  Map<String, SettlementMember> _applyRemainderAllocation({
    required TaskModel task,
    required Map<String, double> baseBalances,
    required String remainderRule,
    String? remainderAbsorberId,
  }) {
    final Map<String, SettlementMember> results = {};

    // 取得當前 Task 幣別的精度
    final currency = CurrencyConstants.getCurrencyConstants(task.baseCurrency);
    final int exponent = currency.decimalDigits;
    final double stepValue = 1 / pow(10, exponent);

    double totalVal = 0.0;
    double totalAllocated = 0.0;
    Map<String, double> tempAllocatedMap = {};

    baseBalances.forEach((uid, val) {
      totalVal += val;
      // Floor logic
      double multiplier = pow(10, exponent).toDouble();
      double allocated = (val * multiplier).floorToDouble() / multiplier;
      tempAllocatedMap[uid] = allocated;
      totalAllocated += allocated;
    });

    // 計算誤差
    double totalRemainder = totalVal - totalAllocated;
    int remainderSteps = (totalRemainder / stepValue).round();

    // 發牌邏輯
    Map<String, double> remainderMap = {};
    for (var uid in task.members.keys) {
      remainderMap[uid] = 0.0;
    }

    if (remainderSteps != 0) {
      List<String> candidateIds = [];
      if (remainderRule == RemainderRuleConstants.member &&
          remainderAbsorberId != null) {
        candidateIds = [remainderAbsorberId];
      } else {
        candidateIds = task.members.keys.toList()..sort();
      }

      if (remainderRule == RemainderRuleConstants.member &&
          remainderAbsorberId != null) {
        remainderMap[remainderAbsorberId] = remainderSteps * stepValue;
      } else {
        int count = remainderSteps.abs();
        double unit = stepValue * (remainderSteps > 0 ? 1 : -1);
        int idx = 0;
        for (int i = 0; i < count; i++) {
          String uid = candidateIds[idx];
          remainderMap[uid] = (remainderMap[uid] ?? 0) + unit;
          idx = (idx + 1) % candidateIds.length;
        }
      }
    }

    bool isRandom = remainderRule == RemainderRuleConstants.random;
    tempAllocatedMap.forEach((uid, base) {
      double rem = remainderMap[uid] ?? 0.0;
      final memberData = task.members[uid] ?? {};
      results[uid] = SettlementMember(
        id: uid,
        displayName: memberData['displayName'] ?? 'Unknown',
        avatar: memberData['avatar'],
        isLinked: memberData['isLinked'] ?? false,
        finalAmount: base + rem,
        baseAmount: base,
        remainderAmount: rem,
        isRemainderAbsorber: rem.abs() > 0.0000001,
        isRemainderHidden: isRandom,
      );
    });
    return results;
  }

  List<SettlementMember> _processMerging({
    required Map<String, SettlementMember> rawMembers,
    required Map<String, List<String>> mergeMap,
  }) {
    // ... (合併邏輯完全相同，略去重複代碼以節省篇幅) ...
    // 這裡代碼邏輯與前幾次產出的 _processMerging 完全一致
    // 遍歷 mergeMap, 建立 Head Model (包含 subMembers), 加總 finalAmount 等

    // [Implementation omitted for brevity, logic is identical to previous version]
    // 實際開發時請貼上之前的 _processMerging 實作

    List<SettlementMember> list = [];
    Set<String> processedIds = {};

    mergeMap.forEach((headId, childrenIds) {
      if (!rawMembers.containsKey(headId)) return;
      var headModel = rawMembers[headId]!;
      processedIds.add(headId);

      List<SettlementMember> subs = [];
      double mergedFinal = headModel.finalAmount;
      double mergedBase = headModel.baseAmount;
      double mergedRem = headModel.remainderAmount;

      for (var childId in childrenIds) {
        if (rawMembers.containsKey(childId)) {
          var child = rawMembers[childId]!;
          processedIds.add(childId);
          subs.add(child);

          mergedFinal += child.finalAmount;
          mergedBase += child.baseAmount;
          mergedRem += child.remainderAmount;
        }
      }

      list.add(SettlementMember(
          id: headId,
          displayName: headModel.displayName,
          avatar: headModel.avatar,
          finalAmount: mergedFinal,
          baseAmount: mergedBase,
          remainderAmount: mergedRem,
          isRemainderAbsorber: mergedRem.abs() > 0.0000001,
          isRemainderHidden: headModel.isRemainderHidden,
          isMergedHead: true,
          subMembers: subs));
    });

    rawMembers.forEach((uid, model) {
      if (!processedIds.contains(uid)) {
        list.add(model);
      }
    });

    list.sort((a, b) => b.finalAmount.compareTo(a.finalAmount));
    return list;
  }
}
