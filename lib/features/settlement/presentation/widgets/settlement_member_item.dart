import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class SettlementMemberItem extends StatelessWidget {
  final SettlementMember member;
  final CurrencyConstants baseCurrency;

  // ✅ Pure UI: 只接收 callback，不處理導航邏輯
  final VoidCallback onMergeTap;

  const SettlementMemberItem({
    super.key,
    required this.member,
    required this.baseCurrency,
    required this.onMergeTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 狀態判斷
    final isReceiving = member.finalAmount > 0;
    final amountColor = isReceiving ? Colors.green[700] : colorScheme.onSurface;
    final amountPrefix = isReceiving
        ? t.s30_settlement_confirm.label_refund
        : t.s30_settlement_confirm.label_payable;
    final displayFinal =
        CurrencyConstants.formatAmount(member.finalAmount, baseCurrency.code);

    // 按鈕文字與圖示狀態 (如果是代表，顯示編輯；否則顯示合併)
    final actionLabel = member.isMergedHead
        ? t.common.buttons.edit // "編輯"
        : t.s30_settlement_confirm.list_item.merged_label; // "合併"

    final actionIcon = member.isMergedHead ? Icons.edit_outlined : Icons.link;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      clipBehavior: Clip.antiAlias, // 確保 InkWell 不會超出圓角
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      // 使用 IntrinsicHeight 讓右邊的分隔線與按鈕高度自動填滿卡片高度
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- [左側 80-85%] 主要資訊區 ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Row 1: Avatar + Name + Amount
                    Row(
                      children: [
                        CommonAvatar(
                          avatarId: member.avatar,
                          name: member.displayName,
                          isLinked: member.isLinked,
                          radius: 20,
                        ),
                        const SizedBox(width: 12),

                        // Name & Tag
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.displayName,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (member.isMergedHead)
                                Text(
                                  // 顯示 "(含 X 人)" 之類的副標
                                  '${t.s30_settlement_confirm.list_item.includes} ${member.subMembers.length}',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Final Amount
                        Text(
                          amountPrefix,
                          style: textTheme.titleMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${baseCurrency.symbol} $displayFinal',
                          style: textTheme.titleMedium?.copyWith(
                            color: amountColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Row 2: Detail Text (本金 + 餘額)
                    // 如果是 Head，顯示包含成員；如果是個人，顯示算式
                    member.isMergedHead
                        ? Text(
                            member.subMembers
                                .map((e) => e.displayName)
                                .join(", "),
                            style: textTheme.bodySmall
                                ?.copyWith(color: colorScheme.outline),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : _buildDetailText(
                            member, baseCurrency, t, textTheme, colorScheme),
                  ],
                ),
              ),
            ),

            // --- [中間] 分隔線 ---
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              indent: 8, // 上方留白
              endIndent: 8, // 下方留白
            ),

            // --- [右側 15-20%] 合併按鈕區 (Compact) ---
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onMergeTap, // 呼叫外部傳入的邏輯 (開啟 B04)
                child: Container(
                  width: 56, // 固定寬度，保持方形/長條感
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        actionIcon,
                        size: 20,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        actionLabel,
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(
    SettlementMember m,
    CurrencyConstants baseCurrency,
    Translations t,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final displayBase =
        CurrencyConstants.formatAmount(m.baseAmount, baseCurrency.code);
    final displayRemainder =
        CurrencyConstants.formatAmount(m.remainderAmount, baseCurrency.code);

    // 簡單的文字串接，保持低調
    String text =
        '${t.s30_settlement_confirm.list_item.principal} $displayBase';

    if (m.isRemainderHidden) {
      text += ' + ?';
    } else if (m.remainderAmount.abs() > 0.000001) {
      text +=
          ' + ${t.s30_settlement_confirm.list_item.remainder} $displayRemainder';
    }

    return Text(
      text,
      style: textTheme.bodySmall?.copyWith(
        fontSize: 11,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
