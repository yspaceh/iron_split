import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S02_Home.TaskList
/// CSV Page 3, 4, 5
/// 職責：顯示任務列表，包含「進行中」與「已完成」的分頁切換。
class S02HomeTaskListPage extends StatefulWidget {
  const S02HomeTaskListPage({super.key});

  @override
  State<S02HomeTaskListPage> createState() => _S02HomeTaskListPageState();
}

class _S02HomeTaskListPageState extends State<S02HomeTaskListPage> {
  // 0: 進行中, 1: 已完成
  int _selectedIndex = 0;

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
      // 懸浮按鈕：新增任務 (S05)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/create'),
        icon: const Icon(Icons.add),
        label: Text(t.S05_TaskCreate_Form.title),
      ),
      body: Column(
        children: [
          // --- 1. SegmentedButton (CSV UI Block) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
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
          ),

          const Divider(height: 1),

          // --- 2. 任務列表 ---
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

                // 過濾任務：我參與的 + 狀態篩選
                // 註：MVP 資料庫尚未有 status 欄位，這裡暫時將所有任務視為「進行中」
                // TODO: 未來需根據 task['status'] == 'finished' 來區分 _selectedIndex
                final myDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final members = data['members'] as Map<String, dynamic>?;

                  // 1. 必須是我參與的
                  final isMember =
                      members != null && members.containsKey(user.uid);
                  if (!isMember) return false;

                  // 2. 狀態篩選 (MVP 暫時邏輯：全部顯示在「進行中」，「已完成」顯示為空)
                  if (_selectedIndex == 0) return true; // 進行中
                  return false; // 已完成 (暫無資料)
                }).toList();

                // --- 3. 空狀態 (CSV Page 3) ---
                if (myDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TODO: 替換為鐵公雞動畫 (Iron Rooster Animation)
                        Icon(Icons.catching_pokemon,
                            size: 80, color: colorScheme.outlineVariant),
                        const SizedBox(height: 16),
                        Text(
                          _selectedIndex == 0 ? '目前沒有進行中的任務' : '沒有已完成的任務',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(color: colorScheme.outline),
                        ),
                        if (_selectedIndex == 0) ...[
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: () => context.push('/tasks/create'),
                            child: Text(t.S05_TaskCreate_Form.title),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                // --- 4. 列表內容 (CSV Page 4, 5) ---
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: myDocs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final doc = myDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // 取得我在這個任務中的資料 (頭像)
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

    // 處理日期顯示
    final Timestamp? startTs = data['startDate'];
    final Timestamp? endTs = data['endDate'];
    String periodText = '日期未定';
    if (startTs != null && endTs != null) {
      periodText =
          '${dateFormat.format(startTs.toDate())} - ${dateFormat.format(endTs.toDate())}';
    }

    // 建構卡片內容
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
              // 1. 用戶的農場動物頭像 (CSV 規格)
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                // TODO: 這裡之後要換成實際的 Animal Asset Image
                child: Text(
                  myAvatar.isNotEmpty ? myAvatar[0].toUpperCase() : '?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 2. 任務名稱與期間
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.date_range,
                            size: 14, color: colorScheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          periodText,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: colorScheme.outline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. 箭頭
              Icon(Icons.chevron_right, color: colorScheme.outlineVariant),
            ],
          ),
        ),
      ),
    );

    // 實作左滑刪除 (CSV Page 4: 隊長可以左滑刪除)
    if (isCaptain) {
      return Dismissible(
        key: Key(taskId),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: colorScheme.error,
          child: Icon(Icons.delete_outline, color: colorScheme.onError),
        ),
        confirmDismiss: (direction) async {
          // TODO: 這裡需要檢查 "未有紀錄且沒有成員" 的條件
          // 若不符合條件應彈出提示。目前 MVP 先顯示簡單確認。
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
