import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

enum LockedPageType { closed, settled }

class S17TaskLockedViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;
  final ExportService _exportService;
  final ShareService _shareService;
  final DeepLinkService _deepLinkService;
  final SettlementService _settlementService;
  final String taskId;

  StreamSubscription? _taskSubscription;

  // UI State
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LockedPageType _pageType = LockedPageType.closed;
  String _taskName = '';

  TaskModel? _task;
  String _currentUserId = '';
  bool _isWritingStatus = false;

  // S17 Pending View 需要的資料
  bool _isCaptain = false;
  CurrencyConstants _baseCurrency = CurrencyConstants.defaultCurrencyConstants;
  BalanceSummaryState? _balanceState;
  List<SettlementMember> _pendingMembers = [];
  List<SettlementMember> _clearedMembers = [];
  int? _remainingDays;
  LoadStatus _exportStatus = LoadStatus.initial;
  LoadStatus _shareStatus = LoadStatus.initial;

  // Getters
  LockedPageType get pageType => _pageType;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String get taskName => _taskName;
  bool get isCaptain => _isCaptain;
  CurrencyConstants get baseCurrency => _baseCurrency;
  BalanceSummaryState? get balanceState => _balanceState;
  List<SettlementMember> get pendingMembers => _pendingMembers;
  List<SettlementMember> get clearedMembers => _clearedMembers;
  int? get remainingDays => _remainingDays;
  TaskModel? get task => _task;
  String get currentUserId => _currentUserId;
  bool get hasSeen =>
      _task?.settlement?['viewStatus']?[_currentUserId] ?? false;
  LoadStatus get exportStatus => _exportStatus;
  LoadStatus get shareStatus => _shareStatus;
  String get link => _deepLinkService.generateTaskLink(taskId);

  bool get shouldShowRoulette {
    if (_task == null || _task!.settlement == null) return false;
    // 1. 基本門檻：必須是隨機模式
    if (_task?.remainderRule != RemainderRuleConstants.random) return false;

    if (hasSeen == true) return false;

    // 金額為 0，不顯示動畫
    if (snapshotMap == null) return false;
    final snapshotRemainder =
        (snapshotMap?['remainder'] as num?)?.toDouble() ?? 0.0;
    if (snapshotRemainder.abs() < 0.001) {
      return false;
    }

    // 3. (可選) 檢查是否有贏家 ID (雙重確認)
    // 理論上金額不為 0 就應該要有贏家，這行是防呆
    final winnerId = _task!.settlement!['remainderWinnerId'] as String?;
    if (winnerId == null || winnerId.isEmpty) return false;

    return true;
  }

  Map<String, dynamic>? get snapshotMap =>
      _task!.settlement!['dashboardSnapshot'] as Map<String, dynamic>?;

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

  Future<void> markCurrentUserAsSeen() async {
    if (_isWritingStatus) return;
    final user = _authRepo.currentUser;
    if (user == null) return;

    _isWritingStatus = true;

    try {
      await _settlementService.markSettlementAsSeen(
        taskId: taskId,
        memberId: user.uid,
      );
    } catch (e) {
      _isWritingStatus = false;
    }
  }

  S17TaskLockedViewModel({
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required AuthRepository authRepo,
    required ExportService exportService,
    required ShareService shareService,
    required DeepLinkService deepLinkService,
    required SettlementService settlementService,
    required this.taskId,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo,
        _exportService = exportService,
        _shareService = shareService,
        _deepLinkService = deepLinkService,
        _settlementService = settlementService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();
    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      _currentUserId = user.uid;

      _taskSubscription = _taskRepo.streamTask(taskId).listen((task) {
        try {
          if (task == null) throw AppErrorCodes.dataNotFound;
          _task = task;
          _taskName = task.name;

          _determineStatusAndParseData(task);

          // 只有成功解析完資料才設為 success
          _initStatus = LoadStatus.success;
          notifyListeners();
        } on AppErrorCodes catch (code) {
          _initStatus = LoadStatus.error;
          _initErrorCode = code;
          notifyListeners();
        } catch (e) {
          _initStatus = LoadStatus.error;
          _initErrorCode = ErrorMapper.parseErrorCode(e);
          notifyListeners();
        }
      }, onError: (e) {
        _initStatus = LoadStatus.error;
        _initErrorCode = ErrorMapper.parseErrorCode(e);
        notifyListeners();
      });
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

  SettlementMember _reconstructMember(String uid, {double? amountOverride}) {
    final memberData = _task?.members[uid] ??
        TaskMember(
          id: uid,
          displayName: 'Unknown Member', // 或使用多國語系字串
          isLinked: false,
          role: 'member',
          joinedAt: DateTime.now(), // 這裡只是為了符合建構子，UI 結算頁面用不到
          createdAt: DateTime.now(),
        );
    final snapshotAmount = amountOverride ??
        (_task?.settlement?['allocations']?[uid] as num?)?.toDouble() ??
        0.0;

    return SettlementMember(
      memberData: memberData,
      finalAmount: snapshotAmount, // 這裡是重點：顯示最終金額
      baseAmount: 0, // S32 不顯示細節，設為 0 即可
      remainderAmount: 0,
      isRemainderAbsorber: uid == remainderWinnerId,
      isRemainderHidden: false,
    );
  }

  void _determineStatusAndParseData(TaskModel task) {
    final isClosed = _task!.status == TaskStatus.closed;
    final isSettled = _task!.status == TaskStatus.settled;

    if (!isClosed && !isSettled) {
      throw AppErrorCodes.taskStatusError;
    }

    // 1. 決定大狀態
    _pageType = isClosed ? LockedPageType.closed : LockedPageType.settled;

    final settlement = task.settlement ?? {};
    final finalizedDate = task.finalizedAt;
    _calculateRemainingDays(finalizedDate);

    _baseCurrency = CurrencyConstants.getCurrencyConstants(task.baseCurrency);
    _isCaptain = task.createdBy == currentUserId;

    // 2. 如果是 Pending，進行資料解析 (原本在 Page 裡的邏輯)
    _pageType = LockedPageType.settled;
    _parsePendingData(task, settlement);
  }

  void _calculateRemainingDays(DateTime? finalizedDate) {
    if (finalizedDate == null) {
      _remainingDays = null;
      return;
    }
    final deadlineDate = finalizedDate.add(const Duration(days: 30));
    final now = DateTime.now();
    final difference = deadlineDate.difference(now).inDays;

    // 如果 difference < 0 代表已過期，這裡取 max(0, diff) 防止負數
    _remainingDays = difference < 0 ? 0 : difference;
  }

  void _parsePendingData(TaskModel task, Map<String, dynamic> settlement) {
    // A. 解析餘額得主

    String? remainderWinnerName;
    final winner = task.members[remainderWinnerId];
    if (winner != null) remainderWinnerName = winner.displayName;

    if (snapshotMap != null) {
      // 1. 還原
      final loadedState = BalanceSummaryState.fromMap(snapshotMap!);

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
        memberData: memberData,
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

  Future<void> exportSettlementRecord({
    required String fileName,
    required String subject,
    required Map<String, String> labels,
  }) async {
    if (_task == null || _balanceState == null) return;
    if (_exportStatus == LoadStatus.loading) return;

    _exportStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 登入檢查
      if (_authRepo.currentUser == null) throw AppErrorCodes.unauthorized;

      // 2. 抓取 Records (Repository)
      final List<RecordModel> records =
          await _recordRepo.getRecordsOnce(taskId);
      records.sort((a, b) => b.date.compareTo(a.date));

      // 3. 產生 CSV 內容 (業務 Service - TaskExportService)
      final csvContent = _exportService.generateProfessionalSettlementCsv(
        records: records,
        taskName: _taskName,
        baseCurrency: _baseCurrency,
        allMembers: [..._pendingMembers, ..._clearedMembers],
        clearedMembers: _clearedMembers,
        totalExpense: _balanceState!.totalExpense,
        totalPrepay: _balanceState!.totalPrepay,
        remainderBuffer: BalanceCalculator.calculateRemainderBuffer(records),
        absorbedBy: _balanceState!.absorbedBy,
        labels: labels,
        taskMembers: _task!.members,
      );

      // 4. 分享檔案 (基礎 Service - ShareService)
      await _shareService.shareFile(
        content: csvContent,
        fileName: fileName,
        subject: subject,
      );

      _exportStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _exportStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _exportStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> toggleMemberStatus(String memberId, bool isCleared) async {
    try {
      await _settlementService.updateMemberStatus(
        taskId: taskId,
        memberId: memberId,
        isCleared: isCleared, // 傳入 true 變為已處理，false 變回待處理
      );
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  /// 通知成員 (純文字分享)
  Future<void> notifyMembers(
      {required String message, required String subject}) async {
    if (_shareStatus == LoadStatus.loading) return;
    _shareStatus = LoadStatus.loading;
    notifyListeners();
    try {
      await _shareService.shareText(message, subject: subject);
      _shareStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _shareStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _shareStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  @override
  void dispose() {
    // [修正] 頁面銷毀時，務必取消訂閱！
    _taskSubscription?.cancel();
    super.dispose();
  }
}
