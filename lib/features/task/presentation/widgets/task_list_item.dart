import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final String currentUserId; // 用來找「我的頭像」
  final bool isCaptain;
  final VoidCallback onTap;

  const TaskListItem({
    super.key,
    required this.task,
    required this.currentUserId,
    required this.isCaptain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    // 1. 還原：找出我在這個任務裡的資料 (Avatar & DisplayName)
    final myMemberData = task.members[currentUserId] ??
        TaskMember(
          id: currentUserId,
          displayName: 'Unknown Member', // 或使用多國語系字串
          isLinked: false,
          role: 'member',
          joinedAt: DateTime.now(), // 這裡只是為了符合建構子，UI 結算頁面用不到
        );

    // 2. 還原：日期區間顯示邏輯
    String periodText = t.S10_Home_TaskList.date_tbd; // '日期未定'
    if (task.startDate != null && task.endDate != null) {
      periodText =
          '${dateFormat.format(task.startDate!)} - ${dateFormat.format(task.endDate!)}';
    }

    // 3. 卡片本體
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(minHeight: 64), // 上下留白，讓背景透出來
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // 純白背景
        borderRadius: BorderRadius.circular(16), // 精緻圓角
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CommonAvatar(
                        avatarId: myMemberData.avatar,
                        name: myMemberData.displayName,
                        isLinked: myMemberData.isLinked),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // 日期顯示
                          Text(
                            periodText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
