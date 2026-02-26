import 'package:flutter/material.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_ratio_stepper.dart';
import 'package:iron_split/gen/strings.g.dart';

class MemberItem extends StatelessWidget {
  final TaskMember member;
  final bool isOwner;
  final ValueChanged<double> onRatioChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isProcessing;
  final bool isEnlarged;

  const MemberItem({
    super.key,
    required this.member,
    required this.isOwner,
    required this.onRatioChanged,
    required this.onDelete,
    required this.onEdit,
    required this.isProcessing,
    required this.isEnlarged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isLinked = member.isLinked;
    final avatarId = member.avatar;
    final ratio = member.defaultSplitRatio;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);
    String displayLabel = member.displayName;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceM, vertical: AppLayout.spaceS),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppLayout.radiusM),
        border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CommonAvatar(
            avatarId: avatarId,
            name: displayLabel,
            radius: AppLayout.radiusXL,
            isLinked: isLinked,
          ),
          const SizedBox(width: AppLayout.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (!isLinked && !isProcessing) ? onEdit : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          displayLabel,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                (!isLinked) ? TextDecoration.underline : null,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: AppLayout.spaceS),
                        Icon(Icons.star_rounded,
                            size: 14, color: colorScheme.primary),
                      ] else if (!isLinked) ...[
                        const SizedBox(width: AppLayout.spaceS),
                        Icon(Icons.edit_rounded,
                            size: 14,
                            color: colorScheme.primary.withValues(alpha: 0.7)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text(
                "${ratio.toStringAsFixed(1)}x",
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppLayout.spaceS),
              CommonRatioStepper(
                value: ratio,
                isEnlarged: isEnlarged,
                onChanged: isProcessing ? (_) {} : onRatioChanged,
                enabled: !isProcessing,
              ),
            ],
          ),
          const SizedBox(width: AppLayout.spaceS),
          if (isOwner)
            const SizedBox(width: 40, height: 40)
          else
            IconButton(
              onPressed: isProcessing ? null : onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.error,
                size: iconSize,
              ),
              tooltip: t.common.buttons.delete,
            ),
        ],
      ),
    );
  }
}
