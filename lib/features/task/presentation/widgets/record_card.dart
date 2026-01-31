import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
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
  });

  String _getSplitMethodLabel(Translations t, String method) {
    switch (method) {
      case 'even':
        return t.S15_Record_Edit.method_even;
      case 'exact':
        return t.S15_Record_Edit.method_exact;
      case 'percent':
        return t.S15_Record_Edit.method_percent;
      default:
        return method;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      // 稍微加深底色，讓卡片更明顯
      color: isBaseCard
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide.none,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${selectedCurrencyConstants.symbol} ${CurrencyConstants.formatAmount(amount, selectedCurrencyConstants.code)}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800, // 加粗
                          color: colorScheme.onSurface, // 深黑色
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary, // 改用實心主色
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getSplitMethodLabel(t, methodLabel),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary, // 白字
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end, // 底部對齊
                    children: [
                      // 左邊：說明文字 (給予彈性空間，但保留右邊給頭像)
                      Expanded(
                        flex: 4, // 左邊佔 40%
                        child: note != null
                            ? Text(
                                note ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500),
                                maxLines: 2, // 允許換行
                                overflow: TextOverflow.ellipsis,
                              )
                            : (isBaseCard
                                ? Text(t.S15_Record_Edit.base_card_title,
                                    style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500))
                                : const SizedBox.shrink()),
                      ),
                      const SizedBox(width: 8),
                      // 右邊：頭像區 (給予更多空間顯示兩行)
                      Expanded(
                        flex: 6, // 右邊佔 60%
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CommonAvatarStack(
                            allMembers: members,
                            targetMemberIds: memberIds,
                            radius: 11,
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

          // 下半部：分拆按鈕 (黏在卡片底部)
          if (showSplitAction && onSplitTap != null) ...[
            Divider(height: 1, color: colorScheme.outlineVariant),
            InkWell(
              onTap: onSplitTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.S15_Record_Edit.add_item,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
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
