import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart'; // 確保路徑正確
import 'package:iron_split/features/task/domain/models/activity_log_model.dart';
import 'package:intl/intl.dart';

class ActivityLogBlock extends StatelessWidget {
  final ActivityLogModel log;
  final Map<String, dynamic>? memberData; // 用於顯示頭像 (Optional)

  const ActivityLogBlock({
    super.key,
    required this.log,
    this.memberData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 1. 獲取三段式顯示資料
    final info = log.getDisplayInfo(context);

    // 格式化時間
    final timeStr = DateFormat('yyyy/MM/dd HH:mm').format(log.createdAt);

    final member = memberData?[log.operatorUid] as Map<String, dynamic>?;

    final String avatarId = member?['avatar'];
    final String operatorName = member?['displayName'] as String? ?? 'Unknown';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A. 頭像 (Avatar)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CommonAvatar(
              avatarId: avatarId, // 這裡需依照您的專案邏輯取得操作者頭像
              name: operatorName,
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
                  const SizedBox(height: 6),
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

                const SizedBox(height: 6),

                // 4. 時間與操作者 (Footer)
                Text(
                  "$operatorName • $timeStr",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
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
