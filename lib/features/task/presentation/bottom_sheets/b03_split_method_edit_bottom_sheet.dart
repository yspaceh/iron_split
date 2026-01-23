import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart';

class B03SplitMethodEditBottomSheet extends StatefulWidget {
  final double totalAmount;
  final String currencySymbol;
  final List<Map<String, dynamic>> allMembers; // 任務所有成員
  final Map<String, double> defaultMemberWeights; // 任務預設權重

  // 初始狀態
  final String initialSplitMethod;
  final List<String> initialMemberIds;
  final Map<String, double> initialDetails;

  const B03SplitMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.currencySymbol,
    required this.allMembers,
    required this.defaultMemberWeights,
    required this.initialSplitMethod,
    required this.initialMemberIds,
    required this.initialDetails,
  });

  @override
  State<B03SplitMethodEditBottomSheet> createState() =>
      _B03SplitMethodEditBottomSheetState();
}

class _B03SplitMethodEditBottomSheetState
    extends State<B03SplitMethodEditBottomSheet> {
  late String _splitMethod; // 'even', 'percent', 'exact'
  late List<String> _selectedMemberIds;
  late Map<String, double> _details; // 儲存 金額(Exact) 或 權重(Percent)

  // 用於 Exact 模式金額輸入的 Controllers
  final Map<String, TextEditingController> _amountControllers = {};

  @override
  void initState() {
    super.initState();
    _splitMethod = widget.initialSplitMethod;
    _selectedMemberIds = List.from(widget.initialMemberIds);
    _details = Map.from(widget.initialDetails);

    // 初始化金額輸入框 (僅 Exact 模式需要，但先準備好以防切換)
    for (var m in widget.allMembers) {
      final id = m['id'];
      final val = _details[id] ?? 0.0;
      _amountControllers[id] = TextEditingController(
        text: val > 0 ? val.toStringAsFixed(1) : '',
      );
    }

    // 防呆：如果進來時沒選人，且是 Even 模式，預設全選
    if (_selectedMemberIds.isEmpty && _splitMethod == 'even') {
      _selectedMemberIds =
          widget.allMembers.map((m) => m['id'] as String).toList();
    }
  }

  @override
  void dispose() {
    for (var c in _amountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // --- Logic Helpers ---

  void _switchMethod(String newMethod) {
    setState(() {
      _splitMethod = newMethod;
      // 切換模式時的數據轉換邏輯
      if (newMethod == 'percent') {
        // 切換到比例：載入預設權重
        _details.clear();
        for (var id in _selectedMemberIds) {
          _details[id] = widget.defaultMemberWeights[id] ?? 1.0;
        }
      } else if (newMethod == 'exact') {
        // 切換到金額：清空，讓使用者自己打
        _details.clear();
        for (var c in _amountControllers.values) {
          c.text = '';
        }
      }
    });
  }

  // 驗證是否可保存
  bool get _isValid {
    if (_selectedMemberIds.isEmpty) return false;

    if (_splitMethod == 'exact') {
      final sum = _details.values.fold(0.0, (prev, curr) => prev + curr);
      // 允許 0.1 的浮點誤差
      return (sum - widget.totalAmount).abs() < 0.1;
    }
    return true; // Even 和 Percent 只要有人選就可以
  }

  // --- UI Builders ---

  void _showMethodPicker() {
    // 使用 CommonWheelPicker 重複利用
    final options = ['even', 'percent', 'exact'];
    String tempMethod = _splitMethod;

    // 建立 i18n 對照
    String getLabel(String method) {
      switch (method) {
        case 'even':
          return t.B03_SplitMethod_Edit.method_even;
        case 'percent':
          return t.B03_SplitMethod_Edit.method_percent;
        case 'exact':
          return t.B03_SplitMethod_Edit.method_exact;
        default:
          return method;
      }
    }

    showCommonWheelPicker(
      context: context,
      onConfirm: () => _switchMethod(tempMethod),
      child: CupertinoPicker(
        itemExtent: 40,
        scrollController: FixedExtentScrollController(
            initialItem: options.indexOf(_splitMethod)),
        onSelectedItemChanged: (index) => tempMethod = options[index],
        children: options.map((e) => Center(child: Text(getLabel(e)))).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 根據模式取得顯示名稱
    String methodLabel = _splitMethod;
    if (_splitMethod == 'even') {
      methodLabel = t.B03_SplitMethod_Edit.method_even;
    } else if (_splitMethod == 'percent') {
      methodLabel = t.B03_SplitMethod_Edit.method_percent;
    } else if (_splitMethod == 'exact') {
      methodLabel = t.B03_SplitMethod_Edit.method_exact;
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 1. Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(t.common.cancel,
                      style: const TextStyle(color: Colors.grey)),
                ),
                Text(t.B03_SplitMethod_Edit.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _isValid
                      ? () {
                          Navigator.pop(context, {
                            'splitMethod': _splitMethod,
                            'memberIds': _selectedMemberIds,
                            'details': _details,
                          });
                        }
                      : null,
                  child: Text(t.common.save,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isValid ? colorScheme.primary : Colors.grey)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 2. Info Bar (金額 & 方式)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.S15_Record_Edit.label_amount,
                        style: theme.textTheme.bodySmall),
                    Text(
                      "${widget.currencySymbol} ${NumberFormat("#,##0.##").format(widget.totalAmount)}",
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                InkWell(
                  onTap: _showMethodPicker,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(methodLabel,
                            style: TextStyle(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down,
                            color: colorScheme.onPrimaryContainer),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Content Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_splitMethod == 'even') _buildEvenSection(),
                if (_splitMethod == 'percent') _buildPercentSection(),
                if (_splitMethod == 'exact') _buildExactSection(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Method 1: Even (平分) ---
  Widget _buildEvenSection() {
    final theme = Theme.of(context);
    final count = _selectedMemberIds.length;
    final perPerson = count > 0 ? (widget.totalAmount / count) : 0.0;

    // 金額無條件捨去到小數第二位 (避免顯示金額總和超過總額)
    final displayAmount = (perPerson * 100).floor() / 100;
    // 計算餘額 (Leftover Pot)
    final remainder = widget.totalAmount - (displayAmount * count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 說明文字
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t.B03_SplitMethod_Edit.desc_even,
              style: const TextStyle(color: Colors.grey)),
        ),

        ...widget.allMembers.map((m) {
          final id = m['id'];
          final isSelected = _selectedMemberIds.contains(id);

          return CheckboxListTile(
            value: isSelected,
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
            title: Row(
              children: [
                CommonAvatar(avatarId: m['avatar'], name: m['name']),
                const SizedBox(width: 12),
                Expanded(child: Text(m['name'])),
                if (isSelected)
                  Text(
                    "${widget.currencySymbol} ${NumberFormat("#,##0.##").format(displayAmount)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  _selectedMemberIds.add(id);
                } else {
                  _selectedMemberIds.remove(id);
                }
              });
            },
          );
        }),

        // 餘額提示 (Leftover Pot)
        if (remainder > 0.001)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.savings,
                      color: theme.colorScheme.onTertiaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.B03_SplitMethod_Edit.msg_leftover_pot(
                          amount: NumberFormat("#,##0.##").format(remainder)),
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onTertiaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // --- Method 2: Percent (比例) ---
  // --- Method 2: Percent (比例) ---
  Widget _buildPercentSection() {
    final theme = Theme.of(context);
    final totalWeight = _details.values.fold(0.0, (prev, curr) => prev + curr);

    // 計算總分配金額 (無條件捨去，避免超發)
    // 算法： sum( floor(總額 * (權重/總權重) * 100) / 100 )
    double totalAllocated = 0.0;
    for (var m in widget.allMembers) {
      final id = m['id'];
      final weight = _details[id] ?? 0.0;
      if (weight > 0 && totalWeight > 0) {
        final percent = weight / totalWeight;
        // 這裡採用與 S30 結算一致的邏輯：先算出每個人應付多少，累加後看剩多少
        final amount = (widget.totalAmount * percent * 100).floor() / 100;
        totalAllocated += amount;
      }
    }

    // 計算餘額 (Leftover Pot)
    final remainder = widget.totalAmount - totalAllocated;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(t.B03_SplitMethod_Edit.desc_percent,
              style: const TextStyle(color: Colors.grey)),
        ),

        ...widget.allMembers.map((m) {
          final id = m['id'];
          final weight = _details[id] ?? 0.0;
          final isSelected = weight > 0;

          final percent = totalWeight > 0 ? (weight / totalWeight) : 0.0;

          // 計算顯示金額 (floor to 2 decimal)
          final amount = (widget.totalAmount * percent * 100).floor() / 100;

          // 顯示 1x, 1.5x
          // 移除 .0 結尾 (1.0x -> 1x)
          final weightStr =
              "${weight.toString().replaceAll(RegExp(r'\.0$'), '')}x";

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        // 勾選時，恢復預設權重 (預設值 1.0)
                        _details[id] = widget.defaultMemberWeights[id] ?? 1.0;
                        if (!_selectedMemberIds.contains(id)) {
                          _selectedMemberIds.add(id);
                        }
                      } else {
                        // 取消勾選，權重歸 0
                        _details[id] = 0.0;
                        _selectedMemberIds.remove(id);
                      }
                    });
                  },
                ),
                CommonAvatar(avatarId: m['avatar'], name: m['name']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m['name']),
                      if (isSelected)
                        // ✅ 修正 UI：下方顯示金額
                        Text(
                          "${widget.currencySymbol}${NumberFormat("#,##0.##").format(amount)}", // 顯示實際金額
                          style: TextStyle(
                              fontSize: 12, color: theme.colorScheme.outline),
                        ),
                    ],
                  ),
                ),

                // 調整權重區
                if (isSelected) ...[
                  IconButton.filledTonal(
                    icon: const Icon(Icons.remove, size: 16),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      setState(() {
                        double newW = (weight - 0.5);
                        if (newW <= 0) {
                          _details[id] = 0.0;
                          _selectedMemberIds.remove(id);
                        } else {
                          _details[id] = newW;
                        }
                      });
                    },
                  ),

                  // 顯示倍數 (1x)
                  SizedBox(
                    width: 50,
                    child: Text(
                      weightStr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                          fontSize: 16),
                    ),
                  ),

                  IconButton.filledTonal(
                    icon: const Icon(Icons.add, size: 16),
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () {
                      setState(() {
                        _details[id] = weight + 0.5;
                      });
                    },
                  ),
                ] else ...[
                  // 未勾選時顯示 0x
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text("0x", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ],
            ),
          );
        }),

        // 餘額提示 (Leftover Pot)
        // 即使是比例分攤，也可能除不盡，需要顯示
        if (remainder > 0.001)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.savings,
                      color: theme.colorScheme.onTertiaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t.B03_SplitMethod_Edit.msg_leftover_pot(
                          amount: NumberFormat("#,##0.##").format(remainder)),
                      style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onTertiaryContainer),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // --- Method 3: Exact (金額) ---
  Widget _buildExactSection() {
    final currentSum = _details.values.fold(0.0, (sum, v) => sum + v);
    final remaining = widget.totalAmount - currentSum;
    final isMatched = remaining.abs() < 0.1;

    return Column(
      children: [
        // 總額檢查 Bar (紅綠燈號)
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isMatched
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.B02_SplitExpense_Edit.label_total(
                  current: NumberFormat("#,##0.#").format(currentSum),
                  target: NumberFormat("#,##0.#").format(widget.totalAmount))),
              Text(
                isMatched
                    ? "OK"
                    : t.B03_SplitMethod_Edit.error_total_mismatch(
                        diff: NumberFormat("#,##0.#").format(remaining)),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMatched ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),

        ...widget.allMembers.map((m) {
          final id = m['id'];
          final isSelected = _selectedMemberIds.contains(id);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedMemberIds.add(id);
                        // UX 優化：勾選時自動填入剩餘金額
                        if (remaining > 0) {
                          _details[id] = remaining;
                          _amountControllers[id]?.text =
                              remaining.toStringAsFixed(1);
                        }
                      } else {
                        _selectedMemberIds.remove(id);
                        _details.remove(id);
                        _amountControllers[id]?.text = '';
                      }
                    });
                  },
                ),
                CommonAvatar(avatarId: m['avatar'], name: m['name']),
                const SizedBox(width: 12),
                Expanded(child: Text(m['name'])),
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: _amountControllers[id],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      hintText: '0',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: const OutlineInputBorder(),
                      enabled: isSelected, // 沒勾選不能打字
                    ),
                    onChanged: (val) {
                      setState(() {
                        final amount = double.tryParse(val) ?? 0.0;
                        if (amount > 0) {
                          _details[id] = amount;
                          if (!_selectedMemberIds.contains(id)) {
                            _selectedMemberIds.add(id);
                          }
                        } else {
                          _details.remove(id);
                          // 金額為0時這裡選擇不自動取消勾選，讓使用者自己決定
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
