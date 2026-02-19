import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';

class S11InviteConfirmViewModel extends ChangeNotifier {
  final InviteRepository _inviteRepo;
  final AuthRepository _authRepo;
  final PendingInviteProvider _pendingProvider;

  // State
  LoadStatus _initStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  LoadStatus _joinStatus = LoadStatus.initial;

  late User? _currentUser;

  // Data
  String _inviteCode = '';
  Map<String, dynamic>? _taskData;
  List<TaskMember> _ghosts = [];
  bool _isAutoAssign = true; // Scenario A vs B

  // Selection
  String? _selectedGhostId;

  // Getters
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  LoadStatus get joinStatus => _joinStatus;
  User? get currentUser => _currentUser;

  String get taskName => _taskData?['taskName'] ?? '';
  DateTime get startDate => _parseDate(_taskData?['startDate']);
  DateTime get endDate => _parseDate(_taskData?['endDate']);
  CurrencyConstants get baseCurrency =>
      CurrencyConstants.getCurrencyConstants(_taskData?['baseCurrency']);

  // Ghost List Logic
  List<TaskMember> get ghosts => _ghosts;
  String? get selectedGhostId => _selectedGhostId;
  bool get showGhostSelection => !_isAutoAssign && _ghosts.isNotEmpty;

  // Button Enable State
  bool get canConfirm {
    if (_isAutoAssign) return true; // 直接加入模式，隨時可按
    return _selectedGhostId != null; // 選擇模式，必須選一個
  }

  S11InviteConfirmViewModel({
    required InviteRepository inviteRepo,
    required AuthRepository authRepo,
    required PendingInviteProvider pendingProvider,
  })  : _inviteRepo = inviteRepo,
        _authRepo = authRepo,
        _pendingProvider = pendingProvider;

  void clearInvite() {
    _pendingProvider.clear();
  }

  DateTime _parseDate(dynamic val) {
    if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
    if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
    return DateTime.now();
  }

  // 初始化：載入預覽資訊
  Future<void> init(String code) async {
    if (_initStatus == LoadStatus.loading) return;
    _inviteCode = code;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      // 登入確認移到 VM
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      _currentUser = user;

      // 1. 呼叫 Repository 取得預覽
      final result = await _inviteRepo.previewInviteCode(code);

      final rawTaskData = result['taskData'];
      if (rawTaskData is Map) {
        _taskData = Map<String, dynamic>.from(rawTaskData);
      }

      // 處理 Ghost List
      if (result['ghosts'] is List) {
        final rawGhosts = result['ghosts'] as List;
        _ghosts = rawGhosts.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          // 透過 fromMap 轉換成 TaskMember，後端通常會把 key 放在 'id' 裡回傳
          return TaskMember.fromMap(map['id'] ?? map['uid'] ?? '', map);
        }).toList();

        // 使用 TaskModel 中為 TaskMember 準備的靜態排序方法
        _ghosts.sort(TaskModel.compareMembers);
      }

      _isAutoAssign = _ghosts.isEmpty;
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

  void selectGhost(String ghostId) {
    if (_selectedGhostId == ghostId) return;
    _selectedGhostId = ghostId;
    notifyListeners();
  }

  // 確認加入
  Future<String?> confirmJoin() async {
    if (_joinStatus == LoadStatus.loading) return null;
    _joinStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 呼叫 Repository 加入
      final taskId = await _inviteRepo.joinTask(
        code: _inviteCode,
        displayName: currentUser?.displayName ?? 'New Member',
        targetMemberId: _selectedGhostId,
      );

      await _pendingProvider.clear();

      _joinStatus = LoadStatus.success;
      notifyListeners();
      return taskId;
    } on AppErrorCodes {
      _joinStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _joinStatus = LoadStatus.error;
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
