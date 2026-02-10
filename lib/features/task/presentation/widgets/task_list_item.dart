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
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.currentUserId,
    required this.isCaptain,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    // 1. 還原：找出我在這個任務裡的資料 (Avatar & DisplayName)
    final myMemberData = task.members[currentUserId] ?? {};

    // 2. 還原：日期區間顯示邏輯
    String periodText = t.S10_Home_TaskList.date_tbd; // '日期未定'
    if (task.startDate != null && task.endDate != null) {
      periodText =
          '${dateFormat.format(task.startDate!)} - ${dateFormat.format(task.endDate!)}';
    }

    final bool isSettled = task.status == 'settled';

    // 3. 卡片本體
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CommonAvatar(
                      avatarId: myMemberData['avatar'],
                      name: myMemberData['displayName'],
                      isLinked: myMemberData['isLinked'] ?? false),
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
          if (isSettled)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary, // 藍底
                  borderRadius: const BorderRadius.only(
                    // 左下角做圓角設計，右上角不需要設定(因為被 Card 裁切了)
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Text(
                  t.S10_Home_TaskList.label_settlement,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary, // 白字
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
