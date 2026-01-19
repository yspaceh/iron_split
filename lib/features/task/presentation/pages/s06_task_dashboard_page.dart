import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iron_split/features/task/presentation/dialogs/d01_member_role_intro_dialog.dart';

/// Page Key: S06_TaskDashboard.Main (原 S12)
/// 職責：任務主控台。初次進入時會觸發 D01 角色介紹。
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
  // 用來避免 Dialog 重複跳出
  bool _hasShownIntro = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
      return const Scaffold(body: Center(child: Text('Please Login')));

    return Scaffold(
      appBar: AppBar(
        title: const Text('任務主頁 (S06)'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        // 監聽「當前使用者」在該任務中的資料
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(widget.taskId)
            .collection('members')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final memberDoc = snapshot.data!;
          if (!memberDoc.exists)
            return const Center(child: Text('Member not found'));

          final memberData = memberDoc.data() as Map<String, dynamic>;

          // --- 核心邏輯：檢查是否需要跳出 D01 ---
          // 條件：hasSeenIntro 為 false (或不存在)，且尚未在本頁面跳出過
          final bool hasSeenIntro = memberData['hasSeenIntro'] ?? false;

          if (!hasSeenIntro && !_hasShownIntro) {
            // 使用 Future.microtask 避免在 build 期間 setState
            Future.microtask(() {
              if (!mounted) return;
              _hasShownIntro = true; // 標記為已觸發，避免重複

              showDialog(
                context: context,
                barrierDismissible: false, // 禁止點空白關閉
                builder: (ctx) => D01MemberRoleIntroDialog(
                  taskId: widget.taskId,
                  initialAvatar: memberData['avatar'] ?? 'unknown',
                  canReroll: !(memberData['hasRerolled'] ?? false),
                ),
              ).then((_) {
                // Dialog 關閉後的回調 (通常 DB 已經 update 了)
              });
            });
          }
          // ------------------------------------

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('歡迎, ${memberData['displayName']}'),
                const SizedBox(height: 16),
                Text('你的角色: ${memberData['role']}'),
                Text('你的頭像: ${memberData['avatar']}'),
                const SizedBox(height: 32),
                const Text('這裡是記帳主畫面...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
