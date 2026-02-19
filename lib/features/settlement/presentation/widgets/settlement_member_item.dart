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
    this.isActionEnabled = true,
    this.actionIcon = Icons.link,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isGroup = member.subMembers.isNotEmpty;

    return Container(
      // [關鍵] 1. 裝飾層：與 RecordItem 一致的白底、圓角 16、極淡陰影
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16), //  圓角 16
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), //  極淡陰影 (3%)
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      // [關鍵] 2. 裁切層：確保內容不會超出圓角
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), //  圓角 16
        child: isGroup
            ? _buildGroupContent(context, colorScheme)
            : _buildSingleRow(context, colorScheme),
      ),
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
              //  垂直內距 12 + 頭像 40 = 高度 64px (與 RecordItem 一致)
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildInfoContent(
                context,
                avatarWidget: CommonAvatar(
                  avatarId: member.memberData.avatar,
                  name: member.memberData.displayName,
                  isLinked: member.memberData.isLinked,
                  radius: 20, //  直徑 40px
                ),
                name: member.memberData.displayName,
                amount: member.finalAmount,
                colorScheme: colorScheme,
              ),
            ),
          ),

          // 分隔線
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
            indent: 8,
            endIndent: 8,
          ),

          // 右側按鈕
          _buildActionButton(context, colorScheme),
        ],
      ),
    );
  }

  // --- 2. 群組顯示模式 (邏輯不變，僅樣式微調) ---
  Widget _buildGroupContent(BuildContext context, ColorScheme colorScheme) {
    final double childrenSum =
        member.subMembers.fold(0.0, (sum, child) => sum + child.finalAmount);
    final double headIndividualAmount = member.finalAmount - childrenSum;

    final individualHead = SettlementMember(
      memberData: member.memberData,
      finalAmount: headIndividualAmount,
      baseAmount: 0,
      remainderAmount: 0,
      isRemainderAbsorber: member.isRemainderAbsorber,
      isMergedHead: false,
      subMembers: const [],
    );

    final allSubMembers = [individualHead, ...member.subMembers];

    final validMembers = allSubMembers.map((m) => m.memberData).toList();
    final allIds = validMembers.map((m) => m.id).toList();

    return Column(
      children: [
        // Header
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  //  Header 保持一致的高度設定
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _buildInfoContent(
                    context,
                    avatarWidget: CommonAvatarStack(
                      allMembers: validMembers,
                      targetMemberIds: allIds,
                      overlapRatio: 0.5,
                      radius: 20,
                      type: AvatarStackType.stack,
                      limit: 3,
                    ),
                    name: member.memberData.displayName,
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

        // Body (子成員列表)
        ...allSubMembers.map((sub) {
          return Padding(
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
    final textTheme = Theme.of(context).textTheme;
    final isReceiving = sub.finalAmount > 0;
    final amountColor = isReceiving ? colorScheme.tertiary : colorScheme.error;
    final displayAmount = CurrencyConstants.formatAmount(
        sub.finalAmount.abs(), baseCurrency.code);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.1)),
        ),
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
      ),
      // 子項目高度：Vertical 12 + Avatar 32 (radius 16) + Vertical 12 = 56px (稍矮一點，符合層級感)
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 16), // 縮排
          CommonAvatar(
            avatarId: sub.memberData.avatar,
            name: sub.memberData.displayName,
            isLinked: sub.memberData.isLinked,
            radius: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              sub.memberData.displayName,
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
              color: amountColor.withValues(alpha: 0.8),
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }

  // --- 動作按鈕 ---
  Widget _buildActionButton(BuildContext context, ColorScheme colorScheme) {
    final iconColor = isActionEnabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActionEnabled ? onActionTap : null,
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
