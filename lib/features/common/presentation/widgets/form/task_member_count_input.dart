import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemberCountInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const TaskMemberCountInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 15,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // [風格統一]：使用與 AppTextField/AppSelectField 一致的高度與外觀
    return Container(
      height: 54,
      padding: const EdgeInsets.only(
          left: 16, right: 8), // 右邊 padding 稍微小一點，因為按鈕本身有 padding
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow, // 淡灰底
        borderRadius: BorderRadius.circular(16), // 圓角 16
      ),
      child: Row(
        children: [
          // 1. 左側圖示 (降噪：深灰色)
          Icon(
            Icons.groups_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 24,
          ),

          const SizedBox(width: 12),

          // 2. 標題文字
          Expanded(
            child: Text(
              t.S16_TaskCreate_Edit.label.member_count,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // 3. 右側 Stepper 控制區
          // 減號按鈕
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            // 不能按時變灰，可以按時變深灰或主色
            color: value > min
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.5),
            iconSize: 24,
            padding: EdgeInsets.zero, // 緊湊一點
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),

          // 數值顯示
          Container(
            constraints: const BoxConstraints(minWidth: 24),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                // 數字用主色強調，或是保持黑色
                color: colorScheme.onSurface,
              ),
            ),
          ),

          // 加號按鈕
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: value < max
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.5),
            iconSize: 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
