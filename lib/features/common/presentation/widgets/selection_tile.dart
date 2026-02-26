// lib/features/common/presentation/widgets/selection_tile.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_indicator.dart';
import 'package:provider/provider.dart';

class SelectionTile extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? isSelectedBackgroundColor;
  final bool isRadio;

  const SelectionTile({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.leading,
    required this.title,
    this.trailing,
    this.backgroundColor,
    required this.isRadio,
    this.isSelectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final bool isDisabled = onTap == null;
    final Color effectiveBackgroundColor = isSelected && !isDisabled
        ? isSelectedBackgroundColor ?? colorScheme.surfaceContainerLow
        : backgroundColor ?? colorScheme.surface;
    final double opacity = isDisabled ? 0.8 : 1.0;
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final name = Text(
      title,
      style: textTheme.titleMedium?.copyWith(
        // [修改] 使用 titleMedium 讓文字更有份量
        // [修改] 選中時變色 (Primary Color)，與 SelectionCard 一致
        color: colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );

    final indicator = SelectionIndicator(
      isSelected: isSelected,
      isRadio: isRadio, // 傳遞樣式
    );

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: isEnlarged ? AppLayout.spaceS : AppLayout.spaceXS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // [修改] 內距加大，符合卡片風格
          padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.spaceL, vertical: AppLayout.spaceM),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(AppLayout.radiusL),
          ),
          child: Opacity(
            opacity: opacity,
            child: isEnlarged
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          indicator,
                          const SizedBox(width: AppLayout.spaceS),
                          if (leading != null) ...[
                            leading ?? Container(),
                            const SizedBox(width: AppLayout.spaceS),
                          ],
                          Expanded(
                            child: name,
                          ),
                        ],
                      ),
                      if (trailing != null) ...[
                        const SizedBox(height: AppLayout.spaceS),
                        trailing!,
                      ]
                    ],
                  )
                : Row(
                    children: [
                      indicator,
                      const SizedBox(width: AppLayout.spaceS),
                      if (leading != null) ...[
                        leading ?? Container(),
                        const SizedBox(width: AppLayout.spaceS),
                      ],
                      Expanded(
                        child: name,
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
