import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/gen/strings.g.dart';

class SettlementMemberItem extends StatelessWidget {
  final SettlementMember member;
  final CurrencyConstants baseCurrency;

  // --- Action 相關參數 (S30/S17 通用) ---
  final VoidCallback? onActionTap;
  final bool isActionEnabled;
  final IconData actionIcon;

  const SettlementMemberItem({
    super.key,
    required this.member,
    required this.baseCurrency,
    this.onActionTap,
    this.isActionEnabled = true,
    this.actionIcon = Icons.link, // 預設為連結圖示
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isGroup = member.subMembers.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      // 如果是群組，給稍微深一點的底色區分；如果是單人，用淺色
      color: isGroup
          ? colorScheme.surfaceContainer
          : colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: isGroup
          ? _buildGroupContent(context, colorScheme)
          : _buildSingleRow(context, colorScheme),
    );
  }

  // --- 1. 單人顯示模式 (只有一行) ---
  Widget _buildSingleRow(BuildContext context, ColorScheme colorScheme) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 左側內容 (Avatar + Name + Status/Amount)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildInfoContent(
                context,
                avatarWidget: CommonAvatar(
                  avatarId: member.avatar,
                  name: member.displayName,
                  isLinked: member.isLinked,
                  radius: 16,
                ),
                name: member.displayName,
                amount: member.finalAmount,
                colorScheme: colorScheme,
              ),
            ),
          ),

          // 分隔線
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            indent: 8,
            endIndent: 8,
          ),

          // 右側按鈕
          _buildActionButton(context, colorScheme),
        ],
      ),
    );
  }

  // --- 2. 群組顯示模式 (直向排列：Header + Divider + Body) ---
  Widget _buildGroupContent(BuildContext context, ColorScheme colorScheme) {
    // 1. 計算 Head 的個人金額
    final double childrenSum =
        member.subMembers.fold(0.0, (sum, child) => sum + child.finalAmount);
    final double headIndividualAmount = member.finalAmount - childrenSum;

    // 2. 建立「代表成員的個人視角」物件
    final individualHead = SettlementMember(
      id: member.id,
      displayName: member.displayName, // 這裡可以考慮加註 (代表) 或不加
      avatar: member.avatar,
      isLinked: member.isLinked,
      finalAmount: headIndividualAmount, // <--- 顯示個人金額
      // 以下欄位若是 UI 沒用到可填預設值，或從 member 複製
      baseAmount: 0,
      remainderAmount: 0,
      isRemainderAbsorber: member.isRemainderAbsorber,
      isMergedHead: false,
      subMembers: const [],
    );

    // 3. 組合完整清單：[Head個人, ...子成員]
    final allSubMembers = [individualHead, ...member.subMembers];

    // 4. 準備 Avatar Stack (維持原邏輯，顯示包含自己在內的所有人)
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
        // A. Header (結構與單人類似，但 Avatar 變成 Stack)
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
                      overlapRatio: 0.3,
                      radius: 16,
                      type: AvatarStackType.stack,
                      limit: 3,
                    ),
                    name: member.displayName, // 代表人名字
                    amount: member.finalAmount, // 總額
                    colorScheme: colorScheme,
                  ),
                ),
              ),
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                indent: 8,
                endIndent: 8,
              ),
              _buildActionButton(context, colorScheme),
            ],
          ),
        ),

        // B. Divider
        Divider(
          height: 1,
          thickness: 1,
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),

        // C. Body (細項列表 - 永遠顯示)
        ...allSubMembers.map((sub) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: _buildSubMemberRow(context, sub, colorScheme),
          );
        }),
      ],
    );
  }

  // --- 共用組件：資訊內容 (Avatar | Name ...... Status $Amount) ---
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
    // 金額顏色：綠色或深黑
    final amountColor = isReceiving ? Colors.green[700] : colorScheme.onSurface;

    // 狀態文字
    final statusText = isReceiving
        ? t.S30_settlement_confirm.label_refund
        : t.S30_settlement_confirm.label_payable;

    final displayAmount =
        CurrencyConstants.formatAmount(amount.abs(), baseCurrency.code);

    return Row(
      children: [
        // 1. Avatar (或 Stack)
        avatarWidget,
        const SizedBox(width: 12),

        // 2. Name (垂直置中)
        Expanded(
          child: Text(
            name,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface, // 深色
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 8),

        // 3. Status + Amount (單行顯示！)
        // 例如: "應付 $1,200"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant, // 深灰色
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${baseCurrency.symbol} $displayAmount',
              style: textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubMemberInfoContent(
    BuildContext context, {
    required Widget avatarWidget,
    required String name,
    required double amount,
    required ColorScheme colorScheme,
  }) {
    final t = Translations.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isReceiving = amount > 0;
    // 金額顏色：綠色或深黑
    final amountColor = isReceiving ? Colors.green[700] : colorScheme.onSurface;

    // 狀態文字
    final statusText = isReceiving
        ? t.S30_settlement_confirm.label_refund
        : t.S30_settlement_confirm.label_payable;

    final displayAmount =
        CurrencyConstants.formatAmount(amount.abs(), baseCurrency.code);

    return Row(
      children: [
        // 1. Avatar (或 Stack)
        avatarWidget,
        const SizedBox(width: 8),

        // 2. Name (垂直置中)
        Expanded(
          child: Text(
            name,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 14,
              color: colorScheme.onSurface, // 深色
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 8),

        // 3. Status + Amount (單行顯示！)
        // 例如: "應付 $1,200"
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${baseCurrency.symbol} $displayAmount',
              style: textTheme.titleMedium?.copyWith(
                color: amountColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- 子成員細項 Row ---
  Widget _buildSubMemberRow(
      BuildContext context, SettlementMember sub, ColorScheme colorScheme) {
    // 這裡我們直接用 _buildInfoContent 的邏輯，但不顯示按鈕，只顯示資訊
    // 需要稍微調整 Padding 做出層次感
    return Container(
      decoration: BoxDecoration(
        // 子項目之間可以加淡淡的分隔線，或是不加保持乾淨
        border: Border(
          top: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _buildSubMemberInfoContent(
        context,
        avatarWidget: CommonAvatar(
          avatarId: sub.avatar,
          name: sub.displayName,
          isLinked: sub.isLinked,
          radius: 12, // 稍微小一點
        ),
        name: sub.displayName,
        amount: sub.finalAmount,
        colorScheme: colorScheme,
      ),
    );
  }

  // --- 動作按鈕 ---
  Widget _buildActionButton(BuildContext context, ColorScheme colorScheme) {
    final iconColor = isActionEnabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.3);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isActionEnabled ? onActionTap : null,
        child: Container(
          width: 56, // 固定按鈕區寬度
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
