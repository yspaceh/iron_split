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
    final myAvatar = myMemberData['avatar'] ?? 'cow'; // 預設 cow
    final myDisplayName = myMemberData['displayName'] as String?;

    // 2. 還原：日期區間顯示邏輯
    String periodText = t.S10_Home_TaskList.date_tbd; // '日期未定'
    if (task.startDate != null && task.endDate != null) {
      periodText =
          '${dateFormat.format(task.startDate!)} - ${dateFormat.format(task.endDate!)}';
    }

    // 3. 卡片本體
    Widget cardContent = Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 核心修正：這裡顯示的是「我在這個任務的頭像」，而非任務 Icon
              CommonAvatar(
                avatarId: myAvatar,
                name: myDisplayName,
                radius: 28,
              ),
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

    // 4. 側滑刪除 (保持不變)
    if (!isCaptain) {
      return cardContent;
    }

    return Dismissible(
      key: Key(task.id),
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
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(t.S10_Home_TaskList.delete_confirm_title),
            content: Text(t.S10_Home_TaskList.delete_confirm_content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(t.common.buttons.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(t.common.buttons.delete),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        onDelete();
      },
      child: cardContent,
    );
  }
}
