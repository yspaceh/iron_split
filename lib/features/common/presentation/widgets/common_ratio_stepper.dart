import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iron_split/core/theme/app_layout.dart';

class CommonRatioStepper extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final bool enabled;
  final bool isEnlarged;

  const CommonRatioStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    required this.isEnlarged,
  });

  void _updateValue(double delta) {
    if (!enabled) return;

    // 邏輯：0.0 ~ 2.0，間隔 0.5 (符合 B03)
    final newValue = (value + delta).clamp(0.0, 2.0);

    if (newValue != value) {
      HapticFeedback.selectionClick();
      onChanged(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    final isMin = value <= 0.0;
    final isMax = value >= 2.0;
    final borderColor = colorScheme.outlineVariant;

    return Container(
      height: 32, // 固定高度，符合 B03 視覺
      decoration: BoxDecoration(
        color: enabled
            ? null
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppLayout.radiusS),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 減號按鈕
          _buildButton(
            context,
            colorScheme,
            icon: Icons.remove,
            iconSize: iconSize,
            onTap: (enabled && !isMin) ? () => _updateValue(-0.5) : null,
            radius: const BorderRadius.horizontal(left: Radius.circular(7)),
          ),

          // 分隔線
          Container(
            width: 1,
            height: 16,
            color: borderColor,
          ),

          // 加號按鈕
          _buildButton(
            context,
            colorScheme,
            icon: Icons.add,
            iconSize: iconSize,
            onTap: (enabled && !isMax) ? () => _updateValue(0.5) : null,
            radius: const BorderRadius.horizontal(right: Radius.circular(7)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    ColorScheme colorScheme, {
    required IconData icon,
    required VoidCallback? onTap,
    required BorderRadius radius,
    required double iconSize,
  }) {
    final isDisabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10), // 調整寬度以好點擊
          child: Icon(
            icon,
            size: iconSize,
            color: isDisabled
                ? colorScheme.outline.withValues(alpha: 0.3)
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
