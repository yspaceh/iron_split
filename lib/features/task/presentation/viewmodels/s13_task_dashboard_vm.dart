import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart'; // 新增
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class S13TaskDashboardViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final DashboardService _service;
  final String taskId;
  final String currentUserId;

  TaskModel? _task;
  List<RecordModel> _records = [];
  bool _isLoading = true;

  BalanceSummaryState _balanceState = BalanceSummaryState.initial();
  Map<DateTime, List<RecordModel>> _groupedRecords = {};
  List<DateTime> _displayDates = [];

  // Scroll State
  final Map<String, GlobalKey> _dateKeys = {};
  DateTime _selectedDateInStrip = DateTime.now();
// 新增：分離的 Controllers (這樣切換 Tab 可以保留各自的進度)
  final ScrollController groupScrollController = ScrollController();
  final ScrollController personalScrollController = ScrollController();

  // 新增：分離的旗標 (各自記錄是否已經自動跳轉過)
  bool _hasScrolledGroup = false;
  bool _hasScrolledPersonal = false;

// 新增：當前 Tab 索引 (0: Group, 1: Personal)
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  // Personal View 專用 State
  List<RecordModel> _personalRecords = [];
  Map<DateTime, List<RecordModel>> _personalGroupedRecords = {};
  DualAmount _personalNetBalance = DualAmount.zero;
  DualAmount _personalTotalExpense = DualAmount.zero;
  DualAmount _personalTotalIncome = DualAmount.zero;

  String _remainderRule = RemainderRuleConstants.defaultRule;
  String? _remainderAbsorberId;

  // Getters
  bool get isLoading => _isLoading;
  TaskModel? get task => _task;
  BalanceSummaryState get balanceState => _balanceState;
  Map<DateTime, List<RecordModel>> get groupedRecords => _groupedRecords;
  List<DateTime> get displayDates => _displayDates;
  Map<String, GlobalKey> get dateKeys => _dateKeys;
  DateTime get selectedDateInStrip => _selectedDateInStrip;
  List<RecordModel> get personalRecords => _personalRecords;
  Map<DateTime, List<RecordModel>> get personalGroupedRecords =>
      _personalGroupedRecords;
  DualAmount get personalNetBalance => _personalNetBalance;
  DualAmount get personalTotalExpense => _personalTotalExpense;
  DualAmount get personalTotalIncome => _personalTotalIncome;
  ScrollController get activeScrollController =>
      _currentTabIndex == 0 ? groupScrollController : personalScrollController;
  String get remainderRule => _remainderRule;
  String? get remainderAbsorberId => _remainderAbsorberId;
  Map<String, dynamic> get membersData => _task?.members ?? {};

  // 新增：為了支援 UI 顯示 Currency Symbol
  CurrencyConstants get baseCurrency {
    if (_task == null) {
      return CurrencyConstants.defaultCurrencyConstants; // Default
    }
    return CurrencyConstants.getCurrencyConstants(_task!.baseCurrency);
  }

  // 新增：為了支援 RecordBlock (暫時給空值或從 State 拿)
  Map<String, double> get poolBalances => _balanceState.poolDetail;

  StreamSubscription? _taskSub;
  StreamSubscription? _recordSub;

  // 2. 新增：Page 需要知道是否為隊長
  bool get isCaptain {
    if (_task == null) return false;
    return _task!.createdBy == currentUserId;
  }

  // 3. 新增：Page 需要知道是否顯示 Intro
  bool get shouldShowIntro {
    if (_task == null) return false;
    final memberData = _task!.members[currentUserId];
    if (memberData == null) return false;
    final bool hasSeen = memberData['hasSeenRoleIntro'] ?? true;
    return !hasSeen;
  }

  S13TaskDashboardViewModel({
    required this.taskId,
    required this.currentUserId,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required DashboardService service,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _service = service;

  void init() {
    _isLoading = true;
    notifyListeners();

    _taskSub = _taskRepo.streamTask(taskId).listen((taskData) {
      if (taskData != null) {
        _task = taskData;
        _remainderRule = taskData.remainderRule;
        _remainderAbsorberId = taskData.remainderAbsorberId;
        _recalculate();
      }
    });

    _recordSub = _recordRepo.streamRecords(taskId).listen((records) {
      _records = records;
      _recalculate();
    });
  }

  void _recalculate() {
    if (_task == null) return;

    // A. 計算 State (Service 現在會用 BalanceCalculator 填好 poolDetail)
    _balanceState = _service.calculateBalanceState(
      task: _task!,
      records: _records,
      currentUserId: currentUserId,
    );

    // B. 分組與個人數據
    _groupedRecords = _service.groupRecordsByDate(_records);
    _personalRecords =
        _service.filterPersonalRecords(_records, currentUserId, baseCurrency);
    _personalGroupedRecords = _service.groupRecordsByDate(_personalRecords);
    _personalNetBalance = _service.calculatePersonalNetBalance(
        allRecords: _records, uid: currentUserId, baseCurrency: baseCurrency);
    _personalTotalExpense = _service.calculatePersonalDebit(
        allRecords: _records, uid: currentUserId, baseCurrency: baseCurrency);
    _personalTotalIncome = _service.calculatePersonalCredit(
        allRecords: _records, uid: currentUserId, baseCurrency: baseCurrency);

    // --- Part 3: Date Generation (共用) ---日期處理：處理空值
    final startDate = _task!.startDate ?? DateTime.now();
    final endDate =
        _task!.endDate ?? DateTime.now().add(const Duration(days: 7));

    // 注意：Personal View 的日期列表可能跟 Group 不一樣嗎？
    // 依據原本代碼：_generateFullDateRangeDescending 邏輯是一樣的，
    // 但 uniqueDates 是合併 _personalRecords 的日期。
    // 如果我們想讓兩個 Tab 的 Scroll 行為一致 (切換 Tab 不會跳來跳去)，
    // 通常建議共用 displayDates。
    // 但原本代碼是分開算的。為了完全還原，我們這裡可以共用 displayDates
    // (因為它是 full range + any record date)，只要 Group View 的日期比 Personal 多就沒問題。
    // 這裡我們暫時共用 _displayDates，因為它是 "Full Range" + "All Records"，
    // 肯定包含 "Personal Records" 的日期。
    _displayDates = _service.generateDisplayDates(
      startDate: startDate,
      endDate: endDate,
      groupedRecords: _groupedRecords, // 用全部紀錄產生的 group 來補日期，範圍最大
    );

    // Key 生成
    for (var date in _displayDates) {
      final keyStr = DateFormat('yyyyMMdd').format(date);
      if (!_dateKeys.containsKey(keyStr)) {
        _dateKeys[keyStr] = GlobalKey();
      }
    }

    // Auto Scroll
    if (!_isLoading) {
      checkInitialScroll();
    }

    _isLoading = false;
    notifyListeners();
  }

  // 切換 Tab 時，強制 Reset 到「今天」
  void setTabIndex(int index) {
    if (_currentTabIndex == index) return;
    _currentTabIndex = index;
    notifyListeners();

    // 使用 addPostFrameCallback 確保 UI 已經切換完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 強制跳轉，不檢查 _hasScrolled 旗標
      _forceScrollToDefaultDate();
    });
  }

  // 新增：強制捲動到預設日期 (給 Tab 切換用)
  void _forceScrollToDefaultDate() {
    if (_task == null || _displayDates.isEmpty) return;

    final startDate = _task!.startDate ?? DateTime.now();
    final endDate =
        _task!.endDate ?? DateTime.now().add(const Duration(days: 7));
    // 計算目標日期 (今天 或 開始日)
    final targetDate = _service.calculateInitialTargetDate(startDate, endDate);

    // 標記該 Tab 已捲動過 (避免之後 _recalculate 重複觸發)
    if (_currentTabIndex == 0) _hasScrolledGroup = true;
    if (_currentTabIndex == 1) _hasScrolledPersonal = true;

    // 執行跳轉
    handleDateJump(targetDate);
  }

  // 新增：檢查並執行自動捲動
  void checkInitialScroll() {
    if (_task == null || _displayDates.isEmpty) return;

    final startDate = _task!.startDate ?? DateTime.now();
    final endDate =
        _task!.endDate ?? DateTime.now().add(const Duration(days: 7));
    final targetDate = _service.calculateInitialTargetDate(startDate, endDate);

    if (_currentTabIndex == 0 && !_hasScrolledGroup) {
      _hasScrolledGroup = true;
      // 延遲一點點確保 Key 已經掛載到 Widget Tree
      Future.delayed(const Duration(milliseconds: 100), () {
        handleDateJump(targetDate);
      });
    } else if (_currentTabIndex == 1 && !_hasScrolledPersonal) {
      _hasScrolledPersonal = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        handleDateJump(targetDate);
      });
    }
  }

  Future<void> handleDateJump(DateTime date, {VoidCallback? onNoResult}) async {
    _selectedDateInStrip = date;
    notifyListeners();

    final keyStr = DateFormat('yyyyMMdd').format(date);

    // 這裡保留您提供的重試邏輯
    void attemptScroll([int attempt = 0]) {
      final key = _dateKeys[keyStr];
      final context = key?.currentContext;

      if (context != null) {
        final renderObject = context.findRenderObject();
        if (renderObject != null) {
          final viewport = RenderAbstractViewport.of(renderObject);
          final revealedOffset =
              viewport.getOffsetToReveal(renderObject, 0.0).offset;
          // ✅ 使用 activeScrollController
          if (activeScrollController.hasClients) {
            activeScrollController.animateTo(
              revealedOffset.clamp(
                  0.0, activeScrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        }
      } else {
        if (attempt < 5) {
          Future.delayed(const Duration(milliseconds: 50),
              () => attemptScroll(attempt + 1));
        } else {
          if (onNoResult != null) onNoResult();
        }
      }
    }

    attemptScroll();
  }

  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    // 1. 樂觀更新
    _remainderRule = newRule;
    _remainderAbsorberId = newAbsorberId;
    notifyListeners();

    // 2. 準備資料
    final Map<String, dynamic> updateData = {
      'remainderRule': newRule,
      'remainderAbsorberId':
          newRule == RemainderRuleConstants.member ? newAbsorberId : null,
    };

    // 3. 使用 Repository
    await _taskRepo.updateTask(taskId, updateData);

    // 4. Log
    Map<String, dynamic> logDetails = {
      'settingType': 'remainder_rule',
      'newValue': newRule,
    };

    if (newRule == RemainderRuleConstants.member && newAbsorberId != null) {
      final memberName =
          membersData[newAbsorberId]?['displayName'] ?? 'Unknown';
      logDetails['absorberName'] = memberName;
    }

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: logDetails,
    );
  }

  /// 刪除消費紀錄
  Future<bool> deleteRecord(String recordId) async {
    try {
      final record = _records.firstWhere(
        (r) => r.id == recordId,
        // [修正] 使用標準錯誤代碼
        orElse: () => throw Exception(AppErrorCodes.recordNotFound),
      );

      // 如果是收入/預收 (Income)，必須檢查相依性與餘額
      if (record.type == 'income') {
        // A. 檢查是否被其他紀錄引用 (payerId)
        final isReferenced =
            await _recordRepo.isRecordReferenced(taskId, recordId);
        if (isReferenced) return false;

        // B. 檢查餘額 (Pool Balance)
        // 如果刪除這筆收入，餘額是否會變成負數？
        // poolBalances 是當前餘額 (包含此筆收入)
        final currentBalance = poolBalances[record.currencyCode] ?? 0.0;

        // 如果當前餘額小於此筆收入金額 (容許 0.01 誤差)，代表錢已經花掉了
        if (currentBalance < (record.amount - 0.01)) {
          return false;
        }
      }

      // 2. 呼叫 Repository 執行刪除
      await _recordRepo.deleteRecord(taskId, recordId);

      // 3. 寫入 Activity Log
      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.deleteRecord,
        details: {
          'recordName': record.title,
          'amount': record.amount,
          'currency': record.currencyCode, // 注意：Model 的欄位是 currencyCode
        },
      );
      return true;
    } catch (e) {
      // TODO: handle error
      rethrow; // 拋出異常，讓 UI 層 (RecordItem) 可以顯示 SnackBar 錯誤訊息
    }
  }

  Future<bool> lockTaskAndStartSettlement() async {
    try {
      // 1. 鎖定房間 (ongoing -> pending)
      await _taskRepo.updateTaskStatus(taskId, 'pending');
      return true;
    } catch (e) {
      // TODO: handle error
      return false;
    }
  }

  @override
  void dispose() {
    _taskSub?.cancel();
    _recordSub?.cancel();
    groupScrollController.dispose();
    personalScrollController.dispose();
    super.dispose();
  }
}
