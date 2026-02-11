import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/member_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';

class S16TaskCreateEditViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final InviteRepository _inviteRepo;
  // State
  late DateTime _startDate;
  late DateTime _endDate;
  CurrencyConstants _baseCurrency = CurrencyConstants.defaultCurrencyConstants;
  int _memberCount = 1;
  bool _isCurrencyInitialized = false;
  bool _isProcessing = false;
  String? _statusText; // 用於顯示 Loading 狀態文字 (e.g. "建立中...", "產生邀請碼...")

  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  CurrencyConstants get baseCurrency => _baseCurrency;
  int get memberCount => _memberCount;
  bool get isCurrencyEnabled => true; // 保留原始邏輯
  bool get isProcessing => _isProcessing;
  String? get statusText => _statusText;

  S16TaskCreateEditViewModel({
    required TaskRepository taskRepo,
    required InviteRepository inviteRepo,
  })  : _taskRepo = taskRepo,
        _inviteRepo = inviteRepo {
    // 1. 初始化日期 (今天)
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, now.day);
    _endDate = _startDate;
  }

  // 初始化幣別 (避免重複偵測)
  void initCurrency() {
    if (!_isCurrencyInitialized) {
      _isCurrencyInitialized = true;
      final CurrencyConstants suggestedCurrency =
          CurrencyConstants.detectSystemCurrency();
      _baseCurrency = suggestedCurrency;
      // 這裡不需 notifyListeners，因為通常是在 build 前或第一幀執行，
      // 若有需要可加，但需注意 notify 時機
    }
  }

  // --- Setters (Update State) ---

  void updateDateRange(DateTime start, DateTime end) {
    // 核心防呆：如果「開始」晚於「結束」，強制將「結束」拉到跟「開始」同一天
    if (start.isAfter(end)) {
      end = start;
    }

    _startDate = start;
    _endDate = end;

    // 只有一次通知，效能更好
    notifyListeners();
  }

  void updateCurrency(CurrencyConstants currency) {
    _baseCurrency = currency;
    notifyListeners();
  }

  void updateMemberCount(int count) {
    _memberCount = count;
    notifyListeners();
  }

  /// 核心邏輯：建立任務
  Future<({String taskId, String? inviteCode})?> createTask(
      String taskName, Translations t) async {
    _isProcessing = true;
    _statusText = t.D03_TaskCreate_Confirm.creating_task;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isProcessing = false;
      notifyListeners();
      throw Exception("User not logged in");
    }

    try {
      // 1. Prepare Members Map
      final Map<String, dynamic> membersMap = {};

      // 定義基準時間，確保所有人的時間都是相對於這個時間點
      final baseTime = DateTime.now();

      // [修正] 使用統一邏輯一次產生所需數量的頭像 (保證不重複)
      final avatars = AvatarConstants.generateInitialAvatars(_memberCount);

      // A. Add Captain
      membersMap[user.uid] = {
        'role': 'captain',
        'displayName': user.displayName ?? 'Captain',
        'joinedAt': baseTime,
        'avatar': avatars[0],
        'isLinked': true,
        'hasSeenRoleIntro': false,
        'createdAt': baseTime.microsecondsSinceEpoch,
        'prepaid': 0.0,
        'expense': 0.0,
      };

      // B. Add Ghost Members
      for (int i = 1; i < _memberCount; i++) {
        final vid = MemberService.generateVirtualId();
        membersMap[vid] = MemberService.createGhost(
          displayName: '${t.common.member_prefix} ${i + 1}',
        );
        await Future.delayed(const Duration(milliseconds: 1));
      }

      // 2. 寫入 DB
      final Map<String, dynamic> taskData = {
        'name': taskName,
        'createdBy': user.uid,
        'memberCount': _memberCount,
        'maxMembers': _memberCount,
        'baseCurrency': _baseCurrency.code,
        'startDate': _startDate, // 直接傳 DateTime
        'endDate': _endDate, // 直接傳 DateTime
        'members': membersMap,
        'remainderRule': RemainderRuleConstants.defaultRule, // 預設值
      };

      final taskId = await _taskRepo.createTask(taskData);

      // 3. Activity Log
      final dateStr =
          "${DateFormat('yyyy/MM/dd').format(_startDate)} - ${DateFormat('yyyy/MM/dd').format(_endDate)}";

      await ActivityLogService.log(
        taskId: taskId,
        action: LogAction.createTask,
        details: {
          'recordName': taskName,
          'currency': _baseCurrency.code,
          'memberCount': _memberCount,
          'dateRange': dateStr,
        },
      );

      // 4. Invite Code & Share
      String? inviteCode;
      if (_memberCount > 1) {
        _statusText = t.D03_TaskCreate_Confirm.preparing_share;
        notifyListeners();

        inviteCode = await _inviteRepo.createInviteCode(taskId);
      }

      _isProcessing = false;
      notifyListeners();
      return (taskId: taskId, inviteCode: inviteCode);
    } catch (e) {
      // TODO: handle error
      _isProcessing = false;
      notifyListeners();
      rethrow; // 拋出異常讓 Page 處理 (顯示 SnackBar)
    }
  }
}
