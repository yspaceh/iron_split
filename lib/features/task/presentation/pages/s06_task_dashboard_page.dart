import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S06_TaskDashboard.Main
class S06TaskDashboardPage extends StatefulWidget {
  final String taskId;

  const S06TaskDashboardPage({
    super.key,
    required this.taskId,
  });

  @override
  State<S06TaskDashboardPage> createState() => _S06TaskDashboardPageState();
}

class _S06TaskDashboardPageState extends State<S06TaskDashboardPage> {
  bool _hasShownIntro = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S06_TaskDashboard_Main.title), // '任務主頁'
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .collection('members')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
                child: Text(
                    t.common.error_prefix(message: snapshot.error.toString())));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final memberDoc = snapshot.data!;
          if (!memberDoc.exists)
            return Center(
                child: Text(t.S06_TaskDashboard_Main
                    .error_member_not_found)); // '找不到成員資料'

          final memberData = memberDoc.data() as Map<String, dynamic>;

          final bool hasSeenIntro = memberData['hasSeenIntro'] ?? false;

          if (!hasSeenIntro && !_hasShownIntro) {
            Future.microtask(() {
              if (!mounted) return;
              _hasShownIntro = true;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => D01MemberRoleIntroDialog(
                  taskId: widget.taskId,
                  initialAvatar: memberData['avatar'] ?? 'unknown',
                  canReroll: !(memberData['hasRerolled'] ?? false),
                ),
              );
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.S06_TaskDashboard_Main.welcome_message(
                    name: memberData['displayName'])), // '歡迎, ${name}'
                const SizedBox(height: 16),
                Text(t.S06_TaskDashboard_Main.role_label(
                    role: memberData['role'])), // '你的角色: ${role}'
                Text(t.S06_TaskDashboard_Main.avatar_label(
                    avatar: memberData['avatar'])), // '你的頭像: ${avatar}'
                const SizedBox(height: 32),
                Text(t.S06_TaskDashboard_Main
                    .placeholder_content), // '這裡是記帳主畫面...'
              ],
            ),
          );
        },
      ),
    );
  }
}
