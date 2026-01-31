import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';

class D01MemberRoleIntroViewModel extends ChangeNotifier {
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
    required String initialAvatar,
    required bool canReroll,
  }) {
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

      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'members.$uid.avatar': newAvatar,
        'members.$uid.hasRerolled': true,
      });

      _currentAvatar = newAvatar;
      _canReroll = false;
    } catch (e) {
      debugPrint('Reroll failed: $e');
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<void> handleEnter() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({'members.$uid.hasSeenRoleIntro': true});
    } catch (e) {
      debugPrint('Update seen status failed: $e');
      // 這裡不 throw，因為即使失敗也要讓使用者進入 Dashboard
    }
  }
}
