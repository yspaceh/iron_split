import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/avatar_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D01_MemberRole.Intro
class D01MemberRoleIntroDialog extends StatefulWidget {
  final String taskId;
  final String initialAvatar;
  final bool canReroll;

  const D01MemberRoleIntroDialog({
    super.key,
    required this.taskId,
    required this.initialAvatar,
    required this.canReroll,
  });

  @override
  State<D01MemberRoleIntroDialog> createState() =>
      _D01MemberRoleIntroDialogState();
}

class _D01MemberRoleIntroDialogState extends State<D01MemberRoleIntroDialog>
    with SingleTickerProviderStateMixin {
  late String _currentAvatar;
  late bool _canReroll;
  late AnimationController _animController;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar;
    _canReroll = widget.canReroll;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.8,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleReroll() async {
    if (!_canReroll || _isUpdating) return;

    setState(() => _isUpdating = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // 隨機選一個新的 (排除當前這個)
      final available =
          AvatarConstants.allAvatars.where((a) => a != _currentAvatar).toList();
      final newAvatar = available[Random().nextInt(available.length)];

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'members.$uid.avatar': newAvatar,
        'members.$uid.hasRerolled': true,
      });

      if (mounted) {
        setState(() {
          _currentAvatar = newAvatar;
          _canReroll = false;
        });
      }
    } catch (e) {
      debugPrint('Reroll failed: $e');
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _handleEnter() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({'members.$uid.hasSeenRoleIntro': true});

      if (mounted) context.pop();
    } catch (e) {
      debugPrint('Update seen status failed: $e');
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                t.D01_MemberRole_Intro.title,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Avatar Animation
              ScaleTransition(
                scale: _animController,
                child: CommonAvatar(
                  avatarId: _currentAvatar,
                  name: null,
                  radius: 55,
                  isLinked: true,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                t.D01_MemberRole_Intro.dialog_content,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Reroll Button
              TextButton.icon(
                onPressed: _canReroll ? _handleReroll : null,
                icon: _isUpdating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.refresh),
                label: Text(_canReroll
                    ? t.D01_MemberRole_Intro.action_reroll
                    : t.D01_MemberRole_Intro.desc_reroll_empty),
              ),

              const SizedBox(height: 16),

              // Enter Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _handleEnter,
                  child: Text(t.D01_MemberRole_Intro.action_enter),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
