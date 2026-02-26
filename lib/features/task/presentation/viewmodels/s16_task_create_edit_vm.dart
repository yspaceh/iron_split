import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/invite_code_model.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/member_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';

class S16TaskCreateEditViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final InviteRepository _inviteRepo;
  final AuthRepository _authRepo;
  final ShareService _shareService;
  final DeepLinkService _deepLinkService;

  // State
  late DateTime _startDate;
  late DateTime _endDate;
  CurrencyConstants _baseCurrency = CurrencyConstants.defaultCurrencyConstants;
  int _memberCount = 1;
  bool _isCurrencyInitialized = false;
  LoadStatus _createStatus = LoadStatus.initial; // 按鈕狀態
  LoadStatus _shareStatus = LoadStatus.initial; // 分享狀態

  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  InviteCodeDetail? inviteCodeDetail;

  // Getters
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  CurrencyConstants get baseCurrency => _baseCurrency;
  int get memberCount => _memberCount;
  bool get isCurrencyEnabled => true; // 保留原始邏輯
  LoadStatus get createStatus => _createStatus;
  LoadStatus get shareStatus => _shareStatus;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String get link =>
      _deepLinkService.generateJoinLink(inviteCodeDetail?.code ?? '');

  S16TaskCreateEditViewModel({
    required TaskRepository taskRepo,
    required InviteRepository inviteRepo,
    required AuthRepository authRepo,
    required ShareService shareService,
    required DeepLinkService deepLinkService,
  })  : _taskRepo = taskRepo,
        _inviteRepo = inviteRepo,
        _authRepo = authRepo,
        _shareService = shareService,
        _deepLinkService = deepLinkService;

  void init() {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      // 1. 初始化日期 (今天)
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day, 12);
      _endDate = _startDate;

      // 初始化幣別
      if (!_isCurrencyInitialized) {
        _isCurrencyInitialized = true;
        final CurrencyConstants suggestedCurrency =
            CurrencyConstants.detectSystemCurrency();
        _baseCurrency = suggestedCurrency;
        // 這裡不需 notifyListeners，因為通常是在 build 前或第一幀執行，
        // 若有需要可加，但需注意 notify 時機
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

  // --- Setters (Update State) ---
  void updateDateRange(DateTime start, DateTime end) {
    // 核心防呆：如果「開始」晚於「結束」，強制將「結束」拉到跟「開始」同一天
    if (start.isAfter(end)) {
      end = start;
    }

    if (_startDate != start || _endDate != end) {
      _startDate = start;
      _endDate = end;
      notifyListeners();
    }
  }

  void updateCurrency(CurrencyConstants currency) {
    _baseCurrency = currency;
    notifyListeners();
  }

  void updateMemberCount(int count) {
    _memberCount = count;
    notifyListeners();
  }

  // 定義一個私有變數，用來存放「正在進行中」的任務
  Future<({String taskId, InviteCodeDetail? inviteCodeDetail})?>? _ongoingTask;

  Future<({String taskId, InviteCodeDetail? inviteCodeDetail})?> createTask(
      String taskName) async {
    //  這是「升級版」的 Guard Clause：
    // 如果任務正在跑，就直接回傳同一個 Future 給呼叫者，而不是結束它。
    if (_ongoingTask != null) {
      return _ongoingTask!;
    }

    // 將邏輯封裝並存入變數
    _ongoingTask = _createTask(taskName);

    try {
      return await _ongoingTask!;
    } finally {
      // 任務結束後務必清空，否則之後無法再次呼叫
      _ongoingTask = null;
    }
  }

  /// 核心邏輯：建立任務
  Future<({String taskId, InviteCodeDetail? inviteCodeDetail})?> _createTask(
      String taskName) async {
    if (taskName.isEmpty) throw AppErrorCodes.fieldRequired;
    _createStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;
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
        final vid = MemberService.generateVirtualId(index: i);
        membersMap[vid] = MemberService.createGhost(
          displayName: '${t.common.member_prefix} ${i + 1}',
        );
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
      if (_memberCount > 1) {
        inviteCodeDetail = await _inviteRepo.createInviteCode(taskId);
      }

      _createStatus = LoadStatus.success;
      notifyListeners();
      return (taskId: taskId, inviteCodeDetail: inviteCodeDetail);
    } on AppErrorCodes {
      _createStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _createStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
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
}
