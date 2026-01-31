import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class S14TaskSettingsViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo; // ✅ 注入 Repo
  final String taskId;

  // UI State
  TextEditingController nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  CurrencyOption? _currency;
  String _remainderRule = RemainderRuleConstants.defaultRule;
  String? _remainderAbsorberId; // ✅ 新增：B01 需要知道目前是誰請客
  bool _isLoading = true;

  // Logic Helper
  String? _initialName;
  String? _createdBy;
  Map<String, dynamic> _membersData = {};

  // Getters
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  CurrencyOption? get currency => _currency;
  String get remainderRule => _remainderRule;
  String? get remainderAbsorberId => _remainderAbsorberId; // ✅ 新增 Getter
  bool get isLoading => _isLoading;
  Map<String, dynamic> get membersData => _membersData;

  bool get isOwner {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return currentUid != null && currentUid == _createdBy;
  }

  S14TaskSettingsViewModel({
    required this.taskId,
    required TaskRepository taskRepo, // ✅ 建構子注入
  }) : _taskRepo = taskRepo;

  Future<void> init() async {
    try {
      // ✅ 改用 Repo 讀取 (使用 Stream.first 或是 getTask)
      // 這裡假設我們要讀取一次最新狀態
      final task = await _taskRepo.streamTask(taskId).first;

      if (task != null) {
        nameController.text = task.name;
        _initialName = task.name;

        _startDate = task.startDate;
        _endDate = task.endDate;
        _currency = CurrencyOption.getCurrencyOption(task.baseCurrency);

        _remainderRule = task.remainderRule;
        _remainderAbsorberId = task.remainderAbsorberId; // ✅ 讀取 ID

        _createdBy = task.createdBy;
        _membersData = task.members;

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Actions ---

  Future<void> updateName() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) return;
    if (newName == _initialName) return;

    _initialName = newName;

    // ✅ 改用 Repo
    await _taskRepo.updateTask(taskId, {'name': newName});

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: {
        'settingType': 'task_name',
        'newValue': newName,
      },
    );
  }

  Future<void> updateDateRange(DateTime start, DateTime end) async {
    _startDate = start;
    _endDate = end;
    notifyListeners();

    // ✅ 改用 Repo (注意 Timestamp 轉換通常由 Repo 或 Model 處理，
    // 但因為 Repo.updateTask 接收 Map，這裡還是要傳 Timestamp 給 Firestore)
    // 如果您的 Repo 夠聰明，可以傳 DateTime，但在 updateMap 裡通常直接傳值
    await _taskRepo.updateTask(taskId, {
      'startDate':
          start, // 假設 Repo 內部或 Firestore SDK 會自動處理 DateTime 轉 Timestamp
      'endDate': end,
    });

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
  }

  /// 更新餘額處理規則
  Future<void> updateRemainderRule(
      String newRule, String? newAbsorberId) async {
    // 1. 樂觀更新
    _remainderRule = newRule;
    _remainderAbsorberId = newAbsorberId;
    notifyListeners();

    // 2. 準備資料
    final Map<String, dynamic> updateData = {
      'remainderRule': newRule,
      'remainderAbsorberId': newRule == 'member' ? newAbsorberId : null,
    };

    // 3. ✅ 改用 Repo
    await _taskRepo.updateTask(taskId, updateData);

    // 4. Activity Log
    Map<String, dynamic> logDetails = {
      'settingType': 'remainder_rule',
      'newValue': newRule,
    };

    if (newRule == 'member' && newAbsorberId != null) {
      final memberName =
          _membersData[newAbsorberId]?['displayName'] ?? 'Unknown';
      logDetails['absorberName'] = memberName;
    }

    await ActivityLogService.log(
      taskId: taskId,
      action: LogAction.updateSettings,
      details: logDetails,
    );
  }

  void updateCurrency(CurrencyOption newCurrency) {
    _currency = newCurrency;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
