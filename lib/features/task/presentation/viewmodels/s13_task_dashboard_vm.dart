import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/dual_amount.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/constants/currency_constants.dart'; // 新增
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/task/application/dashboard_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/presentation/viewmodels/balance_summary_state.dart';

class S13TaskDashboardViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final RecordRepository _recordRepo;
  final AuthRepository _authRepo;
  final DashboardService _dashboardService;
  final String taskId;
  late final RecordService _recordService;

  String _currentUserId = '';
  TaskModel? _task;
  List<RecordModel> _records = [];
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;

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
  int _segmentedIndex = 0;
  int get segmentedIndex => _segmentedIndex;

  // Personal View 專用 State
  List<RecordModel> _personalRecords = [];
  Map<DateTime, List<RecordModel>> _personalGroupedRecords = {};
  DualAmount _personalNetBalance = DualAmount.zero;
  DualAmount _personalTotalExpense = DualAmount.zero;
  DualAmount _personalTotalPrepay = DualAmount.zero;

  String _remainderRule = RemainderRuleConstants.defaultRule;
  String? _remainderAbsorberId;

  bool get shouldNavigateToS17 => _task?.status == TaskStatus.settled;

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
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
  DualAmount get personalTotalPrepay => _personalTotalPrepay;
  ScrollController get activeScrollController =>
      _segmentedIndex == 0 ? groupScrollController : personalScrollController;
  String get remainderRule => _remainderRule;
  String? get remainderAbsorberId => _remainderAbsorberId;
  Map<String, TaskMember> get membersData => _task?.members ?? {};
  String get currentUserId => _currentUserId;

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
  bool _hasTaskEmitted = false; // Task 流是否已發送過資料
  bool _hasRecordsEmitted = false; // Records 流是否已發送過資料

  // 2. 新增：Page 需要知道是否為隊長
  bool get isCaptain {
    if (_task == null) return false;
    return _task!.createdBy == _currentUserId;
  }

  // 3. 新增：Page 需要知道是否顯示 Intro
  bool get shouldShowIntro {
    if (_task == null) return false;
    final memberData = _task!.members[_currentUserId];
    if (memberData == null) return false;
    final bool hasSeen = memberData.hasSeenRoleIntro;
    return !hasSeen;
  }

  S13TaskDashboardViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required AuthRepository authRepo,
    required RecordRepository recordRepo,
    required DashboardService service,
  })  : _taskRepo = taskRepo,
        _authRepo = authRepo,
        _recordRepo = recordRepo,
        _dashboardService = service {
    _recordService = RecordService(_recordRepo, _taskRepo);
  }

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();
    try {
      // 使用 Repository 獲取當前使用者，不直接存取 FirebaseAuth
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      _currentUserId = user.uid;

      _taskSub = _taskRepo.streamTask(taskId).listen((taskData) {
        if (taskData != null) {
          _task = taskData;
          _remainderRule = taskData.remainderRule;
          _remainderAbsorberId = taskData.remainderAbsorberId;
          _hasTaskEmitted = true;
          _recalculate();
        }
      });

      _recordSub = _recordRepo.streamRecords(taskId).listen((records) {
        _records = records;
        _hasRecordsEmitted = true;
        _recalculate();
      });
    } on AppErrorCodes catch (code) {
      _initStatus = LoadStatus.error;
      _initErrorCode = code;
      notifyListeners();
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = AppErrorCodes.initFailed;
      notifyListeners();
    }
  }

  void _recalculate() {
    if (!_hasTaskEmitted || !_hasRecordsEmitted || _task == null) return;

    // A. 計算 State (Service 現在會用 BalanceCalculator 填好 poolDetail)
    _balanceState = _dashboardService.calculateBalanceState(
      task: _task!,
      records: _records,
      currentUserId: _currentUserId,
    );

    // B. 分組與個人數據
    _groupedRecords = _dashboardService.groupRecordsByDate(_records);
    _personalRecords = _dashboardService.filterPersonalRecords(
        _records, _currentUserId, baseCurrency);
    _personalGroupedRecords =
        _dashboardService.groupRecordsByDate(_personalRecords);
    final personalStats = _dashboardService.calculatePersonalStats(
      _task!.members[_currentUserId],
    );

    _personalTotalExpense = personalStats.expense;
    _personalTotalPrepay = personalStats.prepay;
    _personalNetBalance = personalStats.netBalance;

    // --- Part 3: Date Generation (共用) ---日期處理：處理空值
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);

    var start = _task!.startDate ?? today;
    start = DateTime(start.year, start.month, start.day, 12); // 強制轉為 00:00

    var end = _task!.endDate ?? today.add(const Duration(days: 7));
    end = DateTime(end.year, end.month, end.day, 12); // 強制轉為 00:00

    // 2. 生成日期列表
    final rawDates = _dashboardService.generateDisplayDates(
      startDate: start,
      endDate: end,
      groupedRecords: _groupedRecords,
    );

    // 強制去重複並排序 (由新到舊)
    _displayDates = rawDates
        .map((d) => DateTime(d.year, d.month, d.day, 12)) // 去除時間成分
        .toSet() // 去重複
        .toList()
      ..sort((a, b) => b.compareTo(a));

    // Key 生成
    for (var date in _displayDates) {
      final keyStr = DateFormat('yyyyMMdd').format(date);
      if (!_dateKeys.containsKey(keyStr)) {
        _dateKeys[keyStr] = GlobalKey();
      }
    }

    // Auto Scroll
    if (_initStatus == LoadStatus.loading) {
      checkInitialScroll();
    }

    _initStatus = LoadStatus.success;
    notifyListeners();
  }

  // 切換 Tab 時，強制 Reset 到「今天」
  void setSegmentedIndex(int index) {
    if (_segmentedIndex == index) return;
    _segmentedIndex = index;
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
    final targetDate =
        _dashboardService.calculateInitialTargetDate(startDate, endDate);

    // 標記該 Tab 已捲動過 (避免之後 _recalculate 重複觸發)
    if (_segmentedIndex == 0) _hasScrolledGroup = true;
    if (_segmentedIndex == 1) _hasScrolledPersonal = true;

    // 執行跳轉
    scrollRecord(targetDate);
  }

  // 新增：檢查並執行自動捲動
  void checkInitialScroll() {
    if (_task == null || _displayDates.isEmpty) return;

    final startDate = _task!.startDate ?? DateTime.now();
    final endDate =
        _task!.endDate ?? DateTime.now().add(const Duration(days: 7));
    final targetDate =
        _dashboardService.calculateInitialTargetDate(startDate, endDate);

    if (_segmentedIndex == 0 && !_hasScrolledGroup) {
      _hasScrolledGroup = true;
      // 延遲一點點確保 Key 已經掛載到 Widget Tree
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollRecord(targetDate);
      });
    } else if (_segmentedIndex == 1 && !_hasScrolledPersonal) {
      _hasScrolledPersonal = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollRecord(targetDate);
      });
    }
  }

  Future<void> scrollRecord(DateTime date, {VoidCallback? onNoResult}) async {
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
          // 使用 activeScrollController
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
          membersData[newAbsorberId]?.displayName ?? 'Unknown Member';
      logDetails['absorberName'] = memberName;
    }

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: logDetails,
    );
  }

  /// 刪除消費紀錄
  Future<void> deleteRecord(String recordId) async {
    try {
      final record = _records.firstWhere(
        (r) => r.id == recordId,
        // [修正] 使用標準錯誤代碼
        orElse: () => throw AppErrorCodes.dataNotFound,
      );

      await _recordService.validateAndDelete(taskId, record, poolBalances);

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
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  Future<void> lockTaskAndStartSettlement() async {
    try {
      // 1. 鎖定房間 (ongoing -> pending)
      await _taskRepo.updateTaskStatus(taskId, 'pending');
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  DualAmount getPersonalRecordDisplayAmount(RecordModel record) {
    if (record.type == RecordType.prepay) {
      return BalanceCalculator.calculatePersonalCredit(
          record, _currentUserId, baseCurrency);
    } else {
      return BalanceCalculator.calculatePersonalDebit(
          record, _currentUserId, baseCurrency);
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
