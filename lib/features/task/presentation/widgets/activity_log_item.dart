import 'package:flutter/material.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart'; // 確保路徑正確
import 'package:iron_split/features/task/data/models/activity_log_model.dart';
import 'package:intl/intl.dart';

class ActivityLogItem extends StatelessWidget {
  final ActivityLogModel log;
  final Map<String, TaskMember>? members; // 用於顯示頭像 (Optional)

  const ActivityLogItem({
    super.key,
    required this.log,
    this.members,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 1. 獲取三段式顯示資料
    final info = log.getDisplayInfo(context);

    // 格式化時間
    final timeStr = DateFormat('yyyy/MM/dd HH:mm').format(log.createdAt);

    final member = members?[log.operatorUid] ??
        TaskMember(
          id: log.operatorUid,
          displayName: 'Unknown Member', // 或使用多國語系字串
          isLinked: false,
          role: 'member',
          joinedAt: DateTime.now(), // 這裡只是為了符合建構子，UI 結算頁面用不到
        );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. 頭像 (Avatar)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CommonAvatar(
              avatarId: member.avatar, // 這裡需依照您的專案邏輯取得操作者頭像
              name: member.displayName,
              isLinked: member.isLinked,
              radius: 20,
            ),
          ),
          const SizedBox(width: 12),

          // B. 文字內容 (Text Content)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. 標題 (Title) - 例如 "新增記帳：[支出]"
                Text(
                  info.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),

                // 2. 主要內容 (Main Line) - 例如 "晚餐 (3000) • 支付..."
                Text(
                  info.mainLine,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                // 3. 詳細內容 (Sub Line) - 例如 "- drink (...)\n- base (...)"
                // 只有在有資料時才顯示
                if (info.subLine != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: colorScheme.outlineVariant,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      info.subLine!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.8), // 稍微淡一點
                        height: 1.5, // 增加行距讓多行好讀
                        fontFamily: 'RobotoMono', // (選填) 如果想要對齊數字可用等寬字體
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 4),

                // 4. 時間與操作者 (Footer)
                Text(
                  "${member.displayName} • $timeStr",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
