import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
// For default name

class S54TaskSettingsInviteViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final InviteRepository _inviteRepo;
  final AuthRepository _authRepo;
  final ShareService _shareService;
  final DeepLinkService _deepLinkService;
  final String taskId;

  LoadStatus _initStatus = LoadStatus.initial;
  LoadStatus _generateStatus = LoadStatus.initial;
  AppErrorCodes? _initErrorCode;
  String inviteCode = '';
  String taskName = '';
  DateTime? _expiresAt;
  int _remainingSeconds = 0;
  Timer? _timer;
  // Getters

  LoadStatus get generateStatus => _generateStatus;

  int get remainingSeconds => _remainingSeconds;
  bool get isExpired => _remainingSeconds <= 0;
  LoadStatus get initStatus => _initStatus;
  AppErrorCodes? get initErrorCode => _initErrorCode;
  String get link => _deepLinkService.generateJoinLink(inviteCode);

  // 格式化倒數計時為 MM:SS
  String get formattedTimer {
    if (isExpired) return "00:00";
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  S54TaskSettingsInviteViewModel(
      {required TaskRepository taskRepo,
      required InviteRepository inviteRepo,
      required AuthRepository authRepo,
      required ShareService shareService,
      required DeepLinkService deepLinkService,
      required this.taskId})
      : _taskRepo = taskRepo,
        _inviteRepo = inviteRepo,
        _authRepo = authRepo,
        _shareService = shareService,
        _deepLinkService = deepLinkService;

  Future<void> init() async {
    if (_initStatus == LoadStatus.loading) return;
    _initStatus = LoadStatus.loading;
    _initErrorCode = null;
    notifyListeners();

    try {
      final user = _authRepo.currentUser;
      if (user == null) throw AppErrorCodes.unauthorized;

      await _checkAndLoadInviteCode();

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

  Future<void> _checkAndLoadInviteCode() async {
    // 取得最新任務資料
    final task = await _taskRepo.streamTask(taskId).first;
    if (task == null) throw AppErrorCodes.dataNotFound;

    taskName = task.name;
    final currentCode = task.activeInviteCode;
    final expiresAt = task.activeInviteExpiresAt;

    final now = DateTime.now();

    // 如果沒有邀請碼，或是已經過期，就自動產生新的
    if (currentCode == null || expiresAt == null || expiresAt.isBefore(now)) {
      await generateNewInviteCode();
    } else {
      inviteCode = currentCode;
      _expiresAt = expiresAt;
      _startTimer();
    }
  }

  Future<void> generateNewInviteCode() async {
    if (_generateStatus == LoadStatus.loading) return;
    _generateStatus = LoadStatus.loading;
    notifyListeners();

    try {
      // 呼叫雲端函數產生新的 Invite Code
      final result = await _inviteRepo.createInviteCode(taskId);

      inviteCode = result.code;
      _expiresAt = result.expiresAt;
      _startTimer();
      _generateStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _generateStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _generateStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _updateRemainingTime();

    if (!isExpired) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateRemainingTime();
        if (isExpired) {
          timer.cancel();
        }
        notifyListeners();
      });
    }
  }

  void _updateRemainingTime() {
    if (_expiresAt == null) {
      _remainingSeconds = 0;
      return;
    }
    final diff = _expiresAt!.difference(DateTime.now()).inSeconds;
    _remainingSeconds = diff > 0 ? diff : 0;
  }

  // 格式化邀請碼 (例如：ABCDEFGH -> ABCD EFGH)，方便閱讀
  String get displayInviteCode {
    if (inviteCode.isEmpty || inviteCode.length != 8) {
      return inviteCode;
    }
    return '${inviteCode.substring(0, 4)} ${inviteCode.substring(4, 8)}';
  }

  // 複製到剪貼簿
  void copyToClipboard() {
    if (inviteCode.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: inviteCode));
    }
  }

  /// 通知成員 (純文字分享)
  Future<void> notifyMembers(
      {required String message, required String subject}) async {
    await _shareService.shareText(message, subject: subject);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
