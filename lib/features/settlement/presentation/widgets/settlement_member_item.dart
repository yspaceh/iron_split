import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

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
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    return Container(
      // [關鍵] 1. 裝飾層：與 RecordItem 一致的白底、圓角 16、極淡陰影
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusL), //  圓角 16
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
        borderRadius: BorderRadius.circular(AppLayout.radiusL), //  圓角 16
        child: isGroup
            ? _buildGroupContent(context, colorScheme, isEnlarged)
            : _buildSingleRow(context, colorScheme, isEnlarged),
      ),
    );
  }

  // --- 1. 單人顯示模式 ---
  Widget _buildSingleRow(
      BuildContext context, ColorScheme colorScheme, bool isEnlarged) {
    final infoContent = _buildInfoContent(
      context,
      isEnlarged: isEnlarged,
      avatarWidget: CommonAvatar(
        avatarId: member.memberData.avatar,
        name: member.memberData.displayName,
        isLinked: member.memberData.isLinked,
        radius: AppLayout.radiusXL, //  直徑 40px
      ),
      name: member.memberData.displayName,
      amount: member.finalAmount,
      colorScheme: colorScheme,
    );
    return isEnlarged
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppLayout.spaceL, vertical: AppLayout.spaceM),
                child: infoContent,
              ),
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
              _buildActionButton(context, colorScheme, isEnlarged),
            ],
          )
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppLayout.spaceL,
                        vertical: AppLayout.spaceM),
                    child: infoContent,
                  ),
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  indent: 8,
                  endIndent: 8,
                ),
                _buildActionButton(context, colorScheme, isEnlarged),
              ],
            ),
          );
  }

  // --- 2. 群組顯示模式 (邏輯不變，僅樣式微調) ---
  Widget _buildGroupContent(
      BuildContext context, ColorScheme colorScheme, bool isEnlarged) {
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
    final infoContent = _buildInfoContent(
      context,
      isEnlarged: isEnlarged,
      avatarWidget: CommonAvatarStack(
        allMembers: validMembers,
        targetMemberIds: allIds,
        overlapRatio: 0.5,
        radius: AppLayout.radiusXL,
        type: AvatarStackType.stack,
        limit: 3,
      ),
      name: member.memberData.displayName,
      amount: member.finalAmount,
      colorScheme: colorScheme,
    );

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppLayout.spaceL, vertical: AppLayout.spaceM),
                  child: infoContent,
                ),
              ),
              if (!isEnlarged) ...[
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  indent: 8,
                  endIndent: 8,
                ),
                _buildActionButton(context, colorScheme, isEnlarged),
              ]
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
            child: _buildSubMemberRow(context, sub, colorScheme, isEnlarged),
          );
        }),

        if (!isEnlarged) ...[
          const SizedBox(height: AppLayout.spaceS),
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          _buildActionButton(context, colorScheme, isEnlarged),
        ]
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
    required bool isEnlarged,
  }) {
    final t = Translations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isReceiving = amount > 0;
    final amountColor =
        isReceiving ? colorScheme.tertiary : colorScheme.primary;

    final statusText = isReceiving
        ? t.common.payment_status.refund
        : t.common.payment_status.payable;

    final displayAmount =
        CurrencyConstants.formatAmount(amount.abs(), baseCurrency.code);
    final nameWidget = Text(
      name,
      style: textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      maxLines: isEnlarged ? null : 1,
      overflow: isEnlarged ? null : TextOverflow.ellipsis,
    );

    final amountWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statusText,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppLayout.spaceXS),
        Text(
          '${baseCurrency.symbol} $displayAmount',
          style: textTheme.titleMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            avatarWidget,
            const SizedBox(width: AppLayout.spaceM),
            Expanded(
              child: nameWidget,
            ),
          ],
        ),
        const SizedBox(height: AppLayout.spaceS),
        amountWidget,
      ],
    );
  }

  // --- 子成員細項 ---
  Widget _buildSubMemberRow(BuildContext context, SettlementMember sub,
      ColorScheme colorScheme, bool isEnlarged) {
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppLayout.spaceL, vertical: AppLayout.spaceM),
      child: Row(
        children: [
          const SizedBox(width: AppLayout.spaceL), // 縮排
          CommonAvatar(
            avatarId: sub.memberData.avatar,
            name: sub.memberData.displayName,
            isLinked: sub.memberData.isLinked,
            radius: 16,
          ),
          const SizedBox(width: AppLayout.spaceM),
          Expanded(
            child: Text(
              sub.memberData.displayName,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: isEnlarged ? null : 1,
              overflow: isEnlarged ? null : TextOverflow.ellipsis,
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
  Widget _buildActionButton(
      BuildContext context, ColorScheme colorScheme, bool isEnlarged) {
    final iconColor = isActionEnabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.2);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActionEnabled ? onActionTap : null,
        child: Container(
          width: isEnlarged ? double.infinity : 56,
          padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceM),
          alignment: Alignment.center,
          child: Icon(
            actionIcon,
            size: AppLayout.iconSizeM,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
