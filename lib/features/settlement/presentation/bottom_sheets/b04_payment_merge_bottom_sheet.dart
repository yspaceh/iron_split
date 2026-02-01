import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';

class B04PaymentMergeBottomSheet extends StatefulWidget {
  final SettlementMember headMember;
  final List<SettlementMember> candidateMembers;
  final List<String> initialMergedIds;
  final CurrencyConstants baseCurrency;

  const B04PaymentMergeBottomSheet({
    super.key,
    required this.headMember,
    required this.candidateMembers,
    required this.initialMergedIds,
    required this.baseCurrency,
  });

  /// Static Helper to show the sheet
  static Future<List<String>?> show(
    BuildContext context, {
    required SettlementMember headMember,
    required List<SettlementMember> candidateMembers,
    required List<String> initialMergedIds,
    required CurrencyConstants baseCurrency,
  }) {
    return showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B04PaymentMergeBottomSheet(
        headMember: headMember,
        candidateMembers: candidateMembers,
        initialMergedIds: initialMergedIds,
        baseCurrency: baseCurrency,
      ),
    );
  }

  @override
  State<B04PaymentMergeBottomSheet> createState() =>
      _B04PaymentMergeBottomSheetState();
}

class _B04PaymentMergeBottomSheetState
    extends State<B04PaymentMergeBottomSheet> {
  // 使用 Set 管理選取狀態，避免重複且查詢快
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.initialMergedIds);
  }

  void _toggleSelection(String memberId) {
    setState(() {
      if (_selectedIds.contains(memberId)) {
        _selectedIds.remove(memberId);
      } else {
        _selectedIds.add(memberId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // ✅ 使用 CommonBottomSheetPage 取代原本的 Scaffold
    return CommonBottomSheet(
      title: t.b04_payment_merge.title,

      // ✅ 底部按鈕區：使用 .sheet 建構子 (呈現內縮分隔線效果)
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          // 取消
          AppButton(
            text: t.b04_payment_merge.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => Navigator.pop(context),
          ),
          // 確認合併
          AppButton(
            text: t.b04_payment_merge.buttons.confirm,
            type: AppButtonType.primary,
            onPressed: () {
              Navigator.pop(context, _selectedIds.toList());
            },
          ),
        ],
      ),

      // ✅ 內容區域
      children: Column(
        children: [
          // 1. 說明文字區
          Padding(
            padding:
                const EdgeInsets.fromLTRB(24, 16, 24, 24), // 上方 Padding 稍微加大一點
            child: Text(
              t.b04_payment_merge.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // 2. 代表成員區塊 (Head)
                _buildSectionLabel(context, t.b04_payment_merge.section_head),
                const SizedBox(height: 8),
                _buildHeadMemberCard(context),

                const SizedBox(height: 24),

                // 3. 候選成員區塊 (Candidates)
                _buildSectionLabel(
                    context, t.b04_payment_merge.section_candidates),
                const SizedBox(height: 8),

                if (widget.candidateMembers.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "No available members to merge",
                        style: textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.outline),
                      ),
                    ),
                  )
                else
                  ...widget.candidateMembers.map((member) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildCandidateTile(context, member),
                    );
                  }),

                // 底部留白 (CommonBottomSheetPage 的 Scaffold 會處理，但加一點保險)
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Sub Widgets ---

  Widget _buildSectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }

  // 代表成員卡片 (唯讀，視覺上較為突出)
  Widget _buildHeadMemberCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest, // 使用 M3 強調色背景
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          CommonAvatar(
            avatarId: widget.headMember.avatar,
            name: widget.headMember.displayName,
            isLinked: widget.headMember.isLinked,
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.headMember.displayName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildAmountText(context, widget.headMember),
        ],
      ),
    );
  }

  // 候選成員 Tile (可勾選)
  Widget _buildCandidateTile(BuildContext context, SettlementMember member) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedIds.contains(member.id);

    return InkWell(
      onTap: () => _toggleSelection(member.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.secondaryContainer
                  .withValues(alpha: 0.3) // 選中時給一點底色
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? colorScheme.primary : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CommonAvatar(
              avatarId: member.avatar,
              name: member.displayName,
              isLinked: member.isLinked,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.displayName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // 金額
            _buildAmountText(context, member),
            const SizedBox(width: 12),
            // M3 Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (val) => _toggleSelection(member.id),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  // 金額顯示邏輯 (文字取代符號)
  Widget _buildAmountText(BuildContext context, SettlementMember member) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final amount = member.finalAmount;
    final isReceiving = amount > 0;

    final statusText = isReceiving
        ? t.b04_payment_merge.status_receivable // "可退"
        : t.b04_payment_merge.status_payable; // "應付"

    final amountColor = isReceiving
        ? Colors.green[700] // 綠色
        : colorScheme.onSurface; // 黑色/深灰色

    final displayAmount = CurrencyConstants.formatAmount(
      amount.abs(), // 顯示絕對值
      widget.baseCurrency.code,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statusText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.outline, // 狀態文字用灰色
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "${widget.baseCurrency.symbol} $displayAmount",
          style: theme.textTheme.titleMedium?.copyWith(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontFeatures: const [FontFeature.tabularFigures()], // 數字等寬對齊
          ),
        ),
      ],
    );
  }
}
