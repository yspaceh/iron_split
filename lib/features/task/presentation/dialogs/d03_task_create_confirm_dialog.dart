import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:share_plus/share_plus.dart';

/// Page Key: D03_TaskCreate.Confirm
/// CSV Page 14
class D03TaskCreateConfirmDialog extends StatefulWidget {
  final String taskName;
  final DateTime startDate;
  final DateTime endDate;
  final String currency;
  final int memberCount;

  const D03TaskCreateConfirmDialog({
    super.key,
    required this.taskName,
    required this.startDate,
    required this.endDate,
    required this.currency,
    required this.memberCount,
  });

  @override
  State<D03TaskCreateConfirmDialog> createState() =>
      _D03TaskCreateConfirmDialogState();
}

class _D03TaskCreateConfirmDialogState
    extends State<D03TaskCreateConfirmDialog> {
  bool _isProcessing = false;
  String? _statusText;

  String _getRandomAvatar() {
    const avatars = [
      "cow",
      "pig",
      "chicken",
      "horse",
      "sheep",
      "goat",
      "duck",
      "goose",
      "rabbit",
      "mouse",
      "cat",
      "dog",
      "frog",
      "fox",
      "owl",
      "badger",
      "hedgehog",
      "deer",
      "turkey",
      "donkey"
    ];
    return avatars[Random().nextInt(avatars.length)];
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isProcessing = true;
      _statusText = t.D03_TaskCreate_Confirm.creating_task;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. 寫入 DB
      final docRef = await FirebaseFirestore.instance.collection('tasks').add({
        'name': widget.taskName,
        'captainUid': user.uid,
        'memberCount': 1,
        'maxMembers': widget.memberCount,
        'baseCurrency': widget.currency,
        'startDate': Timestamp.fromDate(widget.startDate),
        'endDate': Timestamp.fromDate(widget.endDate),
        'createdAt': FieldValue.serverTimestamp(),
        'members': {
          user.uid: {
            'role': 'captain',
            'displayName': user.displayName ?? 'Captain',
            'joinedAt': FieldValue.serverTimestamp(),
            'avatar': _getRandomAvatar(),
            'isLinked': true,
            'hasSeenRoleIntro': false, // 關鍵：讓 Dashboard 跳出 D01
          }
        },
        'activeInviteCode': null,
      });

      // 2. 若有邀請需求 (人數 > 1) -> 產生 Invite Code 並分享
      if (widget.memberCount > 1) {
        setState(() => _statusText = t.D03_TaskCreate_Confirm.preparing_share);

        final callable =
            FirebaseFunctions.instance.httpsCallable('createInviteCode');
        final res = await callable.call({'taskId': docRef.id});
        final data = Map<String, dynamic>.from(res.data);
        final code = data['code'];
        final inviteLink = 'iron-split://join?code=$code';

        // 3. 觸發原生 Share Sheet
        if (mounted) {
          await Share.share(
            t.D03_TaskCreate_Confirm.share_message(
              taskName: widget.taskName,
              code: code,
              link: inviteLink,
            ),
            subject: t.D03_TaskCreate_Confirm.share_subject,
          );
        }
      }

      // 4. 完成 -> S06 Dashboard
      if (mounted) {
        Navigator.pop(context); // 關閉 D03
        context.go('/tasks/${docRef.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return AlertDialog(
      title: Text(t.D03_TaskCreate_Confirm.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 鐵公雞 Placeholder (靜態)
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline,
                    size: 32, color: theme.colorScheme.onSecondaryContainer),
              ),
            ),

            _buildRow(t.D03_TaskCreate_Confirm.label_name, widget.taskName),
            const SizedBox(height: 8),
            _buildRow(t.D03_TaskCreate_Confirm.label_period,
                '${dateFormat.format(widget.startDate)} - ${dateFormat.format(widget.endDate)}'),
            const SizedBox(height: 8),
            _buildRow(t.D03_TaskCreate_Confirm.label_currency, widget.currency),
            const SizedBox(height: 8),
            _buildRow(t.D03_TaskCreate_Confirm.label_members,
                '${widget.memberCount}'),

            if (_isProcessing) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Center(
                  child: Text(_statusText ?? '',
                      style: theme.textTheme.bodySmall)),
            ],
          ],
        ),
      ),
      actions: [
        // Secondary: 返回編輯
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: Text(t.D03_TaskCreate_Confirm.action_back),
        ),
        // Primary: 確認
        FilledButton(
          onPressed: _isProcessing ? null : _handleConfirm,
          child: Text(t.D03_TaskCreate_Confirm.action_confirm),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey)),
        ),
        Expanded(
          child: Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
