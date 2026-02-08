import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/core/utils/split_ratio_helper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_stepper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/compact_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/info_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';

class B03SplitMethodEditBottomSheet extends StatefulWidget {
  final double totalAmount;
  final CurrencyConstants selectedCurrency;
  final List<Map<String, dynamic>> allMembers; // 任務所有成員
  final Map<String, double> defaultMemberWeights; // 任務預設權重
  final double exchangeRate;
  final CurrencyConstants baseCurrency;

  // 初始狀態
  final String initialSplitMethod;
  final List<String> initialMemberIds;
  final Map<String, double> initialDetails;

  const B03SplitMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.selectedCurrency,
    required this.allMembers,
    required this.defaultMemberWeights,
    this.exchangeRate = 1.0,
    required this.baseCurrency,
    required this.initialSplitMethod,
    required this.initialMemberIds,
    required this.initialDetails,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required double totalAmount,
    required CurrencyConstants selectedCurrency,
    required List<Map<String, dynamic>> allMembers,
    required Map<String, double> defaultMemberWeights,
    double exchangeRate = 1.0,
    required CurrencyConstants baseCurrency,
    required String initialSplitMethod,
    required List<String> initialMemberIds,
    required Map<String, double> initialDetails,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B03SplitMethodEditBottomSheet(
        totalAmount: totalAmount,
        selectedCurrency: selectedCurrency,
        allMembers: allMembers,
        defaultMemberWeights: defaultMemberWeights,
        exchangeRate: exchangeRate,
        baseCurrency: baseCurrency,
        initialSplitMethod: initialSplitMethod,
        initialMemberIds: initialMemberIds,
        initialDetails: initialDetails,
      ),
    );
  }

  @override
  State<B03SplitMethodEditBottomSheet> createState() =>
      _B03SplitMethodEditBottomSheetState();
}

