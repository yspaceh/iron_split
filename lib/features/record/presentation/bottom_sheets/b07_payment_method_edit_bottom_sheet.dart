import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
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

  // --- 邏輯運算 (保持不變) ---

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

  void _onPrepayToggle(bool? val) {
    setState(() {
      _usePrepay = val ?? false;
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

  void _onAdvanceToggle(bool? val) {
    setState(() {
      _useAdvance = val ?? false;
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
    final v = double.tryParse(val) ?? 0.0;
    setState(() {
      _prepayAmount = v;
    });
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

        _prepayController.text = newText;
      }
    });
  }

  void _onSave() {
    if (!_isValid) return;

    bool finalUsePrepay = _usePrepay;
    if (_prepayAmount <= 0) {
      finalUsePrepay = false;
    }

    bool finalUseAdvance = _useAdvance;
    if (_currentAdvanceTotal <= 0) {
      finalUseAdvance = false;
    }

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
    final bool allowDecimal = widget.selectedCurrency.decimalDigits > 0;

    return CommonBottomSheet(
      title: t.B07_PaymentMethod_Edit.title,

      // 按鈕區域 (確認/取消)
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

      // 內容區域：分為「固定上方卡片」與「可捲動列表」
      children: Column(
        children: [
          // --- 1. 固定上方的 Summary 卡片 ---
          // 這裡的邏輯原本在最下方，現在搬到最上面
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(t.B07_PaymentMethod_Edit.total_label,
                      widget.totalAmount, widget.selectedCurrency,
                      isBold: true),
                  const SizedBox(height: 8),
                  if (_usePrepay)
                    _buildSummaryRow(
                      t.B07_PaymentMethod_Edit.total_prepay,
                      _prepayAmount,
                      widget.selectedCurrency,
                    ),
                  if (_useAdvance)
                    _buildSummaryRow(
                      t.B07_PaymentMethod_Edit.total_advance,
                      _currentAdvanceTotal,
                      widget.selectedCurrency,
                    ),
                  const Divider(),
                  _buildSummaryRow(
                    _isValid
                        ? t.B07_PaymentMethod_Edit.status_balanced
                        : t.B07_PaymentMethod_Edit.status_remaining(
                            amount: CurrencyConstants.formatAmount(
                                _remaining.abs(),
                                widget.selectedCurrency.code)),
                    _remaining,
                    widget.selectedCurrency,
                    hideAmount: true, // 邏輯不變：isValid 時顯示 "OK"
                    color: _isValid ? Colors.green : colorScheme.error,
                    isBold: true,
                    customValueText: _isValid ? "OK" : null,
                  ),
                ],
              ),
            ),
          ),

          // --- 2. 可捲動的輸入區 ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // 區塊 A: 預收公款
                _buildSectionHeader(
                  title: t.B07_PaymentMethod_Edit.type_prepay,
                  value: _usePrepay,
                  onChanged: _onPrepayToggle,
                ),
                if (_usePrepay) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 0, bottom: 16),
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
                                : colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _prepayController,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: allowDecimal),
                          onChanged: _onPrepayAmountChanged,
                          inputFormatters: [
                            allowDecimal
                                ? FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d*'))
                                : FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: t.B07_PaymentMethod_Edit.label_amount,
                            prefixText: "${widget.selectedCurrency.symbol} ",
                            prefixIcon:
                                const Icon(Icons.account_balance_wallet),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            errorText:
                                _prepayAmount > _currentCurrencyPoolBalance
                                    ? t.B07_PaymentMethod_Edit
                                        .err_balance_not_enough
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const Divider(),

                // 區塊 B: 成員代墊
                _buildSectionHeader(
                  title: t.B07_PaymentMethod_Edit.type_member,
                  value: _useAdvance,
                  onChanged: _onAdvanceToggle,
                ),
                if (_useAdvance) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, top: 8),
                    child: Column(
                      children: widget.members.map((m) {
                        final id = m['id'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              CommonAvatar(
                                avatarId: m['avatar'],
                                name: m['displayName'],
                                radius: 16,
                                fontSize: 14,
                                isLinked: m['isLinked'] ?? false,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                    m['displayName'] ??
                                        t.S53_TaskSettings_Members
                                            .member_default_name,
                                    style: theme.textTheme.bodyLarge),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _memberControllers[id],
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: allowDecimal),
                                  textAlign: TextAlign.end,
                                  inputFormatters: [
                                    allowDecimal
                                        ? FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d*'))
                                        : FilteringTextInputFormatter
                                            .digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    isDense: true,
                                    prefixText:
                                        "${widget.selectedCurrency.symbol} ",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (val) =>
                                      _onMemberAdvanceChanged(id, val),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
                // 底部留白
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers (保持不變) ---

  Widget _buildSectionHeader({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      String label, double amount, CurrencyConstants currencyConstants,
      {Color? color,
      bool isBold = false,
      bool hideAmount = false,
      String? customValueText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: color, fontWeight: isBold ? FontWeight.bold : null)),
        Text(
          customValueText ??
              CurrencyConstants.formatAmount(amount, currencyConstants.code),
          style: TextStyle(
              color: color, fontWeight: isBold ? FontWeight.bold : null),
        ),
      ],
    );
  }
}
