import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/gen/strings.g.dart';

class B01BalanceRuleEditBottomSheet extends StatefulWidget {
  final String initialRule; // 'random', 'order', 'member'
  final String? initialMemberId; // 如果規則是 member，當前選中的人
  final List<Map<String, dynamic>> members; // 成員清單

  const B01BalanceRuleEditBottomSheet({
    super.key,
    required this.initialRule,
    this.initialMemberId,
    required this.members,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required String initialRule,
    String? initialMemberId,
    required List<Map<String, dynamic>> members,
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

  final List<String> _ruleOptions = RemainderRuleConstants.allRules;

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

  void _showRuleInfo(String rule) {
    debugPrint("Show info for $rule");
    // 未來可在此呼叫 Dialog 顯示說明
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ 使用 CommonBottomSheetPage
    return CommonBottomSheet(
      title: t.common.remainder_rule.title, // "零頭處理"

      // ✅ 底部按鈕區：使用 .sheet 建構子 (內縮分隔線)
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          // 取消按鈕 (雖然左上角有 X，但為了與 B04 一致，底部也放一個)
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

      // ✅ 內容捲動區
      children: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // 產生規則選項
          ..._ruleOptions.map((rule) {
            final isSelected = _selectedRule == rule;
            return Column(
              children: [
                // 規則選項 ListTile
                ListTile(
                  onTap: () {
                    setState(() {
                      _selectedRule = rule;
                    });
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  leading: Radio<String>(
                    value: rule,
                    groupValue: _selectedRule,
                    activeColor: colorScheme.primary,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedRule = val);
                      }
                    },
                  ),
                  title: Text(
                    RemainderRuleConstants.getLabel(context, rule),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: colorScheme.outline,
                    ),
                    onPressed: () => _showRuleInfo(rule),
                  ),
                ),

                // 展開區域：只有選 member 時顯示成員清單
                if (rule == RemainderRuleConstants.member && isSelected)
                  _buildMemberSelectionArea(theme),

                // 分隔線 (除了最後一個)
                if (rule != _ruleOptions.last)
                  Divider(
                    indent: 16,
                    endIndent: 16,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  ),
              ],
            );
          }),

          // 底部留白
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- 成員選擇區塊 ---
  Widget _buildMemberSelectionArea(ThemeData theme) {
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerLow, // 稍微深一點的背景色，區隔層級
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 12, 16, 8),
            child: Text(
              "請選擇請客對象", // 建議補上 i18n
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.primary),
            ),
          ),
          ...widget.members.map((m) {
            final id = m['id'];
            final isMe = id == _selectedMemberId;

            return InkWell(
              onTap: () {
                setState(() => _selectedMemberId = id);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: [
                    // 為了對齊上面的 Radio，這裡做一點縮排
                    const SizedBox(width: 48),

                    CommonAvatar(
                      avatarId: m['avatar'],
                      name: m['displayName'],
                      radius: 14,
                      isLinked: m['isLinked'] ?? false,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m['displayName'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isMe
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                          fontWeight:
                              isMe ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMe)
                      Icon(Icons.check_circle,
                          color: theme.colorScheme.primary, size: 20)
                    else
                      Icon(Icons.circle_outlined,
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.5),
                          size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
