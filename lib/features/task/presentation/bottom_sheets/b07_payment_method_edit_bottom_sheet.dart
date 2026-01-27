import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/gen/strings.g.dart';

class B07PaymentMethodEditBottomSheet extends StatefulWidget {
  final double totalAmount; // 該筆費用的總金額
  final double prepayBalance;
  final List<Map<String, dynamic>> members; // 成員清單
  final CurrencyOption selectedCurrency;
  final CurrencyOption baseCurrency;

  // 初始狀態
  final bool initialUsePrepay;
  final double initialPrepayAmount;
  final Map<String, double> initialMemberAdvance; // 成員代墊明細 {id: amount}

  const B07PaymentMethodEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.prepayBalance,
    required this.members,
    this.initialUsePrepay = true,
    this.initialPrepayAmount = 0.0,
    this.initialMemberAdvance = const {},
    required this.selectedCurrency,
    required this.baseCurrency,
  });

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
  late TextEditingController _prepayController; // ✅ 新增：預收也需要 Controller

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

    // ✅ 初始化預收 Controller
    _prepayController = TextEditingController(
        text: _prepayAmount == 0 ? '' : _prepayAmount.toStringAsFixed(1));

    // 初始化成員 Controller
    for (var m in widget.members) {
      final id = m['id'];
      final val = _memberAdvance[id] ?? 0.0;
      _memberControllers[id] =
          TextEditingController(text: val == 0 ? '' : val.toStringAsFixed(1));
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

  double _calculateAutoPrepay(double advanceTotal) {
    double needed = widget.totalAmount - advanceTotal;
    if (needed < 0) needed = 0;
    return needed > widget.prepayBalance ? widget.prepayBalance : needed;
  }

  void _onPrepayToggle(bool? val) {
    setState(() {
      _usePrepay = val ?? false;
      if (_usePrepay) {
        // 自動計算並更新 Controller
        _prepayAmount = _calculateAutoPrepay(_currentAdvanceTotal);
        _prepayController.text =
            _prepayAmount == 0 ? '' : _prepayAmount.toStringAsFixed(1);
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
        // 清空所有代墊
        for (var key in _memberAdvance.keys) {
          _memberAdvance[key] = 0.0;
          _memberControllers[key]?.text = '';
        }

        if (!_usePrepay) {
          _usePrepay = true;
          _prepayAmount = _calculateAutoPrepay(0);
          _prepayController.text = _prepayAmount.toStringAsFixed(1);
        }
      }
    });
  }

  void _onPrepayAmountChanged(String val) {
    final v = double.tryParse(val) ?? 0.0;
    setState(() {
      _prepayAmount = v;
      // 注意：這裡是使用者手動輸入，絕對不要去 set text，否則游標會跳
    });
  }

  void _onMemberAdvanceChanged(String memberId, String val) {
    final v = double.tryParse(val) ?? 0.0;

    setState(() {
      _memberAdvance[memberId] = v;

      // 當代墊改變，若開啟預收，系統要自動調整預收金額
      if (_usePrepay) {
        _prepayAmount = _calculateAutoPrepay(_currentAdvanceTotal);

        // ✅ 關鍵：因為是「系統自動調整」，所以要同步更新預收的 Controller 文字
        // 這樣使用者才會看到預收金額變了
        String newText =
            _prepayAmount == 0 ? '' : _prepayAmount.toStringAsFixed(1);

        // 只有當數值真的變了，且使用者目前沒有正在編輯預收欄位(簡單判斷)才更新
        // 這裡直接更新通常沒問題，因為使用者的焦點現在是在「成員代墊」欄位上
        _prepayController.text = newText;
      }
    });
  }

  void _onSave() {
    if (!_isValid) return;

    // 就算 UI 上有勾選，但如果金額是 0，就視為「沒勾選」
    // 這樣可以避免「預收 0 + 代墊 1000」被判定為「混合支付」
    bool finalUsePrepay = _usePrepay;
    if (_prepayAmount <= 0) {
      finalUsePrepay = false;
    }

    // 同理，如果代墊總額為 0，也視為沒用代墊
    // 避免「預收 1000 + 代墊 0」被判定為「混合支付」
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                Text(
                  t.B07_PaymentMethod_Edit.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _isValid ? _onSave : null,
                  child: Text(
                    t.common.save,
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

          // 2. 內容捲動區
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // --- 區塊 A: 預收公款 ---
                _buildSectionHeader(
                  title: t.B07_PaymentMethod_Edit.type_prepay,
                  value: _usePrepay,
                  onChanged: _onPrepayToggle,
                ),
                if (_usePrepay) ...[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 餘額提示
                        Text(
                          t.B07_PaymentMethod_Edit.prepay_balance(
                              amount:
                                  "≈ ${widget.baseCurrency.code}${widget.baseCurrency.symbol} ${CurrencyOption.formatAmount(widget.prepayBalance, widget.selectedCurrency.code)}"),
                          style: TextStyle(
                            color: widget.prepayBalance < widget.totalAmount &&
                                    _usePrepay
                                ? colorScheme.error
                                : colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // ✅ 修正：改用 Controller，移除 Key，解決焦點遺失問題
                        TextFormField(
                          controller: _prepayController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: _onPrepayAmountChanged,
                          decoration: InputDecoration(
                            labelText: t.B07_PaymentMethod_Edit.label_amount,
                            prefixText: "${widget.selectedCurrency.symbol} ",
                            prefixIcon:
                                const Icon(Icons.account_balance_wallet),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            errorText: _prepayAmount > widget.prepayBalance
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

                // --- 區塊 B: 成員代墊 ---
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
                                name: m['name'],
                                radius: 16,
                                fontSize: 14,
                                isLinked: m['isLinked'] ?? false,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(m['name'] ?? '成員', // TODO: 之後要改掉，
                                    style: theme.textTheme.bodyLarge),
                              ),
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  controller: _memberControllers[id],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  textAlign: TextAlign.end,
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
              ],
            ),
          ),

          // 3. 底部總結區
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border:
                  Border(top: BorderSide(color: colorScheme.outlineVariant)),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                    t.B07_PaymentMethod_Edit.total_label, widget.totalAmount,
                    isBold: true),
                const SizedBox(height: 8),
                if (_usePrepay)
                  _buildSummaryRow(
                      t.B07_PaymentMethod_Edit.total_prepay, _prepayAmount),
                if (_useAdvance)
                  _buildSummaryRow(t.B07_PaymentMethod_Edit.total_advance,
                      _currentAdvanceTotal),
                const Divider(),
                _buildSummaryRow(
                  _isValid
                      ? t.B07_PaymentMethod_Edit.status_balanced
                      : t.B07_PaymentMethod_Edit.status_remaining(
                          amount: NumberFormat("#,##0.##")
                              .format(_remaining.abs())),
                  _remaining,
                  hideAmount: true,
                  color: _isValid ? Colors.green : colorScheme.error,
                  isBold: true,
                  customValueText: _isValid ? "OK" : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildSummaryRow(String label, double amount,
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
          customValueText ?? NumberFormat("#,##0.##").format(amount),
          style: TextStyle(
              color: color, fontWeight: isBold ? FontWeight.bold : null),
        ),
      ],
    );
  }
}
