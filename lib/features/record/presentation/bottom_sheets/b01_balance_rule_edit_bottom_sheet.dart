import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class B01BalanceRuleEditBottomSheet extends StatefulWidget {
  final String initialRule; // 'random', 'order', 'member'
  final String? initialMemberId; // 如果規則是 member，當前選中的人
  final List<Map<String, dynamic>> members; // 成員清單 (用於選擇請客對象)

  const B01BalanceRuleEditBottomSheet({
    super.key,
    required this.initialRule,
    this.initialMemberId,
    required this.members,
  });

  @override
  State<B01BalanceRuleEditBottomSheet> createState() =>
      _B01BalanceRuleEditBottomSheetState();
}

class _B01BalanceRuleEditBottomSheetState
    extends State<B01BalanceRuleEditBottomSheet> {
  late String _selectedRule;
  String? _selectedMemberId;

  // 定義規則選項 (可擴充)
  final List<String> _ruleOptions = RemainderRuleConstants.allRules;

  @override
  void initState() {
    super.initState();
    _selectedRule = widget.initialRule;
    _selectedMemberId = widget.initialMemberId;

    // 防呆：如果切換進來是 member 模式但沒 ID，預設不選或選第一個人(視需求)
    // 這裡保持 null，強迫使用者選擇
  }

  // 驗證是否可保存
  bool get _isValid {
    if (_selectedRule == 'member') {
      return _selectedMemberId != null;
    }
    return true;
  }

  void _onSave() {
    if (_isValid) {
      context.pop({
        'rule': _selectedRule,
        'memberId': _selectedRule == 'member' ? _selectedMemberId : null,
      });
    }
  }

  void _showRuleInfo(String rule) {
    // 這裡之後可以呼叫 Dxx Dialog 顯示說明
    // 目前先印 log 或不做動作
    debugPrint("Show info for $rule");
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75, // 高度可自訂
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // --- 1. Unified Header (統一標頭) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左側：取消
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(t.common.cancel,
                      style: const TextStyle(color: Colors.grey)),
                ),
                // 中間：標題
                Text(
                  t.remainder_rule.title, // "餘額處理方式"
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                // 右側：確認 (根據狀態變色)
                TextButton(
                  onPressed: _isValid ? _onSave : null,
                  child: Text(
                    t.common.confirm,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isValid ? colorScheme.primary : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // --- 2. 內容捲動區 ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // 產生規則選項
                ..._ruleOptions.map((rule) {
                  final isSelected = _selectedRule == rule;
                  return Column(
                    children: [
                      // 規則選項卡片
                      ListTile(
                        onTap: () {
                          setState(() {
                            _selectedRule = rule;
                            // 切換規則時，如果是 member 但之前沒選人，保持 null
                          });
                        },
                        leading: Radio<String>(
                          value: rule,
                          groupValue: _selectedRule,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedRule = val);
                            }
                          },
                        ),
                        title: Text(
                          RemainderRuleConstants.getLabel(context, rule),
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline,
                              size: 20, color: Colors.grey),
                          onPressed: () => _showRuleInfo(rule),
                        ),
                      ),

                      // 展開區域：只有選 member 時顯示成員清單
                      if (rule == 'member' && isSelected)
                        _buildMemberSelectionArea(theme),

                      // 分隔線 (美觀用)
                      if (rule != _ruleOptions.last)
                        Divider(
                            indent: 16,
                            endIndent: 16,
                            color: colorScheme.surfaceContainerHighest),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 成員選擇區塊 (Radio List) ---
  Widget _buildMemberSelectionArea(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerLow, // 稍微深一點的背景色，區隔層級
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(72, 8, 16, 8),
            child: Text(
              "請選擇請客對象", // 可以放到 i18n: t.B01.select_payer_hint
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    // 為了對齊上面的 Radio，這裡做一點縮排
                    const SizedBox(width: 32),
                    CommonAvatar(
                      avatarId: m['avatar'],
                      name: m['displayName'],
                      radius: 16,
                      isLinked: m['isLinked'] ?? false,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m['displayName'],
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMe)
                      Icon(Icons.check_circle,
                          color: theme.colorScheme.primary, size: 20)
                    else
                      Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
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
