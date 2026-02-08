import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
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
  final List<Map<String, dynamic>> members;
  final bool isIncome;

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
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // [風格調整]：Blueprint / Outlined Style
    // 背景純白，搭配細灰色邊框，強調這是「計算結果/容器」而非輸入框
    return Card(
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface, // 純白背景
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // 加上淡灰色邊框 (Outline)
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 上半部：可點擊的資訊區
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: 金額 + 分帳標籤
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 金額顯示
                      Text(
                        "${selectedCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(amount, selectedCurrencyConstants.code)}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isIncome
                              ? theme.colorScheme.tertiary
                              : theme.colorScheme.primary,
                          letterSpacing: -0.5, // 稍微緊湊一點的數字感
                        ),
                      ),

                      // [風格調整] 分帳標籤：淡色膠囊
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4), // 稍微寬一點
                        decoration: BoxDecoration(
                          // 使用淡色背景 (SecondaryContainer 或 PrimaryContainer)
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          SplitMethodConstant.getLabel(context, methodLabel),
                          style: theme.textTheme.labelSmall?.copyWith(
                            // 使用深色文字
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

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
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : (isBaseCard
                                ? Text(
                                    t.S15_Record_Edit.base_card_title,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
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
                            radius: 11, // 頭像大小維持
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
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            InkWell(
              onTap: onSplitTap,
              // 增加按壓回饋顏色
              overlayColor: WidgetStateProperty.all(
                  theme.colorScheme.primary.withValues(alpha: 0.05)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14), // 增加點擊高度
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add, // 改用圓框加號，更有按鈕感
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      t.S15_Record_Edit.buttons.add_item,
                      style: TextStyle(
                        color: theme.colorScheme.primary,
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
