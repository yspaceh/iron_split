import 'package:flutter/material.dart';
import 'package:iron_split/gen/strings.g.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // --- M3 8dp Grid System 定義 ---
    // 總高度限制: 32.0 (4 * 8)
    const double circleSize = 16.0; // (2 * 8) 標準小尺寸
    const double spacing = 4.0; // (0.5 * 8) 標準最小間距
    const double lineHeight = 2.0; // 線條粗細

    // 根據狀態決定線條顏色
    final lineColor = currentStep >= 2
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    return Container(
      // 左右 Padding 設為 24 (3 * 8)
      padding: const EdgeInsets.symmetric(horizontal: 24),
      // 強制高度為 32 (4 * 8)
      height: 32,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 靠上對齊
        children: [
          // Step 1
          _buildStep(
            context,
            '1',
            t.s30_settlement_confirm.steps.confirm_amount,
            isActive: currentStep >= 1,
            circleSize: circleSize,
            spacing: spacing,
          ),

          // 連接線 (Connector)
          Expanded(
            child: Container(
              height: lineHeight,
              // [對齊計算]:
              // 線要在圓圈(16)的正中間 => top = (16 - 2) / 2 = 7
              // 7 不是整數網格，但在對齊上這是幾何必然，視覺上是準確的
              margin: const EdgeInsets.only(
                  left: 8, right: 8, top: (circleSize - lineHeight) / 2),
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),

          // Step 2
          _buildStep(
            context,
            '2',
            t.s30_settlement_confirm.steps.payment_info,
            isActive: currentStep >= 2,
            circleSize: circleSize,
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String label, {
    required bool isActive,
    required double circleSize,
    required double spacing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 顏色邏輯
    final circleColor = isActive ? colorScheme.primary : Colors.transparent;
    final borderColor = isActive ? colorScheme.primary : colorScheme.outline;
    final textColor =
        isActive ? colorScheme.onPrimary : colorScheme.onSurfaceVariant;
    final labelColor =
        isActive ? colorScheme.primary : colorScheme.onSurfaceVariant;

    // 字體樣式
    // 使用 M3 定義的 Label Small，但強制縮小到適合 12dp 高度的尺寸
    final labelStyle = textTheme.labelSmall?.copyWith(
      fontSize: 10, // 為了塞進剩餘空間，10sp 是極限
      height: 1.2, // 控制行高，確保文字高度約為 12dp
      color: labelColor,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 圓圈 (16dp)
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 9, // 配合 16dp 圓圈微調字體
                height: 1,
              ),
            ),
          ),
        ),

        // 2. 間距 (4dp)
        SizedBox(height: spacing),

        // 3. 文字 (約 12dp)
        Text(
          label,
          style: labelStyle,
        ),
      ],
    );
  }
}
