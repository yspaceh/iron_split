import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S10_Home.TaskList
class S10HomeTaskListPage extends StatefulWidget {
  const S10HomeTaskListPage({super.key});

  @override
  State<S10HomeTaskListPage> createState() => _S10HomeTaskListPageState();
}

class _S10HomeTaskListPageState extends State<S10HomeTaskListPage> {
  int _selectedIndex = 0; // 0: 進行中, 1: 已完成

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (user == null) {
      return Scaffold(body: Center(child: Text(t.common.please_login)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S10_Home_TaskList.title), // '我的任務'
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings/tos'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: Text(t.S16_TaskCreate_Edit.title),
        shape: const StadiumBorder(),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: colorScheme.surface,
            child: Column(
              children: [
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.catching_pokemon,
                        size: 64,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.S10_Home_TaskList.mascot_preparing, // "鐵公雞準備中..."
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: colorScheme.outline),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<int>(
                    segments: [
                      ButtonSegment(
                        value: 0,
                        label:
                            Text(t.S10_Home_TaskList.tab_in_progress), // '進行中'
                        icon: const Icon(Icons.directions_run),
                      ),
                      ButtonSegment(
                        value: 1,
                        label: Text(t.S10_Home_TaskList.tab_completed), // '已完成'
                        icon: const Icon(Icons.done_all),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Center(
                      child: Text(t.common
                          .error_prefix(message: snapshot.error.toString())));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];

                final myDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final members = data['members'] as Map<String, dynamic>?;

                  final isMember =
                      members != null && members.containsKey(user.uid);
                  if (!isMember) return false;

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
                          _selectedIndex == 0
                              ? t.S10_Home_TaskList
                                  .empty_in_progress // '目前沒有進行中的任務'
                              : t.S10_Home_TaskList
                                  .empty_completed, // '沒有已完成的任務'
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
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
    String periodText = t.S10_Home_TaskList.date_tbd; // '日期未定'
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
              title: Text(t.S10_Home_TaskList.delete_confirm_title), // '確認刪除'
              content: Text(
                  t.S10_Home_TaskList.delete_confirm_content), // '確定要刪除這個任務嗎？'
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(t.common.cancel)), // '取消'
                TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(t.common.delete)), // '刪除'
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
