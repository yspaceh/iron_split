import 'package:flutter/material.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_ratio_stepper.dart';
import 'package:iron_split/gen/strings.g.dart';

class MemberItem extends StatelessWidget {
  final Map<String, dynamic> member;
  final bool isOwner;
  final ValueChanged<double> onRatioChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isProcessing;

  const MemberItem({
    super.key,
    required this.member,
    required this.isOwner,
    required this.onRatioChanged,
    required this.onDelete,
    required this.onEdit,
    required this.isProcessing,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    final isLinked =
        member['status'] == 'linked' || (member['isLinked'] == true);
    final avatarId = member['avatar'];
    final ratio = (member['defaultSplitRatio'] as num? ?? 1.0).toDouble();

    String displayLabel;
    if (isLinked) {
      displayLabel = member['displayName'] ??
          t.S53_TaskSettings_Members.member_default_name;
    } else {
      displayLabel = member['displayName'] ??
          t.S53_TaskSettings_Members.member_default_name;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CommonAvatar(
            avatarId: avatarId,
            name: displayLabel,
            radius: 20,
            isLinked: isLinked,
          ),
          const SizedBox(width: 12),
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                (!isLinked) ? TextDecoration.underline : null,
                            decorationStyle: TextDecorationStyle.dotted,
                            decorationColor: theme.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOwner) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.star_rounded,
                            size: 14, color: theme.colorScheme.primary),
                      ] else if (!isLinked) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.edit_rounded,
                            size: 14,
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.7)),
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
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              CommonRatioStepper(
                value: ratio,
                onChanged: isProcessing ? (_) {} : onRatioChanged,
                enabled: !isProcessing,
              ),
            ],
          ),
          const SizedBox(width: 8),
          if (isOwner)
            const SizedBox(width: 40, height: 40)
          else
            IconButton(
              onPressed: isProcessing ? null : onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              tooltip: t.common.delete,
            ),
        ],
      ),
    );
  }
}
