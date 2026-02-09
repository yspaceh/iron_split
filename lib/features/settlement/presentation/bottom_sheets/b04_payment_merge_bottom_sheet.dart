import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/settlement_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart'; // [新增]
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
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
  late List<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    // 初始化選中狀態 (包含原本已經合併的人)
    _selectedIds = List.from(widget.initialMergedIds);
  }

  // 計算合併後的總金額
  // 邏輯：代表成員金額 + 所有被勾選成員的金額
  double get _totalAmount {
    // 1. 先從候選名單中找出被選中的人，並加總他們的金額
    final selectedCandidatesSum = widget.candidateMembers
        .where((m) => _selectedIds.contains(m.id))
        .fold(0.0, (sum, m) => sum + m.finalAmount);

    // 2. 加上代表成員原本的金額
    return widget.headMember.finalAmount + selectedCandidatesSum;
  }

  void _onSave() {
    context.pop(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonBottomSheet(
      title: t.B04_payment_merge.title, // "合併成員款項"
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          AppButton(
            text: t.common.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          AppButton(
            text: t.common.buttons.confirm,
            type: AppButtonType.primary,
            onPressed: _onSave,
          ),
        ],
      ),
      children: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SummaryRow(
                  label: t.B04_payment_merge.label.merge_amount,
                  amount: _totalAmount,
                  currencyConstants: widget.baseCurrency,
                  valueColor: widget.headMember.finalAmount > 0
                      ? colorScheme.tertiary
                      : colorScheme.error,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
            ),
          ),

          // [新增] 1. 代表成員 (Head Member) - 放在列表最上面，鎖定
          SelectionTile(
            isSelected: true, // 永遠選中
            isRadio: false,
            onTap: null, // 禁止點擊 (鎖定狀態)
            // 為了讓鎖定的 checkbox 看起來不同，可以考慮給一個 disabled 的顏色
            // 但如果 SelectionTile 內部有處理 null onTap 的樣式則不必
            leading: CommonAvatar(
              avatarId: widget.headMember.avatar,
              name: widget.headMember.displayName,
              isLinked: widget.headMember.isLinked,
              radius: 20,
            ),
            // [修改] 標題加上 "(代表成員)"
            title:
                "${widget.headMember.displayName} - ${t.B04_payment_merge.label.head_member}",
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(widget.headMember.finalAmount.abs(), widget.baseCurrency.code)}",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: widget.headMember.finalAmount > 0
                        ? colorScheme.tertiary
                        : colorScheme.error,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ],
            ),
          ),

          // 2. Candidates List (候選名單)
          // 這裡顯示 VM 傳過來的完整候選名單 (包含已合併)
          if (widget.candidateMembers.isEmpty)
            Container()
          else
            ...widget.candidateMembers.map((member) {
              final isSelected = _selectedIds.contains(member.id);
              final amountStr = CurrencyConstants.formatAmount(
                  member.finalAmount.abs(), widget.baseCurrency.code);

              return SelectionTile(
                isSelected: isSelected,
                isRadio: false, // Checkbox 樣式
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIds.remove(member.id);
                    } else {
                      _selectedIds.add(member.id);
                    }
                  });
                },
                leading: CommonAvatar(
                  avatarId: member.avatar,
                  name: member.displayName,
                  isLinked: member.isLinked,
                  radius: 20,
                ),
                title: member.displayName,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.baseCurrency.symbol} $amountStr",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: member.finalAmount > 0
                            ? colorScheme.tertiary
                            : colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
