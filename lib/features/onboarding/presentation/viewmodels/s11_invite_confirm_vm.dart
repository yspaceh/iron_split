import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';

class S11InviteConfirmViewModel extends ChangeNotifier {
  final InviteRepository _inviteRepo;

  // State
  bool _isLoading = true;
  bool _isJoining = false;
  String? _errorCode; // 用於 UI 顯示錯誤 Dialog

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
  String? get errorCode => _errorCode;

  String get taskName => _taskData?['taskName'] ?? '';
  String get currencyCode => _taskData?['baseCurrency'] ?? 'TWD'; // Default

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
  }) : _inviteRepo = inviteRepo;

  // 初始化：載入預覽資訊
  Future<void> init(String code) async {
    _inviteCode = code;
    _isLoading = true;
    _errorCode = null;
    notifyListeners();

    try {
      // 1. 呼叫 Repository 取得預覽
      final result = await _inviteRepo.previewInviteCode(code);

      _taskData = result['taskData'] as Map<String, dynamic>?;

      // 處理 Ghost List
      if (result['ghosts'] is List) {
        _ghosts = List<Map<String, dynamic>>.from(result['ghosts']);
      }

      // 判斷是否為自動分配 (如果沒有 ghosts 或是後端回傳特定 flag)
      // 這裡假設：如果有 ghosts 就要選，沒有就直接加入
      _isAutoAssign = _ghosts.isEmpty;
    } catch (e) {
      // 解析錯誤代碼
      _errorCode = _parseError(e);
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
    required VoidCallback onSuccess,
    required Function(String code) onError,
  }) async {
    if (_isJoining) return;
    _isJoining = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // 呼叫 Repository 加入
      await _inviteRepo.joinTask(
        code: _inviteCode,
        displayName: user.displayName ?? 'New Member',
        targetMemberId: _selectedGhostId,
      );

      onSuccess();
    } catch (e) {
      final code = _parseError(e);
      onError(code);
    } finally {
      _isJoining = false;
      notifyListeners();
    }
  }

  String _parseError(dynamic e) {
    final msg = e.toString();

    // 優先匹配後端可能回傳的特定字串
    if (msg.contains('TASK_FULL') || msg.contains('failed-precondition')) {
      return AppErrorCodes.inviteTaskFull;
    }
    if (msg.contains('EXPIRED') || msg.contains('deadline-exceeded')) {
      return AppErrorCodes.inviteExpired;
    }
    if (msg.contains('INVALID') || msg.contains('not-found')) {
      return AppErrorCodes.inviteInvalid;
    }
    if (msg.contains('ALREADY') || msg.contains('already-exists')) {
      return AppErrorCodes.inviteAlreadyJoined;
    }
    if (msg.contains('AUTH') || msg.contains('unauthenticated')) {
      return AppErrorCodes.inviteAuthRequired;
    }

    return AppErrorCodes.unknown; // 回傳預設未知錯誤
  }
}
