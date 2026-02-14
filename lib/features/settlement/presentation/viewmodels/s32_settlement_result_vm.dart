// lib/features/settlement/presentation/viewmodels/s32_settlement_result_vm.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S32SettlementResultViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;
  final DeepLinkService _deepLinkService;
  final SettlementService _settlementService;
  final ShareService _shareService;

  TaskModel? _task;
  bool _isLoading = true;

  StreamSubscription? _taskSubscription;
  bool _hasmarkedAsSeen = false;

  // Getters
  bool get isLoading => _isLoading;
  TaskModel? get task => _task;

  // 從 Task 中取得 Base Currency
  CurrencyConstants get baseCurrency {
    if (_task == null) return CurrencyConstants.defaultCurrencyConstants;
    return CurrencyConstants.getCurrencyConstants(_task!.baseCurrency);
  }

  String get link => _deepLinkService.generateTaskLink(taskId);

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
    required SettlementService settlementService,
    required ShareService shareService,
  })  : _taskRepo = taskRepo,
        _deepLinkService = deepLinkService,
        _settlementService = settlementService,
        _shareService = shareService;

  void init() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    _isLoading = true;
    notifyListeners();

    // 監聽 Task 變化 (通常 S32 進來時資料已經是 settled/pending)
    _taskSubscription = _taskRepo.streamTask(taskId).listen((taskData) {
      _task = taskData;
      _isLoading = false;
      notifyListeners();
      _autoMarkAsSeen(uid);
    });
  }

  void _autoMarkAsSeen(String uid) {
    debugPrint('uid: $uid');
    // 如果已經標記過，或者資料還沒準備好，就跳過
    debugPrint('_hasmarkedAsSeen: $_hasmarkedAsSeen');
    if (_hasmarkedAsSeen || _task == null || _task!.settlement == null) return;

    final viewStatus =
        _task!.settlement!['viewStatus'] as Map<String, dynamic>? ?? {};

    debugPrint('viewStatus: $viewStatus');

    debugPrint('viewStatus[uid]: ${viewStatus[uid]}');

    // 如果目前雲端紀錄我還沒看過
    if (viewStatus[uid] != true) {
      _hasmarkedAsSeen = true; // 先設為 true，防止串流多次觸發
      markAsSeen(uid);
    }
  }

  Future<void> markAsSeen(String uid) async {
    try {
      await _settlementService.markSettlementAsSeen(
        taskId: taskId,
        memberId: uid,
      );
    } catch (e) {
      _hasmarkedAsSeen = false; // 萬一失敗，允許下次重試
      debugPrint('S32 MarkAsSeen Failed: $e');
    }
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

  /// 通知成員 (純文字分享)
  Future<void> notifyMembers(
      {required String message, required String subject}) async {
    await _shareService.shareText(message, subject: subject);
  }

  @override
  void dispose() {
    // [修正] 頁面銷毀時，務必取消訂閱！
    _taskSubscription?.cancel();
    super.dispose();
  }
}
