import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/gen/strings.g.dart';

class B03SplitMethodEditBottomSheet extends StatefulWidget {
  final double totalAmount;
  final String currencySymbol;
  final List<Map<String, dynamic>> allMembers; // 任務所有成員
  final Map<String, double> defaultMemberWeights; // 任務預設權重
  final double exchangeRate;
  final String baseCurrencySymbol;
  final String baseCurrencyCode;

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
    this.exchangeRate = 1.0,
    required this.baseCurrencySymbol,
    required this.baseCurrencyCode,
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

  /// 計算分攤結果
  /// Returns:
  /// - sourceAmounts: 每個成員應付的 Source Currency 金額 (用於 UI 顯示)
  /// - baseAmounts: 每個成員應付的 Base Currency 金額 (用於 UI 顯示近似值)
  /// - baseRemainder: 轉換為 Base Currency 後的餘額 (用於存入 Buffer)
  ({
    Map<String, double> sourceAmounts,
    Map<String, double> baseAmounts,
    double baseRemainder
  }) _calculateSplit() {
    final Map<String, double> sourceAmounts = {};
    final Map<String, double> baseAmounts = {};

    // 1. 計算 Base Total (Anchor)
    final baseTotal =
        (widget.totalAmount * widget.exchangeRate).roundToDouble();

    // 2. 計算 Total Weight
    double totalWeight = 0.0;

    if (_splitMethod == 'even') {
      totalWeight = _selectedMemberIds.length.toDouble();
    } else if (_splitMethod == 'percent') {
      // Fix Math: 只計算選中成員的權重
      for (var id in _selectedMemberIds) {
        totalWeight += _details[id] ?? 0.0;
      }
    } else if (_splitMethod == 'exact') {
      // Exact 模式不使用權重
      totalWeight = 1.0;
    }

    // 3. 計算每個人的 Base Share 和 Source Share
    double allocatedBase = 0.0;

    if (_splitMethod == 'exact') {
      // Exact 模式：直接使用使用者輸入的 Source Amount
      for (var id in _selectedMemberIds) {
        final sourceAmount = _details[id] ?? 0.0;
        sourceAmounts[id] = sourceAmount;

        // 轉換為 Base Share (近似)
        final baseShare = (sourceAmount * widget.exchangeRate).floorToDouble();
        baseAmounts[id] = baseShare;
        allocatedBase += baseShare;
      }
    } else {
      // Even & Percent 模式
      if (totalWeight > 0) {
        for (var id in _selectedMemberIds) {
          double weight = 0.0;
          if (_splitMethod == 'even') {
            weight = 1.0;
          } else {
            weight = _details[id] ?? 0.0;
          }

          final ratio = weight / totalWeight;

          // A. Source Currency Calculation (For Display)
          // 保留兩位小數
          final sourceShare =
              (widget.totalAmount * ratio * 100).floorToDouble() / 100;
          sourceAmounts[id] = sourceShare;

          // B. Base Currency Calculation (For Buffer)
          // Project Bible 5.8: Floor(BaseTotal * Weight / TotalWeight)
          final baseShare = (baseTotal * ratio).floorToDouble();
          baseAmounts[id] = baseShare;
          allocatedBase += baseShare;
        }
      }
    }

    // 4. 計算 Base Remainder
    final baseRemainder = baseTotal - allocatedBase;

    return (
      sourceAmounts: sourceAmounts,
      baseAmounts: baseAmounts,
      baseRemainder: baseRemainder
    );
  }

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
                    if (widget.exchangeRate != 1.0)
                      Text(
                        "≈ ${widget.baseCurrencySymbol} ${CurrencyOption.formatAmount(widget.totalAmount * widget.exchangeRate, widget.baseCurrencyCode)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
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

    // 使用新的計算邏輯
    final result = _calculateSplit();
    final sourceAmounts = result.sourceAmounts;
    final baseAmounts = result.baseAmounts;
    final baseRemainder = result.baseRemainder;

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
          final amount = sourceAmounts[id] ?? 0.0;
          final baseAmount = baseAmounts[id] ?? 0.0;

          return InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedMemberIds.remove(id);
                } else {
                  _selectedMemberIds.add(id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedMemberIds.add(id);
                        } else {
                          _selectedMemberIds.remove(id);
                        }
                      });
                    },
                  ),
                  CommonAvatar(
                      avatarId: m['avatar'],
                      name: m['name'],
                      isLinked: m['isLinked'] ?? false),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(m['name'], overflow: TextOverflow.ellipsis)),
                  if (isSelected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.currencySymbol} ${NumberFormat("#,##0.##").format(amount)}",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (widget.exchangeRate != 1.0)
                          Builder(builder: (context) {
                            final baseOption = kSupportedCurrencies.firstWhere(
                                (e) => e.code == widget.baseCurrencyCode,
                                orElse: () => kSupportedCurrencies.first);
                            return Text(
                              "≈ ${baseOption.code} ${baseOption.symbol} ${baseOption.format(baseAmount)}",
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey, fontSize: 10),
                            );
                          }),
                      ],
                    ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          );
        }),

        // 餘額提示 (Base Currency Remainder)
        if (baseRemainder > 0)
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
                          amount:
                              "$baseRemainder ${widget.baseCurrencySymbol}"),
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
  Widget _buildPercentSection() {
    final theme = Theme.of(context);

    // 使用新的計算邏輯
    final result = _calculateSplit();
    final sourceAmounts = result.sourceAmounts;
    final baseAmounts = result.baseAmounts;
    final baseRemainder = result.baseRemainder;

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
          final amount = sourceAmounts[id] ?? 0.0;
          final baseAmount = baseAmounts[id] ?? 0.0;

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
                CommonAvatar(
                    avatarId: m['avatar'],
                    name: m['name'],
                    isLinked: m['isLinked'] ?? false),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(m['name'], overflow: TextOverflow.ellipsis)),

                // Amounts Column
                if (isSelected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.currencySymbol} ${NumberFormat("#,##0.##").format(amount)}",
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (widget.exchangeRate != 1.0)
                        Builder(builder: (context) {
                          final baseOption = kSupportedCurrencies.firstWhere(
                              (e) => e.code == widget.baseCurrencyCode,
                              orElse: () => kSupportedCurrencies.first);
                          return Text(
                            "≈ ${baseOption.code} ${baseOption.symbol} ${baseOption.format(baseAmount)}",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 10),
                          );
                        }),
                    ],
                  ),

                const SizedBox(width: 12),

                // 調整權重區
                if (isSelected) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${weight.toStringAsFixed(1)}x",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: theme.colorScheme.outlineVariant),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  double newW = (weight - 0.5).clamp(0.0, 2.0);
                                  if (newW == 0.0) {
                                    _details[id] = 0.0;
                                    _selectedMemberIds.remove(id);
                                  } else {
                                    _details[id] = newW;
                                  }
                                });
                              },
                              borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Icon(Icons.remove, size: 18),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 16,
                              color: theme.colorScheme.outlineVariant,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  double newW = (weight + 0.5).clamp(0.0, 2.0);
                                  _details[id] = newW;
                                });
                              },
                              borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(8)),
                              child: const Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Icon(Icons.add, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

        // 餘額提示 (Base Currency Remainder)
        if (baseRemainder > 0)
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
                          amount:
                              "$baseRemainder ${widget.baseCurrencySymbol}"),
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
                CommonAvatar(
                    avatarId: m['avatar'],
                    name: m['name'],
                    isLinked: m['isLinked'] ?? false),
                const SizedBox(width: 12),
                Expanded(child: Text(m['name'])),
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
                        controller: _amountControllers[id],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          hintText: '0',
                          prefixText: widget.currencySymbol,
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
                            }
                          });
                        },
                      ),
                      if (isSelected && widget.exchangeRate != 1.0)
                        Builder(
                          builder: (context) {
                            final val = double.tryParse(
                                    _amountControllers[id]?.text ?? '') ??
                                0.0;
                            final converted = val * widget.exchangeRate;
                            return Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                "≈ ${widget.baseCurrencySymbol} ${CurrencyOption.formatAmount(converted, widget.baseCurrencyCode)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                              ),
                            );
                          },
                        ),
                    ],
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
