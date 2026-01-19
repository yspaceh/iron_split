import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S02_Home.TaskList
class S02HomeTaskListPage extends StatefulWidget {
  const S02HomeTaskListPage({super.key});

  @override
  State<S02HomeTaskListPage> createState() => _S02HomeTaskListPageState();
}

class _S02HomeTaskListPageState extends State<S02HomeTaskListPage> {
  int _selectedIndex = 0; // 0: 進行中, 1: 已完成

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please Login')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的任務'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings/tos'),
          ),
        ],
      ),
      // FAB 使用 Primary 顏色與圓弧造型
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: Text(t.S05_TaskCreate_Form.title),
        shape: const StadiumBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // --- 上半部固定區域 (Header) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: colorScheme.surface, // 這裡設定背景色
            child: Column(
              children: [
                // 1. 鐵公雞動畫區 (Placeholder)
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    // 加一個淡淡的背景讓區域更明顯 (開發測試用，之後可移除)
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.catching_pokemon, // 動畫暫位圖
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "鐵公雞準備中...",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.outline),
                      )
                    ],
                  ),
                ),

                // 2. 狀態切換器 (SegmentedButton)
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 0,
                        label: Text('進行中'),
                        icon: Icon(Icons.directions_run),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text('已完成'),
                        icon: Icon(Icons.done_all),
                      ),
                    ],
                    selected: {_selectedIndex},
                    onSelectionChanged: (Set<int> newSelection) {
                      setState(() {
                        _selectedIndex = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- 下半部捲動區域 (List) ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(child: Text('Error: ${snapshot.error}'));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                // 過濾與篩選邏輯
                final myDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final members = data['members'] as Map<String, dynamic>?;

                  final isMember =
                      members != null && members.containsKey(user.uid);
                  if (!isMember) return false;

                  // 狀態篩選 (MVP 暫時邏輯：全部視為進行中)
                  if (_selectedIndex == 0) return true;
                  return false;
                }).toList();

                if (myDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 48, color: colorScheme.outlineVariant),
                        const SizedBox(height: 16),
                        Text(
                          _selectedIndex == 0 ? '目前沒有進行中的任務' : '沒有已完成的任務',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant, // 加深文字顏色
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: myDocs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = myDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final members = data['members'] as Map<String, dynamic>;
                    final myData = members[user.uid] as Map<String, dynamic>;

                    return _TaskCard(
                      taskId: doc.id,
                      data: data,
                      myAvatar: myData['avatar'] ?? 'unknown',
                      isCaptain: data['captainUid'] == user.uid,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic> data;
  final String myAvatar;
  final bool isCaptain;

  const _TaskCard({
    required this.taskId,
    required this.data,
    required this.myAvatar,
    required this.isCaptain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('yyyy/MM/dd');

    final String name = data['name'] ?? 'Task';

    final Timestamp? startTs = data['startDate'];
    final Timestamp? endTs = data['endDate'];
    String periodText = '日期未定';
    if (startTs != null && endTs != null) {
      periodText =
          '${dateFormat.format(startTs.toDate())} - ${dateFormat.format(endTs.toDate())}';
    }

    Widget cardContent = Card(
      elevation: 0,
      color: colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/tasks/$taskId'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  myAvatar.isNotEmpty ? myAvatar[0].toUpperCase() : '?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.date_range,
                            size: 16, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          periodText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );

    if (isCaptain) {
      return Dismissible(
        key: Key(taskId),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete_outline, color: colorScheme.onError),
        ),
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('確認刪除'),
              content: const Text('確定要刪除這個任務嗎？'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('取消')),
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('刪除')),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
        },
        child: cardContent,
      );
    }

    return cardContent;
  }
}
