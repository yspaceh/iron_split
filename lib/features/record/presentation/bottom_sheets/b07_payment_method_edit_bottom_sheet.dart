import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/form/compact_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_card.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';

class B07PaymentMethodEditBottomSheet extends StatefulWidget {
  final double totalAmount; // 該筆費用的總金額
  final Map<String, double> poolBalancesByCurrency;
  final List<Map<String, dynamic>> members; // 成員清單
  final CurrencyConstants selectedCurrency;
  final CurrencyConstants baseCurrency;

  // 初始狀態
  final bool initialUsePrepay;
  final double initialPrepayAmount;
  final Map<String, double> initialMemberAdvance; // 成員代墊明細 {id: amount}

  const B07PaymentMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.poolBalancesByCurrency,
    required this.members,
    this.initialUsePrepay = true,
    this.initialPrepayAmount = 0.0,
    this.initialMemberAdvance = const {},
    required this.selectedCurrency,
    required this.baseCurrency,
  });

  static Future<Map<String, dynamic>?> show(BuildContext context,
      {required double totalAmount, // 該筆費用的總金額
      required Map<String, double> poolBalancesByCurrency,
      required List<Map<String, dynamic>> members, // 成員清單
      required CurrencyConstants selectedCurrency,
      required CurrencyConstants baseCurrency,
      bool initialUsePrepay = true,
      double initialPrepayAmount = 0.0,
      Map<String, double> initialMemberAdvance = const {}}) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B07PaymentMethodEditBottomSheet(
        totalAmount: totalAmount,
        poolBalancesByCurrency: poolBalancesByCurrency,
        selectedCurrency: selectedCurrency,
        baseCurrency: baseCurrency,
        members: members,
        initialUsePrepay: initialUsePrepay,
        initialPrepayAmount: initialPrepayAmount,
        initialMemberAdvance: initialMemberAdvance,
      ),
    );
  }

  @override
  State<B07PaymentMethodEditBottomSheet> createState() =>
      _B07PaymentMethodEditBottomSheetState();
}

