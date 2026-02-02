import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      useSafeArea: true, // 保持原始安全區域設定
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
    // 初始化勾選狀態 (回溯編輯)
    _selectedIds = List.from(widget.initialMergedIds);
  }

  void _toggleMember(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CommonBottomSheet(
      title: t.b04_payment_merge.title,
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
            onPressed: () => context.pop(_selectedIds),
          ),
        ],
      ),
      children: Column(
        children: [
          // 1. 代表成員資訊 (固定在頂部)
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.headMember.displayName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface, // 加深文字顏色
                        ),
                      ),
                      Text(
                        t.b04_payment_merge.section_head,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // 2. 候選成員清單 (可捲動)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.candidateMembers.length,
              itemBuilder: (context, index) {
                final member = widget.candidateMembers[index];
                final isSelected = _selectedIds.contains(member.id);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (_) => _toggleMember(member.id),
                  activeColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  // [視覺修正] 確保頭像與文字垂直置中
                  secondary: CommonAvatar(
                    avatarId: member.avatar,
                    name: member.displayName,
                    isLinked: member.isLinked,
                    radius: 20,
                  ),
                  title: Text(
                    member.displayName,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface, // 加深文字顏色
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    "${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(member.finalAmount.abs(), widget.baseCurrency.code)}",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant, // 使用中深灰，禁用淺色
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
