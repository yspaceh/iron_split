import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S14TaskSettingsViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final AuthRepository _authRepo;
  final RecordRepository _recordRepo;
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

  // Logic Helper
  String? _initialName;
  String? _createdBy;
  Map<String, dynamic> _membersData = {};

  double _currentRemainder = 0.0;

  // Getters
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  CurrencyConstants? get currency => _currency;
  String get remainderRule => _remainderRule;
  String? get remainderAbsorberId => _remainderAbsorberId;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  Map<String, dynamic> get membersData => _membersData;
  double get currentRemainder => _currentRemainder;

  List<Map<String, dynamic>> get membersList {
    return _membersData.entries.map((e) {
      final m = e.value as Map<String, dynamic>;
      return <String, dynamic>{...m, 'id': e.key};
    }).toList();
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
  })  : _taskRepo = taskRepo,
        _recordRepo = recordRepo,
        _authRepo = authRepo;

  Future<void> init() async {
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) {
        _initStatus = LoadStatus.error;
        _initErrorCode = AppErrorCodes.unauthorized;
        notifyListeners();
        return;
      }

      final task = await _taskRepo.streamTask(taskId).first;

      if (task == null) {
        throw AppErrorCodes.dataNotFound;
      }

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

      _initStatus = LoadStatus.success;
      notifyListeners();
    } catch (e) {
      _initStatus = LoadStatus.error;
      _initErrorCode = ErrorMapper.parseErrorCode(e);
      notifyListeners();
    }
  }

  // --- Actions ---

  Future<void> updateName() async {
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
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    try {
      //  核心防呆邏輯
      // 如果「開始日」跑到了「結束日」後面，就強制把「結束日」拉過來跟「開始日」同一天
      if (start.isAfter(end)) {
        end = start;
      }

      _startDate = start;
      _endDate = end;
      notifyListeners();

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
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  /// 更新餘額處理規則
  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    try {
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

      await _taskRepo.updateTask(taskId, updateData);

      // 4. Activity Log
      Map<String, dynamic> logDetails = {
        'settingType': 'remainder_rule',
        'newValue': newRule,
      };

      if (newRule == RemainderRuleConstants.member && newAbsorberId != null) {
        final memberName =
            _membersData[newAbsorberId]?['displayName'] ?? 'Unknown';
        logDetails['absorberName'] = memberName;
      }

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.updateSettings,
        details: logDetails,
      );
    } on AppErrorCodes {
      rethrow;
    } catch (e) {
      throw ErrorMapper.parseErrorCode(e); // 其他系統錯誤轉化後拋出
    }
  }

  void updateCurrency(CurrencyConstants newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
