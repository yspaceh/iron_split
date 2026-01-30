import 'package:flutter/material.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';

class S11InviteConfirmViewModel extends ChangeNotifier {
  final OnboardingService _service;

  // UI States
  bool _isLoading = true;
  bool _isJoining = false;
  Map<String, dynamic>? _taskData;

  // Ghost Logic
  List<Map<String, dynamic>> _ghosts = [];
  String? _selectedGhostId;
  bool _isAutoAssign = true;

  // Getters
  bool get isLoading => _isLoading;
  bool get isJoining => _isJoining;
  Map<String, dynamic>? get taskData => _taskData;
  List<Map<String, dynamic>> get ghosts => _ghosts;
  String? get selectedGhostId => _selectedGhostId;
  bool get isAutoAssign => _isAutoAssign;

  // 根據 autoAssign 與選擇狀態決定按鈕是否啟用
  bool get canConfirm => _isAutoAssign || _selectedGhostId != null;

  S11InviteConfirmViewModel({required OnboardingService service})
      : _service = service;

  Future<void> loadPreview(String code,
      {required Function(String code, String? msg, dynamic details)
          onError}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.analyzeInvite(code);
      _taskData = result.taskData;
      _ghosts = result.ghosts;
      _isAutoAssign = result.isAutoAssign;
      _selectedGhostId = null; // 重置選擇
    } catch (e) {
      // 這裡簡化錯誤傳遞，實際專案可解析 FirebaseException
      onError('UNKNOWN', e.toString(), null);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectGhost(String? ghostId) {
    _selectedGhostId = ghostId;
    notifyListeners();
  }

  Future<void> joinTask(String code,
      {required Function(String taskId) onSuccess,
      required Function(String code, String? msg, dynamic details)
          onError}) async {
    if (_isJoining) return;

    _isJoining = true;
    notifyListeners();

    try {
      final taskId = await _service.confirmJoin(
        code: code,
        targetMemberId: _selectedGhostId,
      );
      onSuccess(taskId);
    } catch (e) {
      // TODO: 錯誤處理
      // 這裡可以解析 e 來決定傳什麼 error code
      // 暫時傳遞原始錯誤訊息，由 UI 轉譯
      onError('UNKNOWN', e.toString(), null);
    } finally {
      _isJoining = false;
      notifyListeners();
    }
  }
}
