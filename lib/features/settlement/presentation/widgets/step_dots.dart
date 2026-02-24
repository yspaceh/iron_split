import 'package:flutter/material.dart';

class StepDots extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color? activeColor;

  const StepDots({
    super.key,
    this.totalSteps = 2,
    required this.currentStep,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = activeColor ?? colorScheme.primary;

    return SizedBox(
      width: 24, // 鎖定寬度，避免在 AppBar 裡飄移
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps * 2 - 1, (index) {
          // 偶數索引 (0, 2, 4...) 是圓點
          if (index % 2 == 0) {
            final stepIndex = index ~/ 2 + 1;
            final isActive = stepIndex == currentStep;
            final isPassed = stepIndex < currentStep;

            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive || isPassed)
                    ? primaryColor
                    : colorScheme.surfaceContainerLow,
                border: Border.all(
                  color: (isActive || isPassed)
                      ? primaryColor
                      : primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            );
          }

          // 奇數索引 (1, 3, 5...) 是連接線
          return Expanded(
            child: Container(
              height: 1.5,
              color: primaryColor.withValues(alpha: 0.2),
            ),
          );
        }),
      ),
    );
  }
}
