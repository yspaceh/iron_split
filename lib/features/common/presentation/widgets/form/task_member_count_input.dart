import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskMemberCountInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final Color? fillColor;

  const TaskMemberCountInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 15,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // [風格統一]：使用與 AppTextField/AppSelectField 一致的高度與外觀
    return Container(
      padding: const EdgeInsets.all(16), // 右邊 padding 稍微小一點，因為按鈕本身有 padding
      decoration: BoxDecoration(
        color: fillColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
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

          AppStepper(
              text: '$value',
              onDecrease: value > min ? () => onChanged(value - 1) : null,
              onIncrease: value < max ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }
}
