import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';
// 引用 Service
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';

class S30SettlementConfirmViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;
  final DashboardService _dashboardService;
  final SettlementService _settlementService;

  final String taskId;

  TaskModel? _task;
  List<RecordModel> _records = [];
  String currentUserId = '';
  StreamSubscription? _taskSubscription;
  StreamSubscription? _recordSubscription;
  LoadStatus _initStatus = LoadStatus.initial; // 頁面狀態// 按鈕狀態
  AppErrorCodes? _initErrorCode;

  double _checkPointPoolBalance = 0.0;

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
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  TaskModel? get task => _task;
  double get checkPointPoolBalance => _checkPointPoolBalance;

  // 這些設定直接從 Task 讀取 (因為 UI 會呼叫 D09/Repo 更新 Task)
  String get remainderRule =>
      _task?.remainderRule ?? RemainderRuleConstants.defaultRule;

  BalanceSummaryState get balanceState => _balanceState;
  List<SettlementMember> get settlementMembers => _settlementMembers;

  List<TaskMember> get availableCandidatesForMerge {
    if (_task == null) return [];
    return _task!.sortedMembersList;
  }

  Map<String, List<String>> get currentMergeMap => _mergeMap;

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

        final double childrenBaseSum =
            m.subMembers.fold(0.0, (sum, child) => sum + child.baseAmount);
        final double headIndividualBaseAmount = m.baseAmount - childrenBaseSum;

        // 💡 註解：合併後的零頭計算統一交由群組層級 (MergedGroup) 處理，
        // 因此這裡單獨拆解出的 Head 個人部分，不重複計算 remainderAmount。
        flattened.add(SettlementMember(
          memberData: m.memberData,
          finalAmount: headIndividualAmount, // <--- 關鍵修改
          baseAmount: headIndividualBaseAmount,
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
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required AuthRepository authRepo,
    required DashboardService dashboardService,
    required SettlementService settlementService,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo,
        _dashboardService = dashboardService,
        _settlementService = settlementService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;
      currentUserId = user.uid;

      _taskSubscription = _taskRepo.streamTask(taskId).listen(
        (taskData) {
          if (taskData != null) {
            _task = taskData;
            _recalculate();
          }
        },
        onError: (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        },
      );

      _recordSubscription = _recordRepo.streamRecords(taskId).listen(
        (records) {
          _records = records;
          _recalculate();
        },
        onError: (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        },
      );
    } on AppErrorCodes catch (code) {
      _initStatus = LoadStatus.error;
      _initErrorCode = code;
      notifyListeners();
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = ErrorMapper.parseErrorCode(e);
      notifyListeners();
    }
  }

  void _recalculate() {
    if (_task == null) return;

    _checkPointPoolBalance =
        BalanceCalculator.calculatePoolBalanceByBaseCurrency(_records);

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

    _initStatus = LoadStatus.success;
    notifyListeners();
  }

  // --- Actions ---

  // 注意：沒有 updateCurrency Action，因為 UI 會直接呼叫 D09。
  // 注意：沒有 updateRemainderRule Action，因為 S13 是直接呼叫 Repo，S30 應該也比照辦理
  // 或者在此提供 Wrapper

  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    try {
      await _taskRepo.updateTask(taskId, {
        'remainderRule': newRule,
        'remainderAbsorberId':
            newRule == RemainderRuleConstants.member ? newAbsorberId : null,
      });
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
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

  Future<void> unlockTask() async {
    try {
      // pending -> ongoing
      await _taskRepo.updateTaskStatus(taskId, 'ongoing');
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  // 取得某位代表成員的「可合併候選名單」
  // 邏輯：排除自己，排除被「別人」合併的人，保留自由身或被「我」合併的人
  List<SettlementMember> getMergeCandidates(SettlementMember head) {
    // 1. 取得所有成員 (利用 allMembers getter 取得完整攤平列表)
    final all = allMembers;

    // 2. 找出哪些人已經被「別人」合併了
    final Set<String> mergedToOthers = {};
    _mergeMap.forEach((headId, childrenIds) {
      if (headId != head.memberData.id) {
        mergedToOthers.addAll(childrenIds);
      }
    });

    // 3. 過濾
    return all.where((m) {
      // 排除自己 (Head)
      if (m.memberData.id == head.memberData.id) return false;
      // 排除已被別人合併的 (但保留被自己合併的)
      if (mergedToOthers.contains(m.memberData.id)) return false;

      return true;
    }).toList();
  }

  @override
  void dispose() {
    // 取消訂閱，防止記憶體洩漏與殭屍回調
    _taskSubscription?.cancel();
    _recordSubscription?.cancel();

    super.dispose();
  }
}
