import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/gen/strings.g.dart';

class RecordCard extends StatelessWidget {
  final Translations t;
  final double amount;
  final String methodLabel;
  final List<String> memberIds;
  final String? note;
  final VoidCallback onTap;
  final bool isBaseCard;
  final bool showSplitAction;
  final VoidCallback? onSplitTap;
  final CurrencyConstants selectedCurrencyConstants;
  final List<TaskMember> members;
  final bool isPrepay;
  final bool isEnlarged;

  const RecordCard({
    super.key,
    required this.t,
    required this.amount,
    required this.methodLabel,
    required this.memberIds,
    this.note,
    required this.onTap,
    this.onSplitTap,
    required this.selectedCurrencyConstants,
    required this.members,
    this.isBaseCard = false,
    this.showSplitAction = false,
    this.isPrepay = false,
    required this.isEnlarged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    // [風格調整]：Blueprint / Outlined Style
    // 背景純白，搭配細灰色邊框，強調這是「計算結果/容器」而非輸入框
    return Card(
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surface, // 純白背景
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppLayout.radiusL),
        // 加上淡灰色邊框 (Outline)
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 上半部：可點擊的資訊區
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppLayout.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: 金額 + 分帳標籤
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 金額顯示
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${selectedCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(amount, selectedCurrencyConstants.code)}",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isPrepay
                                  ? colorScheme.tertiary
                                  : colorScheme.primary,
                              letterSpacing: -0.5, // 稍微緊湊一點的數字感
                            ),
                          ),
                        ),
                      ),

                      // [風格調整] 分帳標籤：淡色膠囊
                      Container(
                        margin: const EdgeInsets.only(left: AppLayout.spaceXS),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppLayout.spaceS,
                            vertical: AppLayout.spaceXS), // 稍微寬一點
                        decoration: ShapeDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          shape: StadiumBorder(),
                        ),

                        child: Text(
                          SplitMethodConstant.getLabel(context, methodLabel, t),
                          style: textTheme.labelSmall?.copyWith(
                            // 使用深色文字
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppLayout.spaceM),

                  // Row 2: 名稱 + 成員頭像
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 左邊：項目名稱 (Note) 或 Base Title
                      Expanded(
                        flex: 4,
                        child: note != null
                            ? Text(
                                note!,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : (isBaseCard
                                ? Text(
                                    t.S15_Record_Edit.base_card,
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : const SizedBox.shrink()),
                      ),

                      const SizedBox(width: 8),

                      // 右邊：成員頭像 (維持原樣)
                      Expanded(
                        flex: 6,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CommonAvatarStack(
                            allMembers: members,
                            targetMemberIds: memberIds,
                            radius: AppLayout.radiusM,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 下半部：分拆按鈕 (僅 Base Card 且還有餘額時顯示)
          if (showSplitAction && onSplitTap != null) ...[
            // 分隔線改淡一點
            Divider(
              height: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            InkWell(
              onTap: onSplitTap,
              // 增加按壓回饋顏色
              overlayColor: WidgetStateProperty.all(
                  colorScheme.primary.withValues(alpha: 0.05)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: AppLayout.spaceL), // 增加點擊高度
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: iconSize,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppLayout.spaceS),
                    Text(
                      t.S15_Record_Edit.buttons.add_item,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