class _B07PaymentMethodEditBottomSheetState
    extends State<B07PaymentMethodEditBottomSheet> {
  // State
  late bool _usePrepay;
  late double _prepayAmount;

  late bool _useAdvance;
  late Map<String, double> _memberAdvance;

  // Controllers
  final Map<String, TextEditingController> _memberControllers = {};
  late TextEditingController _prepayController;

  @override
  void initState() {
    super.initState();
    _usePrepay = widget.initialUsePrepay;

    // 初始化代墊
    _memberAdvance = Map.from(widget.initialMemberAdvance);
    for (var m in widget.members) {
      if (!_memberAdvance.containsKey(m['id'])) {
        _memberAdvance[m['id']] = 0.0;
      }
    }

    // 檢查是否有使用代墊
    double advanceTotal =
        _memberAdvance.values.fold(0, (sum, val) => sum + val);
    _useAdvance = advanceTotal > 0 || !widget.initialUsePrepay;

    // 初始化預收金額
    if (_usePrepay && widget.initialPrepayAmount == 0 && advanceTotal == 0) {
      _prepayAmount = _calculateAutoPrepay(0);
    } else {
      _prepayAmount = widget.initialPrepayAmount;
    }

    // 初始化預收 Controller
    _prepayController = TextEditingController(
        text: _prepayAmount == 0
            ? ''
            : CurrencyConstants.formatAmount(
                _prepayAmount, widget.selectedCurrency.code));

    // 監聽預收 Controller 變更 (TaskAmountInput 用)
    _prepayController.addListener(() {
      final val = _prepayController.text.replaceAll(',', '');
      _onPrepayAmountChanged(val);
    });

    // 初始化成員 Controller
    for (var m in widget.members) {
      final id = m['id'];
      final val = _memberAdvance[id] ?? 0.0;
      _memberControllers[id] = TextEditingController(
          text: val == 0
              ? ''
              : CurrencyConstants.formatAmount(
                  val, widget.selectedCurrency.code));
    }
  }

  @override
  void dispose() {
    _prepayController.dispose();
    for (var c in _memberControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  // --- 邏輯運算 ---

  double get _currentAdvanceTotal =>
      _memberAdvance.values.fold(0.0, (sum, val) => sum + val);

  double get _currentTotalPay =>
      (_usePrepay ? _prepayAmount : 0.0) +
      (_useAdvance ? _currentAdvanceTotal : 0.0);

  double get _remaining => widget.totalAmount - _currentTotalPay;

  bool get _isValid => (_remaining.abs() < 0.01);

  double get _currentCurrencyPoolBalance {
    return widget.poolBalancesByCurrency[widget.selectedCurrency.code] ?? 0.0;
  }

  double _calculateAutoPrepay(double advanceTotal) {
    double needed = widget.totalAmount - advanceTotal;
    if (needed < 0) needed = 0;
    // 上限是當前幣別的餘額
    return needed > _currentCurrencyPoolBalance
        ? _currentCurrencyPoolBalance
        : needed;
  }

  void _onPrepayToggle() {
    setState(() {
      _usePrepay = !_usePrepay;
      if (_usePrepay) {
        _prepayAmount = _calculateAutoPrepay(_currentAdvanceTotal);
        _prepayController.text = _prepayAmount == 0
            ? ''
            : CurrencyConstants.formatAmount(
                _prepayAmount, widget.selectedCurrency.code);
      } else {
        _prepayAmount = 0.0;
        _prepayController.text = '';
        if (!_useAdvance) {
          _useAdvance = true;
        }
      }
    });
  }

  void _onAdvanceToggle() {
    setState(() {
      _useAdvance = !_useAdvance;
      if (!_useAdvance) {
        for (var key in _memberAdvance.keys) {
          _memberAdvance[key] = 0.0;
          _memberControllers[key]?.text = '';
        }
        if (!_usePrepay) {
          _usePrepay = true;
          _prepayAmount = _calculateAutoPrepay(0);
          _prepayController.text = CurrencyConstants.formatAmount(
              _prepayAmount, widget.selectedCurrency.code);
        }
      }
    });
  }

  void _onPrepayAmountChanged(String val) {
    // 這裡只是更新 state數值，Controller 已經由 TaskAmountInput 更新了
    final v = double.tryParse(val) ?? 0.0;
    if (_prepayAmount != v) {
      setState(() {
        _prepayAmount = v;
      });
    }
  }

  void _onMemberAdvanceChanged(String memberId, String val) {
    final v = double.tryParse(val) ?? 0.0;

    setState(() {
      _memberAdvance[memberId] = v;
      if (_usePrepay) {
        _prepayAmount = _calculateAutoPrepay(_currentAdvanceTotal);
        String newText = _prepayAmount == 0
            ? ''
            : CurrencyConstants.formatAmount(
                _prepayAmount, widget.selectedCurrency.code);

        // 只有當數值變動才更新 Controller，避免游標跳動
        if (_prepayController.text != newText) {
          _prepayController.text = newText;
        }
      }
    });
  }

  void _onSave() {
    if (!_isValid) return;

    bool finalUsePrepay = _usePrepay;
    if (_prepayAmount <= 0) finalUsePrepay = false;

    bool finalUseAdvance = _useAdvance;
    if (_currentAdvanceTotal <= 0) finalUseAdvance = false;

    final result = {
      'usePrepay': finalUsePrepay,
      'prepayAmount': finalUsePrepay ? _prepayAmount : 0.0,
      'useAdvance': finalUseAdvance,
      'memberAdvance': finalUseAdvance ? _memberAdvance : <String, double>{},
    };
    Navigator.pop(context, result);
  }

  // --- UI 建構 ---

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonBottomSheet(
      title: t.B07_PaymentMethod_Edit.title,
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
            onPressed: _isValid ? _onSave : null,
          ),
        ],
      ),
      children: Column(
        children: [
          // 1. 固定高度的 Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                SummaryRow(
                  label: t.B07_PaymentMethod_Edit.total_label,
                  amount: widget.totalAmount,
                  currencyConstants: widget.selectedCurrency,
                ),
                const SizedBox(height: 8),
                // 即使金額為0也顯示，保持高度穩定
                SummaryRow(
                  label: t.B07_PaymentMethod_Edit.total_prepay,
                  amount: _usePrepay ? _prepayAmount : 0.0,
                  currencyConstants: widget.selectedCurrency,
                ),
                const SizedBox(height: 4),
                SummaryRow(
                  label: t.B07_PaymentMethod_Edit.total_advance,
                  amount: _useAdvance ? _currentAdvanceTotal : 0.0,
                  currencyConstants: widget.selectedCurrency,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 1,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                ),
                SummaryRow(
                  label: _isValid
                      ? t.B07_PaymentMethod_Edit.status_balanced
                      : t.B07_PaymentMethod_Edit.status_remaining(
                          amount: CurrencyConstants.formatAmount(
                              _remaining.abs(), widget.selectedCurrency.code)),
                  amount: _remaining,
                  currencyConstants: widget.selectedCurrency,
                  hideAmount: true,
                  valueColor:
                      _isValid ? colorScheme.tertiary : colorScheme.error,
                  customValueText: _isValid ? "OK" : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 2. 選擇區域
          Expanded(
            child: ListView(
              children: [
                // A. 公款支付卡片
                SelectionCard(
                  title: t.B07_PaymentMethod_Edit.type_prepay,
                  isSelected: _usePrepay,
                  isRadio: false,
                  onToggle: _onPrepayToggle,
                  // 如果收合時也想顯示金額在右側，可在此傳入 trailing
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 餘額提示
                      Text(
                        t.B07_PaymentMethod_Edit.prepay_balance(
                            amount:
                                "${widget.selectedCurrency.code}${widget.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(_currentCurrencyPoolBalance, widget.selectedCurrency.code)}"),
                        style: TextStyle(
                          color: _currentCurrencyPoolBalance <
                                      widget.totalAmount &&
                                  _usePrepay
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 重用 TaskAmountInput
                      TaskAmountInput(
                        amountController: _prepayController,
                        selectedCurrencyConstants: widget.selectedCurrency,
                        showCurrencyPicker: false, // 隱藏幣別選擇器
                        externalValidator: (val) {
                          if (val > _currentCurrencyPoolBalance) {
                            return t
                                .B07_PaymentMethod_Edit.err_balance_not_enough;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // B. 成員墊付卡片
                SelectionCard(
                  title: t.B07_PaymentMethod_Edit.type_member,
                  isSelected: _useAdvance,
                  isRadio: false,
                  onToggle: _onAdvanceToggle,
                  child: Column(
                    children: widget.members.map((m) {
                      final id = m['id'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            CommonAvatar(
                              avatarId: m['avatar'],
                              name: m['displayName'],
                              radius: 18,
                              fontSize: 14,
                              isLinked: m['isLinked'] ?? false,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                  m['displayName'] ??
                                      t.S53_TaskSettings_Members
                                          .member_default_name,
                                  style: theme.textTheme.bodyLarge),
                            ),
                            const SizedBox(width: 8),
                            // 使用 Compact Input
                            SizedBox(
                              width: 120, // 限制寬度
                              child: CompactAmountInput(
                                controller: _memberControllers[id],
                                onChanged: (val) =>
                                    _onMemberAdvanceChanged(id, val),
                                hintText: '0',
                                currencyConstants: widget.selectedCurrency,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // 底部留白
                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