class _B03SplitMethodEditBottomSheetState
    extends State<B03SplitMethodEditBottomSheet> {
  late String _splitMethod; // 'even', 'percent', 'exact'
  late List<String> _selectedMemberIds;
  late Map<String, double> _details; // 儲存 金額(Exact) 或 權重(Percent)

  final Map<String, FocusNode> _focusNodes = {};

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
        text: val > 0
            ? CurrencyConstants.formatAmount(val, widget.selectedCurrency.code)
            : '',
      );
    }

    // 防呆：如果進來時沒選人，且是 Even 模式，預設全選
    if (_selectedMemberIds.isEmpty &&
        _splitMethod == SplitMethodConstant.even) {
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

  SplitResult _getSplitResult() {
    return BalanceCalculator.calculateSplit(
      totalAmount: widget.totalAmount,
      exchangeRate: widget.exchangeRate,
      splitMethod: _splitMethod,
      memberIds: _selectedMemberIds,
      details: _details,
      baseCurrency: widget.baseCurrency,
    );
  }

  void _switchMethod(String newMethod) {
    setState(() {
      _splitMethod = newMethod;
      // 切換模式時的數據轉換邏輯
      if (newMethod == SplitMethodConstant.percent) {
        // 切換到比例：載入預設權重
        _details.clear();
        for (var id in _selectedMemberIds) {
          _details[id] = widget.defaultMemberWeights[id] ?? 1.0;
        }
      } else if (newMethod == SplitMethodConstant.exact) {
        _details.clear();
        for (var c in _amountControllers.values) {
          c.clear();
        }
      }
    });
  }

  // 驗證是否可保存
  bool get _isValid {
    if (_selectedMemberIds.isEmpty) return false;

    if (_splitMethod == SplitMethodConstant.exact) {
      final sum = _details.values.fold(0.0, (prev, curr) => prev + curr);
      // 允許 0.1 的浮點誤差
      return (sum - widget.totalAmount).abs() < 0.1;
    }
    return true; // Even 和 Percent 只要有人選就可以
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = _getSplitResult();
    final int selectedIndex =
        SplitMethodConstant.allRules.indexOf(_splitMethod);

    //  使用 CommonBottomSheet
    return CommonBottomSheet(
      title: t.B03_SplitMethod_Edit.title,

      // 底部按鈕區：使用 .sheet 建構子
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          AppButton(
            text: t.common.buttons.save,
            type: AppButtonType.primary,
            // 邏輯直接取自原本 TextButton 的 onPressed
            onPressed: _isValid
                ? () {
                    Navigator.pop(context, {
                      'splitMethod': _splitMethod,
                      'memberIds': _selectedMemberIds,
                      'details': _details,
                    });
                  }
                : null,
          ),
        ],
      ),

      // 內容區：改為 Column 結構，實現「上方固定，下方捲動」
      children: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CustomSlidingSegment<int>(
              selectedValue: selectedIndex,
              onValueChanged: (val) {
                setState(() {
                  _switchMethod(SplitMethodConstant.allRules[val]);
                });
              },
              segments: {
                0: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.even),
                1: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.exact),
                2: SplitMethodConstant.getLabel(
                    context, SplitMethodConstant.percent),
              },
            ),
          ),
          // 1. Info Bar (金額 & 方式) - 固定在上方
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SummaryRow(
                    label: t.S15_Record_Edit.label.amount,
                    amount: widget.totalAmount,
                    currencyConstants: widget.selectedCurrency),
                if (widget.exchangeRate != 1.0) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "≈ ${widget.baseCurrency.code}${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(result.totalAmount.base, widget.baseCurrency.code)}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Divider(
                  height: 1,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
                InfoBar(
                  icon: Icons.savings_outlined,
                  backgroundColor: colorScheme.surface,
                  text: Text(
                    t.common.remainder_rule.message_remainder(
                        amount:
                            "${widget.baseCurrency.code}${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(_selectedMemberIds.isEmpty ? 0 : result.remainder, widget.baseCurrency.code)}"),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // 2. Content Area - 捲動區
          // 使用 Expanded 佔滿剩餘高度，內部使用 ListView 實現捲動
          Expanded(
            child: ListView(
              children: [
                // 注意：這裡假設您的原始檔案中有定義 _buildEvenSection 等方法
                // 否則這裡會報錯。如果您需要我補上這些方法的空殼或實作，請告知。
                if (_splitMethod == SplitMethodConstant.even)
                  _buildEvenSection(t),
                if (_splitMethod == SplitMethodConstant.percent)
                  _buildPercentSection(t),
                if (_splitMethod == SplitMethodConstant.exact)
                  _buildExactSection(t),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Method 1: Even (平分) ---
  Widget _buildEvenSection(Translations t) {
    // Pass t
    final theme = Theme.of(context);

    // 使用新的計算邏輯
    final result = _getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.allMembers.map((m) {
          final id = m['id'];
          final isSelected = _selectedMemberIds.contains(id);
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedMemberIds.remove(id);
                } else {
                  _selectedMemberIds.add(id);
                }
              });
            },
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: Visibility(
              visible: isSelected,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, widget.selectedCurrency.code)}",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (widget.exchangeRate != 1.0)
                    Builder(builder: (context) {
                      final baseCurrency =
                          CurrencyConstants.getCurrencyConstants(
                              widget.baseCurrency.code);
                      return Text(
                        "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      );
                    }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // --- Method 2: Percent (比例) ---
  Widget _buildPercentSection(Translations t) {
    // Pass t
    final theme = Theme.of(context);

    final result = _getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.allMembers.map((m) {
          final id = m['id'];
          final weight = _details[id] ?? 0.0;
          final isSelected = weight > 0;
          final amount = memberAmounts[id]?.original ?? 0.0;
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () {
              setState(() {
                if (!isSelected) {
                  _details[id] = widget.defaultMemberWeights[id] ?? 1.0;
                  if (!_selectedMemberIds.contains(id)) {
                    _selectedMemberIds.add(id);
                  }
                } else {
                  _details[id] = 0.0;
                  _selectedMemberIds.remove(id);
                }
              });
            },
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (isSelected) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${widget.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, widget.selectedCurrency.code)}",
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (widget.exchangeRate != 1.0)
                            Builder(builder: (context) {
                              final baseCurrency =
                                  CurrencyConstants.getCurrencyConstants(
                                      widget.baseCurrency.code);
                              return Text(
                                "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              );
                            }),
                        ],
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 8),
                AppStepper(
                  text: SplitRatioHelper.format(weight),
                  onDecrease: () {
                    setState(() {
                      double newW = SplitRatioHelper.decrease(weight);
                      _details[id] = newW;
                      if (newW == 0.0) {
                        _selectedMemberIds.remove(id);
                      }
                    });
                  },
                  onIncrease: () {
                    setState(() {
                      double newW = SplitRatioHelper.increase(weight);
                      _details[id] = newW;
                      if (newW > 0 && !_selectedMemberIds.contains(id)) {
                        _selectedMemberIds.add(id);
                      }
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- Method 3: Exact (金額) ---
  Widget _buildExactSection(Translations t) {
    // Pass t
    final theme = Theme.of(context);
    final currentSum = _details.values.fold(0.0, (sum, v) => sum + v);
    final remaining = widget.totalAmount - currentSum;
    final isMatched = remaining.abs() < 0.1;
    final result = _getSplitResult();
    final memberAmounts = result.memberAmounts;

    return Column(
      children: [
        const SizedBox(height: 12),
        SummaryRow(
          label: t.B03_SplitMethod_Edit.label.total(
              current: CurrencyConstants.formatAmount(
                  currentSum, widget.selectedCurrency.code),
              target: CurrencyConstants.formatAmount(
                  widget.totalAmount, widget.selectedCurrency.code)),
          amount: 0,
          currencyConstants: widget.selectedCurrency,
          customValueText: isMatched ? "OK" : t.B03_SplitMethod_Edit.mismatch,
          valueColor:
              isMatched ? theme.colorScheme.tertiary : theme.colorScheme.error,
        ),
        const SizedBox(height: 8),
        ...widget.allMembers.map((m) {
          final id = m['id'];
          final isSelected = _selectedMemberIds.contains(id);
          final node = _focusNodes.putIfAbsent(id, () => FocusNode());
          final baseAmount = memberAmounts[id]?.base ?? 0.0;

          return SelectionTile(
            isSelected: isSelected,
            isRadio: false,
            onTap: () {
              setState(() {
                if (!isSelected) {
                  _selectedMemberIds.add(id);
                  if (remaining > 0) {
                    _details[id] = remaining;
                    _amountControllers[id]?.text =
                        CurrencyConstants.formatAmount(
                            remaining, widget.selectedCurrency.code);
                  }
                  node.requestFocus(); // 點擊整條就自動跳鍵盤
                } else {
                  _selectedMemberIds.remove(id);
                  _details.remove(id);
                  _amountControllers[id]?.text = '';
                }
              });
            },
            leading: CommonAvatar(
                avatarId: m['avatar'],
                name: m['displayName'],
                isLinked: m['isLinked'] ?? false),
            title: m['displayName'],
            trailing: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CompactAmountInput(
                    controller: _amountControllers[id],
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
                    hintText: '0',
                    currencyConstants: widget.selectedCurrency,
                  ),
                  if (isSelected && widget.exchangeRate != 1.0)
                    Builder(
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "≈ ${widget.baseCurrency.code}${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, widget.baseCurrency.code)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
