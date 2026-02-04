import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

// 定義頁面狀態，讓 Page 只要 switch 這個就好
enum LockedPageStatus { loading, closed, cleared, pending, error }

class S17TaskLockedViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;
  final String currentUserId;

  // UI State
  LockedPageStatus _status = LockedPageStatus.loading;
  String _taskName = '';

  TaskModel? _task;

  // S17 Pending View 需要的資料
  bool _isCaptain = false;
  CurrencyConstants _baseCurrency = CurrencyConstants.defaultCurrencyConstants;
  BalanceSummaryState? _balanceState;
  List<SettlementMember> _pendingMembers = [];
  List<SettlementMember> _clearedMembers = [];
  int? _remainingDays;

  // Getters
  LockedPageStatus get status => _status;
  String get taskName => _taskName;
  bool get isCaptain => _isCaptain;
  CurrencyConstants get baseCurrency => _baseCurrency;
  BalanceSummaryState? get balanceState => _balanceState;
  List<SettlementMember> get pendingMembers => _pendingMembers;
  List<SettlementMember> get clearedMembers => _clearedMembers;
  int? get remainingDays => _remainingDays;
  TaskModel? get task => _task;

  S17TaskLockedViewModel({
    required TaskRepository taskRepo,
    required this.taskId,
  })  : _taskRepo = taskRepo,
        currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '' {
    _init();
  }

  void _init() {
    _taskRepo.streamTask(taskId).listen((task) {
      if (task == null) {
        _status = LockedPageStatus.error;
        notifyListeners();
        return;
      }

      _task = task;

      _taskName = task.name;
      _baseCurrency = CurrencyConstants.getCurrencyConstants(task.baseCurrency);
      _isCaptain = task.createdBy == currentUserId;

      _determineStatusAndParseData(task);
      notifyListeners();
    });
  }

  void _determineStatusAndParseData(TaskModel task) {
    // 1. 決定大狀態
    if (task.status == 'closed') {
      _status = LockedPageStatus.closed;
      return;
    }

    final settlement = task.settlement ?? {};
    final settlementStatus = settlement['status'] as String? ?? 'pending';
    final finalizedAtRaw = settlement['finalizedAt'];

    if (finalizedAtRaw != null && finalizedAtRaw is Timestamp) {
      final finalizedDate = finalizedAtRaw.toDate();
      final deadlineDate = finalizedDate.add(const Duration(days: 30));
      final now = DateTime.now();

      // 計算差異天數 (只要還有時間都算 1 天，除非過期)
      final difference = deadlineDate.difference(now).inDays;

      // 如果 difference < 0 代表已過期，這裡取 max(0, diff) 防止負數
      _remainingDays = difference < 0 ? 0 : difference;
    } else {
      // 如果沒有結算時間 (舊資料)，給個預設值或不顯示
      _remainingDays = null;
    }

    if (task.status == 'settled' && settlementStatus == 'cleared') {
      _status = LockedPageStatus.cleared;
      return;
    }

    // 2. 如果是 Pending，進行資料解析 (原本在 Page 裡的邏輯)
    _status = LockedPageStatus.pending;
    _parsePendingData(task, settlement);
  }

  void _parsePendingData(TaskModel task, Map<String, dynamic> settlement) {
    // A. 解析餘額得主
    final remainderWinnerId = settlement['remainderWinnerId'] as String?;
    String? remainderWinnerName;
    if (remainderWinnerId != null) {
      final winner = task.members[remainderWinnerId];
      if (winner != null) remainderWinnerName = winner['displayName'];
    }

    // 嘗試從 dashboardSnapshot 讀取，如果沒有(舊資料)則 fallback 到初始狀態
    final snapshotMap =
        settlement['dashboardSnapshot'] as Map<String, dynamic>?;

    if (snapshotMap != null) {
      // 1. 還原
      final loadedState = BalanceSummaryState.fromMap(snapshotMap);

      // 2. 覆蓋 (Override) S17 專屬設定
      // 雖然 Snapshot 裡可能已存了 locked=true，但為了保險起見我們再次強制鎖定
      // 並且使用最新的 member name (防止結算後有人改名，導致顯示舊名字)
      _balanceState = loadedState.copyWith(
        isLocked: true,
        absorbedBy: remainderWinnerName,
      );
    } else {
      // Fallback: 針對舊資料的防呆 (顯示全 0)
      _balanceState = BalanceSummaryState.initial().copyWith(
        currencyCode: task.baseCurrency,
        currencySymbol: _baseCurrency.symbol,
        isLocked: true,
        absorbedBy: remainderWinnerName,
      );
    }

    // C. 解析成員列表
    final allocations =
        Map<String, dynamic>.from(settlement['allocations'] ?? {});
    final memberStatus =
        Map<String, dynamic>.from(settlement['memberStatus'] ?? {});

    _pendingMembers = [];
    _clearedMembers = [];

    allocations.forEach((uid, amountRaw) {
      final memberData = task.members[uid];
      if (memberData == null) return;

      final double amount = (amountRaw as num).toDouble();
      final bool isCleared = memberStatus[uid] == true;

      final member = SettlementMember(
        id: uid,
        displayName: memberData['displayName'] ?? 'Unknown',
        avatar: memberData['avatar'],
        isLinked: memberData['isLinked'] ?? false,
        finalAmount: amount,
        baseAmount: amount,
        remainderAmount: 0,
        isRemainderAbsorber: uid == remainderWinnerId,
        isRemainderHidden: false,
      );

      if (isCleared) {
        _clearedMembers.add(member);
      } else {
        _pendingMembers.add(member);
      }
    });

    // 排序
    _pendingMembers
        .sort((a, b) => b.finalAmount.abs().compareTo(a.finalAmount.abs()));
    _clearedMembers
        .sort((a, b) => b.finalAmount.abs().compareTo(a.finalAmount.abs()));
  }
}
