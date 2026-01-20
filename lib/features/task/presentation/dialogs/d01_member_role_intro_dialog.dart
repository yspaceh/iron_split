import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class D01MemberRoleIntroDialog extends StatefulWidget {
  final String taskId;
  final String initialAvatar;
  final bool canReroll;

  const D01MemberRoleIntroDialog({
    super.key,
    required this.taskId,
    required this.initialAvatar,
    this.canReroll = true,
  });

  @override
  State<D01MemberRoleIntroDialog> createState() =>
      _D01MemberRoleIntroDialogState();
}

class _D01MemberRoleIntroDialogState extends State<D01MemberRoleIntroDialog> {
  late String _currentAvatar;
  late bool _canReroll;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.initialAvatar;
    _canReroll = widget.canReroll;
  }

  Future<void> _handleReroll() async {
    setState(() => _isProcessing = true);
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('rerollAvatar');
      final res = await callable.call({'taskId': widget.taskId});
      final data = Map<String, dynamic>.from(res.data);

      setState(() {
        _currentAvatar = data['newAvatar'];
        _canReroll = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.D01_MemberRole_Intro.error_reroll_failed(
              message: e.toString()))));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .collection('members')
          .doc(uid)
          .update({'hasSeenIntro': true});

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t.common.error_prefix(message: e.toString()))));
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(t.D01_InviteJoin_Success.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.D01_InviteJoin_Success.assigned_avatar),
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _currentAvatar.substring(0, 1).toUpperCase(),
                  style: theme.textTheme.displayMedium,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(_currentAvatar, style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            if (_canReroll)
              TextButton.icon(
                onPressed: _isProcessing ? null : _handleReroll,
                icon: const Icon(Icons.refresh),
                label: Text(t.D01_MemberRole_Intro.action_reroll), // '不喜歡？重抽一次'
              )
            else
              Text(
                t.D01_InviteJoin_Success.avatar_note,
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: _isProcessing ? null : _handleConfirm,
            child: Text(t.D01_InviteJoin_Success.action_continue),
          ),
        ],
      ),
    );
  }
}
