import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
// 引用 Service
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';

class S30SettlementConfirmViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;

  final DashboardService _dashboardService;
  final SettlementService _settlementService;

  final String taskId;
  final String currentUserId;

  TaskModel? _task;
  List<RecordModel> _records = [];
  bool _isLoading = true;

  // 暫態設定 (合併狀態)
  final Map<String, List<String>> _mergeMap = {};

  // UI 狀態
  List<SettlementMember> _settlementMembers = [];
  BalanceSummaryState _balanceState = BalanceSummaryState.initial();

  // 直接提供 Base Currency 物件供 UI 讀取 Symbol
  CurrencyConstants get baseCurrency {
    if (_task == null) return CurrencyConstants.defaultCurrencyConstants;
    return CurrencyConstants.getCurrencyConstants(_task!.baseCurrency);
  }

  // Getters
  bool get isLoading => _isLoading;
  TaskModel? get task => _task;

  // 這些設定直接從 Task 讀取 (因為 UI 會呼叫 D09/Repo 更新 Task)
  String get remainderRule =>
      _task?.remainderRule ?? RemainderRuleConstants.defaultRule;

  BalanceSummaryState get balanceState => _balanceState;
  List<SettlementMember> get settlementMembers => _settlementMembers;

  List<Map<String, dynamic>> get availableCandidatesForMerge {
    if (_task == null) return [];
    return _task!.members.entries
        .map((e) => e.value as Map<String, dynamic>)
        .toList();
  }

  Map<String, List<String>> get currentMergeMap => _mergeMap;

  double get totalBufferAmount =>
      _settlementMembers.fold(0.0, (sum, item) => sum + item.remainderAmount);

// [修改] 取得所有成員的攤平列表 (將 Head 還原為個人單位)
  List<SettlementMember> get allMembers {
    final List<SettlementMember> flattened = [];

    for (var m in _settlementMembers) {
      if (m.subMembers.isEmpty) {
        // 沒有合併，直接加入
        flattened.add(m);
      } else {
        // 有合併：需要拆解
        // 1. 加入子成員 (本來就在 subMembers 裡)
        flattened.addAll(m.subMembers);

        // 2. 加入 Head 的「個人部分」
        // 計算邏輯：總額 - 所有子成員的總額
        final double childrenSum =
            m.subMembers.fold(0.0, (sum, child) => sum + child.finalAmount);
        final double headIndividualAmount = m.finalAmount - childrenSum;

        // 創建一個暫時的 Head 個人物件 (僅用於列表顯示與 B04 候選)
        // 這裡我們手動複製 m 的屬性，但金額改為個人金額
        flattened.add(SettlementMember(
          id: m.id,
          displayName: m.displayName,
          avatar: m.avatar,
          isLinked: m.isLinked,
          finalAmount: headIndividualAmount, // <--- 關鍵修改
          baseAmount: m.baseAmount, // 這裡視需求可能也要扣除，但顯示上主要看 finalAmount
          remainderAmount: 0, // 簡化處理
          isRemainderAbsorber: m.isRemainderAbsorber,
          isMergedHead: false, // 還原為個人，所以不是 Head
          subMembers: const [],
        ));
      }
    }
    return flattened;
  }

  S30SettlementConfirmViewModel({
    required this.taskId,
    required this.currentUserId,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required DashboardService dashboardService,
    required SettlementService settlementService,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _dashboardService = dashboardService,
        _settlementService = settlementService;

  void init() {
    _isLoading = true;
    notifyListeners();

    _taskRepo.streamTask(taskId).listen((taskData) {
      if (taskData != null) {
        _task = taskData;
        _recalculate();
      }
    });

    _recordRepo.streamRecords(taskId).listen((records) {
      _records = records;
      _recalculate();
    });
  }

  void _recalculate() {
    if (_task == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Step 1: Top Card - 使用 DashboardService (完全不變)
    // 因為 D09 已經把 DB 更新為使用者選擇的幣別，所以這裡直接算就好
    _balanceState = _dashboardService.calculateBalanceState(
      task: _task!,
      records: _records,
      currentUserId: currentUserId,
    );

    // Step 2: Bottom List - 使用 SettlementService
    // 這裡負責發牌與合併
    _settlementMembers = _settlementService.calculateSettlementMembers(
      task: _task!,
      records: _records,
      remainderRule: _task!.remainderRule,
      remainderAbsorberId: _task!.remainderAbsorberId,
      mergeMap: _mergeMap,
    );

    _isLoading = false;
    notifyListeners();
  }

  // --- Actions ---

  // 注意：沒有 updateCurrency Action，因為 UI 會直接呼叫 D09。
  // 注意：沒有 updateRemainderRule Action，因為 S13 是直接呼叫 Repo，S30 應該也比照辦理
  // 或者在此提供 Wrapper

  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    // 直接更新 DB，觸發 Stream 更新
    await _taskRepo.updateTask(taskId, {
      'remainderRule': newRule,
      'remainderAbsorberId':
          newRule == RemainderRuleConstants.member ? newAbsorberId : null,
    });
  }

  void mergeMembers(String headId, List<String> childrenIds) {
    _mergeMap[headId] = childrenIds;
    _mergeMap.forEach((key, list) {
      if (key != headId) list.removeWhere((id) => childrenIds.contains(id));
    });
    _mergeMap.removeWhere((key, list) => list.isEmpty);
    _recalculate();
  }

  void unmergeMembers(String headId) {
    _mergeMap.remove(headId);
    _recalculate();
  }
}
