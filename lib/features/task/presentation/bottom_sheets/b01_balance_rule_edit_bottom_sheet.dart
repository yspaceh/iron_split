import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_card.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';

class B01BalanceRuleEditBottomSheet extends StatefulWidget {
  final String initialRule; // 'random', 'order', 'member'
  final String? initialMemberId; // 如果規則是 member，當前選中的人
  final List<TaskMember> members; // 成員清單
  final double currentRemainder;
  final CurrencyConstants baseCurrency;

  const B01BalanceRuleEditBottomSheet({
    super.key,
    required this.initialRule,
    this.initialMemberId,
    required this.members,
    required this.currentRemainder,
    required this.baseCurrency,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required String initialRule,
    String? initialMemberId,
    required List<TaskMember> members,
    required double currentRemainder,
    required CurrencyConstants baseCurrency,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B01BalanceRuleEditBottomSheet(
        initialRule: initialRule,
        initialMemberId: initialMemberId,
        members: members,
        currentRemainder: currentRemainder,
        baseCurrency: baseCurrency,
      ),
    );
  }

  @override
  State<B01BalanceRuleEditBottomSheet> createState() =>
      _B01BalanceRuleEditBottomSheetState();
}

class _B01BalanceRuleEditBottomSheetState
    extends State<B01BalanceRuleEditBottomSheet> {
  late String _selectedRule;
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _selectedRule = widget.initialRule;
    _selectedMemberId = widget.initialMemberId;
  }

  bool get _isValid {
    if (_selectedRule == RemainderRuleConstants.member) {
      return _selectedMemberId != null;
    }
    return true;
  }

  void _onSave() {
    if (_isValid) {
      context.pop({
        'rule': _selectedRule,
        'memberId': _selectedRule == RemainderRuleConstants.member
            ? _selectedMemberId
            : null,
      });
    }
  }

  void _onToggleRule(String rule) {
    setState(() {
      _selectedRule = rule;
      // 如果切換到其他規則，不一定要清空 memberId，保留上次選擇可能體驗更好
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    return CommonBottomSheet(
      title: t.common.remainder_rule.title, // "零頭處理"
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          // 取消按鈕
          AppButton(
            text: t.common.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          // 確認按鈕
          AppButton(
            text: t.common.buttons.confirm,
            type: AppButtonType.primary,
            // 如果驗證不過 (例如選指定成員但沒選人)，則 disable
            onPressed: _isValid ? _onSave : null,
          ),
        ],
      ),
      children: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Text(
            t.common.remainder_rule.description.remainder(
              amount:
                  "${widget.baseCurrency.code}${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(widget.currentRemainder, widget.baseCurrency.code)}",
            ),
          ),
          const SizedBox(height: 16),
          SelectionCard(
            title: RemainderRuleConstants.getLabel(
                context, RemainderRuleConstants.random),
            isSelected: _selectedRule == RemainderRuleConstants.random,
            isRadio: true, // [Radio 樣式]
            onToggle: () => _onToggleRule(RemainderRuleConstants.random),
            child: Text(
              t.common.remainder_rule.description.random,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SelectionCard(
            title: RemainderRuleConstants.getLabel(
                context, RemainderRuleConstants.order),
            isSelected: _selectedRule == RemainderRuleConstants.order,
            isRadio: true, // [Radio 樣式]
            onToggle: () => _onToggleRule(RemainderRuleConstants.order),
            child: Text(
              t.common.remainder_rule.description.order,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SelectionCard(
            title: RemainderRuleConstants.getLabel(
                context, RemainderRuleConstants.member),
            isSelected: _selectedRule == RemainderRuleConstants.member,
            isRadio: true, // [Radio 樣式]
            onToggle: () => _onToggleRule(RemainderRuleConstants.member),
            child: Column(children: [
              Text(
                t.common.remainder_rule.description.member,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              // 成員清單
              ...widget.members.map((m) {
                final id = m.id;
                final isMe = id == _selectedMemberId;
                return SelectionTile(
                  title: m.displayName,
                  isSelected: isMe,
                  isRadio: true,
                  isSelectedBackgroundColor: theme.colorScheme.surface,
                  backgroundColor: theme.colorScheme.surfaceContainerLow,
                  onTap: () {
                    setState(() => _selectedMemberId = id);
                  },
                  leading: CommonAvatar(
                    avatarId: m.avatar,
                    name: m.displayName,
                    isLinked: m.isLinked,
                  ),
                );
              }),
            ]),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
