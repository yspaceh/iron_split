import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';

class S11InviteConfirmViewModel extends ChangeNotifier {
  final InviteRepository _inviteRepo;
  final PendingInviteProvider _pendingProvider;

  // State
  bool _isLoading = true;
  bool _isJoining = false;
  AppErrorCodes? _errorCode; // 用於 UI 顯示錯誤 Dialog

  // Data
  String _inviteCode = '';
  Map<String, dynamic>? _taskData;
  List<Map<String, dynamic>> _ghosts = [];
  bool _isAutoAssign = true; // Scenario A vs B

  // Selection
  String? _selectedGhostId;

  // Getters
  bool get isLoading => _isLoading;
  bool get isJoining => _isJoining;
  AppErrorCodes? get errorCode => _errorCode;

  String get taskName => _taskData?['taskName'] ?? '';
  DateTime get startDate => _parseDate(_taskData?['startDate']);
  DateTime get endDate => _parseDate(_taskData?['endDate']);
  CurrencyConstants get baseCurrency =>
      CurrencyConstants.getCurrencyConstants(_taskData?['baseCurrency']);

  // Ghost List Logic
  List<Map<String, dynamic>> get ghosts => _ghosts;
  String? get selectedGhostId => _selectedGhostId;
  bool get showGhostSelection => !_isAutoAssign && _ghosts.isNotEmpty;

  // Button Enable State
  bool get canConfirm {
    if (_isAutoAssign) return true; // 直接加入模式，隨時可按
    return _selectedGhostId != null; // 選擇模式，必須選一個
  }

  S11InviteConfirmViewModel({
    required InviteRepository inviteRepo,
    required PendingInviteProvider pendingProvider,
  })  : _inviteRepo = inviteRepo,
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
    _inviteCode = code;
    _isLoading = true;
    _errorCode = null;
    notifyListeners();

    try {
      // 1. 呼叫 Repository 取得預覽
      final result = await _inviteRepo.previewInviteCode(code);

      final rawTaskData = result['taskData'];
      if (rawTaskData is Map) {
        _taskData = Map<String, dynamic>.from(rawTaskData);
      }

      // 處理 Ghost List
      if (result['ghosts'] is List) {
        final rawGhosts = result['ghosts'] as List;
        _ghosts =
            rawGhosts.map((e) => Map<String, dynamic>.from(e as Map)).toList();

        _ghosts.sort((a, b) {
          final timeA = _parseDate(a['createdAt']).millisecondsSinceEpoch;
          final timeB = _parseDate(b['createdAt']).millisecondsSinceEpoch;
          return timeA.compareTo(timeB);
        });
      }

      _isAutoAssign = _ghosts.isEmpty;
    } catch (e) {
      debugPrint("🔥 [S11 Init Error] 後端拒絕的原因是: $e");
      _errorCode = ErrorMapper.parseErrorCode(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectGhost(String ghostId) {
    if (_selectedGhostId == ghostId) return;
    _selectedGhostId = ghostId;
    notifyListeners();
  }

  // 確認加入
  Future<void> confirmJoin({
    required Function(String taskId) onSuccess,
    required Function(AppErrorCodes code) onError,
  }) async {
    if (_isJoining) return;
    _isJoining = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      //TODO: handle error
      if (user == null) throw Exception("User not logged in");

      // 呼叫 Repository 加入
      final taskId = await _inviteRepo.joinTask(
        code: _inviteCode,
        displayName: user.displayName ?? 'New Member',
        targetMemberId: _selectedGhostId,
      );

      await _pendingProvider.clear();

      onSuccess(taskId);
    } catch (e) {
      debugPrint("🔥 [S11 confirmJoin Error] 後端拒絕的原因是: $e");
      final code = ErrorMapper.parseErrorCode(e);
      onError(code);
    } finally {
      _isJoining = false;
      notifyListeners();
    }
  }
}
