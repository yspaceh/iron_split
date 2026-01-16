import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 修正 Import 路徑
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';

/// Page Key: S02_Home.TaskList
/// 職責：顯示使用者參與的所有任務列表
class S02HomeTaskListPage extends StatelessWidget {
  const S02HomeTaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    // 若未登入，顯示簡易提示 (或由 Router 重導)
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please Login')));
    }

    return Scaffold(
      appBar: AppBar(
        // 暫用 title，實際可依需求增加 S02 的 i18n key
        title: Text(t.S04_Invite_Confirm.title.replaceAll('加入', '我的')), 
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: 前往設定頁面
            },
          ),
        ],
      ),
      // 懸浮按鈕：導向 S05 建立頁面
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 確保您的 Router 有定義這個路徑
          context.push('/tasks/create'); 
        },
        icon: const Icon(Icons.add),
        label: Text(t.S05_TaskCreate_Form.title.replaceAll('建立', '')), // "新任務"
      ),
      body: StreamBuilder<QuerySnapshot>(
        // 依據 user.uid 過濾任務 (MVP 先以此為例，建議建立索引)
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_outlined, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.push('/tasks/create'),
                    child: Text(t.S05_TaskCreate_Form.title),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return _TaskCard(taskId: doc.id, data: data);
            },
          );
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic> data;

  const _TaskCard({required this.taskId, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = data['name'] ?? 'Task';
    final int memberCount = data['memberCount'] ?? 0;
    final int maxMembers = data['maxMembers'] ?? 0;
    
    final String? activeInviteCode = data['activeInviteCode'];
    final Timestamp? inviteExpiresAtTs = data['activeInviteExpiresAt'];
    
    // 檢查邀請碼有效性
    bool isInviteValid = false;
    if (activeInviteCode != null && activeInviteCode.isNotEmpty && inviteExpiresAtTs != null) {
      final expiresAt = inviteExpiresAtTs.toDate();
      if (expiresAt.isAfter(DateTime.now())) isInviteValid = true;
    }

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/tasks/$taskId'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.airplane_ticket, color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.group_outlined, size: 14, color: colorScheme.outline),
                            const SizedBox(width: 4),
                            Text(
                              '$memberCount / $maxMembers',
                              style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 既有任務的邀請按鈕
                  IconButton.filledTonal(
                    onPressed: () => _showInviteDialog(context, activeInviteCode, isInviteValid, name),
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    tooltip: 'Invite',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, String? currentCode, bool isValid, String taskName) {
    showDialog(
      context: context,
      builder: (context) {
        return D03TaskCreateConfirmDialog(
          taskId: taskId,
          taskName: taskName,
          inviteCode: isValid ? currentCode : null, 
        );
      },
    );
  }
}