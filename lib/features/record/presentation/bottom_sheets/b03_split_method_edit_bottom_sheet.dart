import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/utils/balance_calculator.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_selection_tile.dart';
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

  void _switchToExactMode() {
    setState(() {
      _splitMethod = SplitMethodConstant.exact;
      // 關鍵：清空選取與細節，讓使用者從零開始輸入
      _selectedMemberIds.clear();
      _details.clear();
      // 清空所有 Controller，確保介面乾淨
      _amountControllers.values.forEach((c) => c.clear());
    });
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
        // 切換到金額：清空，讓使用者自己打
        _details.clear();
        _switchToExactMode();
        for (var c in _amountControllers.values) {
          c.text = '';
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
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
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
                    t.S15_Record_Edit.msg_leftover_pot(
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

          return CommonSelectionTile(
            isSelected: isSelected,
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
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (widget.exchangeRate != 1.0)
                    Builder(builder: (context) {
                      final baseCurrency =
                          CurrencyConstants.getCurrencyConstants(
                              widget.baseCurrency.code);
                      return Text(
                        "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey, fontSize: 10),
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

          return CommonSelectionTile(
            isSelected: isSelected,
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
            trailing: Row(
              children: [
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
                      Text(
                        "${widget.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(amount, widget.selectedCurrency.code)}",
                        style: theme.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (widget.exchangeRate != 1.0)
                        Builder(builder: (context) {
                          final baseCurrency =
                              CurrencyConstants.getCurrencyConstants(
                                  widget.baseCurrency.code);
                          return Text(
                            "≈ ${baseCurrency.code}${baseCurrency.symbol} ${CurrencyConstants.formatAmount(baseAmount, baseCurrency.code)}",
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey, fontSize: 10),
                          );
                        }),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
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
                ]
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

    return Column(
      children: [
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
              Text(t.B03_SplitMethod_Edit.label_total(
                  current: CurrencyConstants.formatAmount(
                      currentSum, widget.selectedCurrency.code),
                  target: CurrencyConstants.formatAmount(
                      widget.totalAmount, widget.selectedCurrency.code))),
              Visibility(
                visible: isMatched,
                replacement: Text(
                  t.B03_SplitMethod_Edit.error_total_mismatch,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                child: Icon(Icons.check_circle_outline_outlined,
                    size: 20, color: Colors.green),
              ),
            ],
          ),
        ),
        ...widget.allMembers.map((m) {
          final id = m['id'];
          final isSelected = _selectedMemberIds.contains(id);
          final node = _focusNodes.putIfAbsent(id, () => FocusNode());

          return CommonSelectionTile(
            isSelected: isSelected,
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
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: _amountControllers[id],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      hintText: '0',
                      prefixText: widget.selectedCurrency.symbol,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border: const OutlineInputBorder(),
                      // 1. 平常沒點擊時的邊框顏色 (建議用淡淡的灰色)
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color:
                              Colors.grey.withValues(alpha: 0.3), // 淡淡的邊框，不會太搶眼
                          width: 1.0,
                        ),
                      ),

                      // 2. 正在點擊輸入時的邊框顏色 (通常用主題色)
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary, // 主題色
                          width: 1.5, // 稍微加粗，增加焦點感
                        ),
                      ),

                      // 3. 欄位被停用時的邊框 (如果 isSelected 為 false)
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.transparent, // 隱藏邊框，讓它看起來像背景的一部分
                        ),
                      ),
                      enabled: isSelected,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
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
                            "≈ ${widget.baseCurrency.symbol} ${CurrencyConstants.formatAmount(converted, widget.baseCurrency.code)}",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
          );
        }),
      ],
    );
  }
}
