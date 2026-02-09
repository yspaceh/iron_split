import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/gen/strings.g.dart';

class SettlementMemberItem extends StatelessWidget {
  final SettlementMember member;
  final CurrencyConstants baseCurrency;

  // --- Action 相關參數 ---
  final VoidCallback? onActionTap;
  final bool isActionEnabled;
  final IconData actionIcon;

  const SettlementMemberItem({
    super.key,
    required this.member,
    required this.baseCurrency,
    this.onActionTap,
    this.isActionEnabled = true, // 預設啟用
    this.actionIcon = Icons.link, // 預設為連結圖示
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isGroup = member.subMembers.isNotEmpty;

    // [修改] 移除 Card，改用 Container 且不設 Border
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface, // 純白背景
        borderRadius: BorderRadius.circular(16), // 圓角
        // 這裡不設 border，達到「無邊框」效果
      ),
      clipBehavior: Clip.antiAlias,
      child: isGroup
          ? _buildGroupContent(context, colorScheme)
          : _buildSingleRow(context, colorScheme),
    );
  }

  // --- 1. 單人顯示模式 ---
  Widget _buildSingleRow(BuildContext context, ColorScheme colorScheme) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildInfoContent(
                context,
                avatarWidget: CommonAvatar(
                  avatarId: member.avatar,
                  name: member.displayName,
                  isLinked: member.isLinked,
                  radius: 20,
                ),
                name: member.displayName,
                amount: member.finalAmount,
                colorScheme: colorScheme,
              ),
            ),
          ),
          // 分隔線 (極淡)
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            indent: 8,
            endIndent: 8,
          ),
          _buildActionButton(context, colorScheme),
        ],
      ),
    );
  }

  // --- 2. 群組顯示模式 ---
  Widget _buildGroupContent(BuildContext context, ColorScheme colorScheme) {
    // 邏輯保持不變
    final double childrenSum =
        member.subMembers.fold(0.0, (sum, child) => sum + child.finalAmount);
    final double headIndividualAmount = member.finalAmount - childrenSum;

    final individualHead = SettlementMember(
      id: member.id,
      displayName: member.displayName,
      avatar: member.avatar,
      isLinked: member.isLinked,
      finalAmount: headIndividualAmount,
      baseAmount: 0,
      remainderAmount: 0,
      isRemainderAbsorber: member.isRemainderAbsorber,
      isMergedHead: false,
      subMembers: const [],
    );

    final allSubMembers = [individualHead, ...member.subMembers];

    final allMembersMap = allSubMembers
        .map((m) => {
              'id': m.id,
              'avatar': m.avatar,
              'displayName': m.displayName,
              'isLinked': m.isLinked,
            })
        .toList();
    final allIds = allSubMembers.map((m) => m.id).toList();

    return Column(
      children: [
        // Header
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _buildInfoContent(
                    context,
                    avatarWidget: CommonAvatarStack(
                      allMembers: allMembersMap,
                      targetMemberIds: allIds,
                      overlapRatio: 0.5,
                      radius: 20, // Header 頭像稍大
                      type: AvatarStackType.stack,
                      limit: 3,
                    ),
                    name: member.displayName,
                    amount: member.finalAmount,
                    colorScheme: colorScheme,
                  ),
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                indent: 8,
                endIndent: 8,
              ),
              _buildActionButton(context, colorScheme),
            ],
          ),
        ),

        // Divider
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),

        // Body
        ...allSubMembers.map((sub) {
          return Padding(
            // 這裡可以考慮給一點縮排，增加層次感
            padding: EdgeInsets.zero,
            child: _buildSubMemberRow(context, sub, colorScheme),
          );
        }),
      ],
    );
  }

  // --- 資訊內容 ---
  Widget _buildInfoContent(
    BuildContext context, {
    required Widget avatarWidget,
    required String name,
    required double amount,
    required ColorScheme colorScheme,
  }) {
    final t = Translations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isReceiving = amount > 0;
    final amountColor = isReceiving ? colorScheme.tertiary : colorScheme.error;

    final statusText = isReceiving
        ? t.S30_settlement_confirm.label_refund
        : t.S30_settlement_confirm.label_payable;

    final displayAmount =
        CurrencyConstants.formatAmount(amount.abs(), baseCurrency.code);

    return Row(
      children: [
        avatarWidget,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            name,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        // 金額區塊
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${baseCurrency.symbol} $displayAmount',
              style: textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 子成員細項 ---
  Widget _buildSubMemberRow(
      BuildContext context, SettlementMember sub, ColorScheme colorScheme) {
    // 復用 _buildInfoContent 的邏輯，但稍微縮小一點
    // 這裡我們直接使用 Container 包裹 _buildInfoContent 的變體
    // 為了簡單，這裡手動重寫一個簡化版
    final textTheme = Theme.of(context).textTheme;
    final isReceiving = sub.finalAmount > 0;
    final amountColor = isReceiving ? colorScheme.tertiary : colorScheme.error;
    final displayAmount = CurrencyConstants.formatAmount(
        sub.finalAmount.abs(), baseCurrency.code);

    return Container(
      decoration: BoxDecoration(
        // 子項目之間可以加極淡的分隔線
        border: Border(
          top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 縮排效果，增加層次
          const SizedBox(width: 8),
          CommonAvatar(
            avatarId: sub.avatar,
            name: sub.displayName,
            isLinked: sub.isLinked,
            radius: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              sub.displayName,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${baseCurrency.symbol} $displayAmount',
            style: textTheme.bodyMedium?.copyWith(
              color: amountColor,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }

  // --- 動作按鈕 ---
  Widget _buildActionButton(BuildContext context, ColorScheme colorScheme) {
    // [修改] 如果 disable，顏色變淡
    final iconColor = isActionEnabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActionEnabled ? onActionTap : null,
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
        child: Container(
          width: 56,
          alignment: Alignment.center,
          child: Icon(
            actionIcon,
            size: 24,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
