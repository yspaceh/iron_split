import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/features/task/data/task_repository.dart';

class D01MemberRoleIntroViewModel extends ChangeNotifier {
  final TaskRepository _taskRepo;
  final String taskId;

  late String _currentAvatar;
  late bool _canReroll;
  bool _isUpdating = false;

  // Getters
  String get currentAvatar => _currentAvatar;
  bool get canReroll => _canReroll;
  bool get isUpdating => _isUpdating;

  D01MemberRoleIntroViewModel({
    required this.taskId,
    required TaskRepository taskRepo,
    required String initialAvatar,
    required bool canReroll,
  }) : _taskRepo = taskRepo {
    _currentAvatar = initialAvatar;
    _canReroll = canReroll;
  }

  Future<void> handleReroll() async {
    if (!_canReroll || _isUpdating) return;

    _isUpdating = true;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      // 隨機選一個新的 (排除當前這個)
      final available =
          AvatarConstants.allAvatars.where((a) => a != _currentAvatar).toList();
      final newAvatar = available[Random().nextInt(available.length)];

      await _taskRepo.updateMemberFields(taskId, uid, {
        'avatar': newAvatar,
        'hasRerolled': true,
      });

      _currentAvatar = newAvatar;
      _canReroll = false;
    } catch (e) {
      // TODO: handle error
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> handleEnter() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await _taskRepo.updateMemberFields(taskId, uid, {
        'hasSeenRoleIntro': true,
      });
    } catch (e) {
      // TODO: handle error
      // 這裡不 throw，因為即使失敗也要讓使用者進入 Dashboard
    }
  }
}
