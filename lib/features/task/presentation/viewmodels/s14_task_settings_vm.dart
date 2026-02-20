import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S14TaskSettingsViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final AuthRepository _authRepo;
  final RecordRepository _recordRepo;
  final InviteRepository _inviteRepo;
  final ShareService _shareService;
  final DeepLinkService _deepLinkService;
  final String taskId;

  // UI State
  TextEditingController nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  CurrencyConstants? _currency;
  String _remainderRule = RemainderRuleConstants.defaultRule;
  String? _remainderAbsorberId;

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _inviteMemberStatus = LoadStatus.initial;
  LoadStatus _updateNameStatus = LoadStatus.initial;
  LoadStatus _updateDateRangeStatus = LoadStatus.initial;
  LoadStatus _updateRemainderStatus = LoadStatus.initial;
  String inviteCode = '';
  // Logic Helper
  String? _initialName;
  String? _createdBy;
  Map<String, TaskMember> _membersData = {};

  double _currentRemainder = 0.0;

  // Getters
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  CurrencyConstants? get currency => _currency;
  String get remainderRule => _remainderRule;
  String? get remainderAbsorberId => _remainderAbsorberId;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  Map<String, TaskMember> get membersData => _membersData;
  double get currentRemainder => _currentRemainder;
  LoadStatus get inviteMemberStatus => _inviteMemberStatus;
  LoadStatus get updateNameStatus => _updateNameStatus;
  LoadStatus get updateDateRangeStatus => _updateDateRangeStatus;
  LoadStatus get updateRemainderStatus => _updateRemainderStatus;

  String get link => _deepLinkService.generateJoinLink(inviteCode);

  List<TaskMember> get membersList {
    return _membersData.entries.map((m) => m.value).toList();
  }

  bool get isOwner {
    final currentUid = _authRepo.currentUser?.uid;
    return currentUid != null && currentUid == _createdBy;
  }

  S14TaskSettingsViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required RecordRepository recordRepo,
    required AuthRepository authRepo,
    required InviteRepository inviteRepo,
    required DeepLinkService deepLinkService,
    required ShareService shareService,
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo,
        _inviteRepo = inviteRepo,
        _deepLinkService = deepLinkService,
        _shareService = shareService;

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      final task = await _taskRepo.streamTask(taskId).first;
      if (task == null) throw AppErrorCodes.dataNotFound;

      nameController.text = task.name;
      _initialName = task.name;

      _startDate = task.startDate;
      _endDate = task.endDate;
      _currency = CurrencyConstants.getCurrencyConstants(task.baseCurrency);

      _remainderRule = task.remainderRule;
      _remainderAbsorberId = task.remainderAbsorberId;

      _createdBy = task.createdBy;
      _membersData = task.members;

      final records = await _recordRepo.getRecordsOnce(taskId);
      _currentRemainder = BalanceCalculator.calculateRemainderBuffer(records);

      if (_startDate == null || _endDate == null || _currency == null) {
        throw AppErrorCodes.initFailed;
      }

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
  }

  // --- Actions ---

  Future<void> updateName() async {
    if (_updateNameStatus == LoadStatus.loading) return;
    _updateNameStatus = LoadStatus.loading;
    notifyListeners();

    final newName = nameController.text.trim();
    if (newName.isEmpty || newName == _initialName) return;
    try {
      _initialName = newName;

      await _taskRepo.updateTask(taskId, {'name': newName});

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.updateSettings,
        details: {
          'settingType': 'task_name',
          'newValue': newName,
        },
      );
      _updateNameStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _updateNameStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _updateNameStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    if (_updateDateRangeStatus == LoadStatus.loading) return;
    _updateDateRangeStatus = LoadStatus.loading;
    notifyListeners();

    try {
      //  核心防呆邏輯
      // 如果「開始日」跑到了「結束日」後面，就強制把「結束日」拉過來跟「開始日」同一天
      if (start.isAfter(end)) {
        end = start;
      }

      _startDate = start;
      _endDate = end;

      await _taskRepo.updateTask(taskId, {
        'startDate': start,
        'endDate': end, // 這裡會自動存入修正後的 end
      });

      // Log 也會紀錄修正後的日期
      final dateStr =
          "${DateFormat('yyyy/MM/dd').format(start)} - ${DateFormat('yyyy/MM/dd').format(end)}";

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.updateSettings,
        details: {
          'settingType': 'date_range',
          'newValue': dateStr,
        },
      );
      _updateDateRangeStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _updateDateRangeStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _updateDateRangeStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  /// 更新餘額處理規則
  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    if (_updateRemainderStatus == LoadStatus.loading) return;
    _updateRemainderStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 1. 樂觀更新
      _remainderRule = newRule;
      _remainderAbsorberId = newAbsorberId;

      // 2. 準備資料
      final Map<String, dynamic> updateData = {
        'remainderRule': newRule,
        'remainderAbsorberId':
            newRule == RemainderRuleConstants.member ? newAbsorberId : null,
      };

      await _taskRepo.updateTask(taskId, updateData);

      // 4. Activity Log
      Map<String, dynamic> logDetails = {
        'settingType': 'remainder_rule',
        'newValue': newRule,
      };

      if (newRule == RemainderRuleConstants.member && newAbsorberId != null) {
        final memberName =
            _membersData[newAbsorberId]?.displayName ?? 'Unknown Member';
        logDetails['absorberName'] = memberName;
      }

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.updateSettings,
        details: logDetails,
      );
      _updateRemainderStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _updateRemainderStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _updateRemainderStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  void updateCurrency(CurrencyConstants newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }

  // 定義一個私有變數，用來存放「正在進行中」的任務
  Future<String>? _ongoingInviteTask;

  Future<String> inviteMember() async {
    //  這是「升級版」的 Guard Clause：
    // 如果任務正在跑，就直接回傳同一個 Future 給呼叫者，而不是結束它。
    if (_ongoingInviteTask != null) {
      return _ongoingInviteTask!;
    }

    // 將邏輯封裝並存入變數
    _ongoingInviteTask = _inviteMember();

    try {
      return await _ongoingInviteTask!;
    } finally {
      // 任務結束後務必清空，否則之後無法再次呼叫
      _ongoingInviteTask = null;
    }
  }

  Future<String> _inviteMember() async {
    _inviteMemberStatus = LoadStatus.loading;
    notifyListeners();

    try {
      inviteCode = await _inviteRepo.createInviteCode(taskId);
      _inviteMemberStatus = LoadStatus.success;
      notifyListeners();
      return inviteCode;
    } on AppErrorCodes {
      // Deleted
      _inviteMemberStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _inviteMemberStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  /// 通知成員 (純文字分享)
  Future<void> notifyMembers(
      {required String message, required String subject}) async {
    await _shareService.shareText(message, subject: subject);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
