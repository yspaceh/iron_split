// lib/features/common/presentation/widgets/app_stepper.dart

import 'package:flutter/material.dart';

class AppStepper extends StatelessWidget {
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final String? text;
  final double iconSize;
  final double height;
  final bool enabled;

  const AppStepper({
    super.key,
    required this.onDecrease,
    required this.onIncrease,
    this.text, //
    this.iconSize = 18,
    this.height = 40,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final disableColor = colorScheme.onSurface.withValues(alpha: 0.3);
    final dividerColor = colorScheme.outlineVariant;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. 減號
          _buildButton(
            icon: Icons.remove,
            onTap: onDecrease,
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(20)),
            color: enabled ? colorScheme.onSurface : disableColor,
          ),

          // 2. 中間區域 (如果有文字)
          if (text != null) ...[
            Container(width: 1, height: height, color: dividerColor), // 分隔線

            // 數值顯示區 (固定最小寬度以防跳動)
            Container(
              constraints: const BoxConstraints(minWidth: 40),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Text(
                text!,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),

            Container(width: 1, height: height, color: dividerColor), // 分隔線
          ] else ...[
            // 如果沒文字，就只顯示一條分隔線 (舊樣式)
            Container(width: 1, height: height * 0.6, color: dividerColor),
          ],

          // 3. 加號
          _buildButton(
            icon: Icons.add,
            onTap: onIncrease,
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(20)),
            color: enabled ? colorScheme.onSurface : disableColor,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onTap,
    required BorderRadius borderRadius,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: SizedBox(
          width: height, // 讓按鈕也是正方形或接近正方形，好按
          height: height,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }
}
