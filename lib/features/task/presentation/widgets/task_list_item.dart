import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
    final textTheme = theme.textTheme;
    final t = Translations.of(context);
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final iconSize = AppLayout.inlineIconSize(isEnlarged);
    final dateFormat = DateFormat('yyyy/MM/dd');

    // 1. 還原：找出我在這個任務裡的資料 (Avatar & DisplayName)
    final myMemberData = task.members[currentUserId] ??
        TaskMember(
          id: currentUserId,
          displayName: 'Unknown Member', // 或使用多國語系字串
          isLinked: false,
          role: 'member',
          joinedAt: DateTime.now(), // 這裡只是為了符合建構子，UI 結算頁面用不到
          createdAt: DateTime.now(),
        );

    // 2. 還原：日期區間顯示邏輯
    String periodText = t.s10_home_task_list.date_tbd; // '日期未定'
    if (task.startDate != null && task.endDate != null) {
      periodText =
          '${dateFormat.format(task.startDate!)} - ${dateFormat.format(task.endDate!)}';
    }

    // 3. 卡片本體
    return Container(
      margin: const EdgeInsets.only(bottom: AppLayout.spaceS),
      constraints: const BoxConstraints(minHeight: 64), // 上下留白，讓背景透出來
      decoration: BoxDecoration(
        color: colorScheme.surface, // 純白背景
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
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
              borderRadius: BorderRadius.circular(AppLayout.radiusL),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppLayout.spaceL, vertical: AppLayout.spaceS),
                child: Row(
                  children: [
                    CommonAvatar(
                        avatarId: myMemberData.avatar,
                        name: myMemberData.displayName,
                        isLinked: myMemberData.isLinked),
                    const SizedBox(width: AppLayout.spaceL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: isEnlarged ? null : 1,
                            overflow: isEnlarged ? null : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppLayout.spaceXS),
                          // 日期顯示
                          Text(
                            periodText,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_outlined,
                        size: iconSize, color: colorScheme.onSurfaceVariant),
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
