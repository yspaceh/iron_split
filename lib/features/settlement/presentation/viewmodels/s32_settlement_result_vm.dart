// lib/features/settlement/presentation/viewmodels/s32_settlement_result_vm.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S32SettlementResultViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;
  final DeepLinkService _deepLinkService;

  TaskModel? _task;
  bool _isLoading = true;

  StreamSubscription? _taskSubscription;

  // Getters
  bool get isLoading => _isLoading;
  TaskModel? get task => _task;

  // 從 Task 中取得 Base Currency
  CurrencyConstants get baseCurrency {
    if (_task == null) return CurrencyConstants.defaultCurrencyConstants;
    return CurrencyConstants.getCurrencyConstants(_task!.baseCurrency);
  }

  double get snapshotRemainder {
    if (_task == null || _task!.settlement == null) return 0.0;

    // 取得快照 Map
    final snapshot =
        _task!.settlement!['dashboardSnapshot'] as Map<String, dynamic>?;

    // 如果是舊資料沒有快照，就回傳 0
    if (snapshot == null) return 0.0;

    // 讀取 'remainder' 欄位
    return (snapshot['remainder'] as num?)?.toDouble() ?? 0.0;
  }

  // 判斷是否顯示輪盤
  bool get shouldShowRoulette {
    // 1. 基本門檻：必須是隨機模式
    if (_task?.remainderRule != RemainderRuleConstants.random) return false;

    // 2. [邏輯修正] 檢查零頭金額是否不為 0
    // 直接使用從快照讀出來的金額
    if (snapshotRemainder.abs() < 0.001) {
      return false; // 金額為 0，不顯示動畫
    }

    // 3. (可選) 檢查是否有贏家 ID (雙重確認)
    // 理論上金額不為 0 就應該要有贏家，這行是防呆
    final winnerId = _task!.settlement!['remainderWinnerId'] as String?;
    if (winnerId == null || winnerId.isEmpty) return false;

    return true;
  }

  // 判斷是否為 Random 模式 (決定是否顯示輪盤)
  // 注意：我們依賴的是 Task 設定的規則，而不是是否有 winnerId (因為 S31 寫入後大家都有 winnerId)
  bool get isRandomMode =>
      _task?.remainderRule == RemainderRuleConstants.random;

  // 取得贏家的 ID (從 Snapshot 讀取)
  String? get remainderWinnerId {
    if (_task == null || _task!.settlement == null) return null;
    return _task!.settlement!['remainderWinnerId'] as String?;
  }

  // 取得贏家的詳細物件 (UI 顯示用)
  SettlementMember? get winnerMember {
    if (_task == null || remainderWinnerId == null) return null;
    return _reconstructMember(remainderWinnerId!);
  }

  // 重建所有成員列表 (為了給 D11 Dialog 顯示名單用)
  List<SettlementMember> get allMembers {
    if (_task == null || _task!.settlement == null) return [];

    // 從 Snapshot 讀取 allocations: {'uid': 1050.0, ...}
    final Map<String, dynamic> allocations =
        _task!.settlement!['allocations'] ?? {};

    return allocations.entries.map((entry) {
      return _reconstructMember(entry.key,
          amountOverride: (entry.value as num).toDouble());
    }).toList();
  }

  S32SettlementResultViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required DeepLinkService deepLinkService,
  })  : _taskRepo = taskRepo,
        _deepLinkService = deepLinkService;

  void init() {
    _isLoading = true;
    notifyListeners();

    // 監聽 Task 變化 (通常 S32 進來時資料已經是 settled/pending)
    _taskSubscription = _taskRepo.streamTask(taskId).listen((taskData) {
      _task = taskData;
      _isLoading = false;
      notifyListeners();
    });
  }

  // Private Helper: 將 Task Member 資料與 Snapshot 金額結合成 SettlementMember
  SettlementMember _reconstructMember(String uid, {double? amountOverride}) {
    final memberInfo = _task?.members[uid];
    final snapshotAmount = amountOverride ??
        (_task?.settlement?['allocations']?[uid] as num?)?.toDouble() ??
        0.0;

    return SettlementMember(
      id: uid,
      displayName: memberInfo?['displayName'] ?? 'Unknown',
      avatar: memberInfo?['avatar'],
      isLinked: memberInfo?['isLinked'] ?? false,
      finalAmount: snapshotAmount, // 這裡是重點：顯示最終金額
      baseAmount: 0, // S32 不顯示細節，設為 0 即可
      remainderAmount: 0,
      isRemainderAbsorber: uid == remainderWinnerId,
      isRemainderHidden: false,
    );
  }

  Future<String> generateShareLink() async {
    // 直接呼叫 Service 產生，確保格式跟 _parseUri 對得上
    return _deepLinkService.generateTaskLink(taskId);
  }

  @override
  void dispose() {
    // [修正] 頁面銷毀時，務必取消訂閱！
    _taskSubscription?.cancel();
    super.dispose();
  }
}
