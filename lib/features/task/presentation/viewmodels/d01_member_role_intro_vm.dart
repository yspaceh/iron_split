import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class D01MemberRoleIntroViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final AuthRepository _authRepo;
  final String taskId;
  late String _currentAvatar;
  late bool _canReroll;

  LoadStatus _rerollStatus = LoadStatus.initial;
  LoadStatus _enterStatus = LoadStatus.initial;

  // Getters
  String get currentAvatar => _currentAvatar;
  bool get canReroll => _canReroll;
  LoadStatus get rerollStatus => _rerollStatus;
  LoadStatus get enterStatus => _enterStatus;

  D01MemberRoleIntroViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required AuthRepository authRepo,
    required String initialAvatar,
    required bool canReroll,
  })  : _taskRepo = taskRepo,
        _authRepo = authRepo {
    _currentAvatar = initialAvatar;
    _canReroll = canReroll;
  }

  Future<void> handleReroll() async {
    if (!_canReroll || _rerollStatus == LoadStatus.loading) return;
    _rerollStatus = LoadStatus.loading;
    notifyListeners();

    try {
      final uid = _authRepo.currentUser?.uid;
      if (uid == null) return;

      // 1. 讀取 Task 取得已用頭像
      final task = await _taskRepo.streamTask(taskId).first;
      if (task == null) throw AppErrorCodes.dataNotFound;

      final usedAvatars = task.members.values
          .map((m) => m['avatar'] as String?)
          .where((a) => a != null)
          .cast<String>()
          .toSet();

      usedAvatars.add(_currentAvatar);

      final newAvatar = AvatarConstants.pickUniqueAvatar(exclude: usedAvatars);

      await _taskRepo.updateMemberFields(taskId, uid, {
        'avatar': newAvatar,
        'hasRerolled': true,
      });

      _currentAvatar = newAvatar;
      _canReroll = false;
      _rerollStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _rerollStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _rerollStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }

  Future<void> enterTask() async {
    debugPrint("_enterStatus: $_enterStatus");
    if (_enterStatus == LoadStatus.loading) return;
    _enterStatus = LoadStatus.loading;
    notifyListeners();
    try {
      final uid = _authRepo.currentUser?.uid;
      if (uid == null) throw AppErrorCodes.unauthorized;

      await _taskRepo.updateMemberFields(taskId, uid, {
        'hasSeenRoleIntro': true,
      });
      _enterStatus = LoadStatus.success;
      notifyListeners();
    } on AppErrorCodes {
      _enterStatus = LoadStatus.error;
      notifyListeners();
      rethrow;
    } catch (e) {
      _enterStatus = LoadStatus.error;
      notifyListeners();
      throw ErrorMapper.parseErrorCode(e);
    }
  }
}
