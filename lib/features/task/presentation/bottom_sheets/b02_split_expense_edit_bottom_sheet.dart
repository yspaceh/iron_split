import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: B02_SplitExpense.Edit
class B02SplitExpenseEditBottomSheet extends StatefulWidget {
  final double totalAmount;
  final String splitMethod; // 'exact' or 'percent'
  final Map<String, double> initialDetails; // {uid: amount_or_percent}
  final List<String> memberIds; // 參與分攤的成員 ID 列表 (需從 S15 傳入)

  const B02SplitExpenseEditBottomSheet({
    super.key,
    required this.totalAmount,
    required this.splitMethod,
    required this.initialDetails,
    required this.memberIds,
  });

  @override
  State<B02SplitExpenseEditBottomSheet> createState() =>
      _B02SplitExpenseEditBottomSheetState();
}

class _B02SplitExpenseEditBottomSheetState
    extends State<B02SplitExpenseEditBottomSheet> {
  late Map<String, TextEditingController> _controllers;
  double _currentTotal = 0.0;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    for (var uid in widget.memberIds) {
      final val = widget.initialDetails[uid] ?? 0.0;
      // 若是 0 則顯示空字串方便輸入
      _controllers[uid] =
          TextEditingController(text: val == 0 ? '' : _formatVal(val));
      _controllers[uid]!.addListener(_validate);
    }
    _validate();
  }

  @override
  void dispose() {
    for (var c in _controllers.values) c.dispose();
    super.dispose();
  }

  String _formatVal(double val) {
    return val
        .toStringAsFixed(widget.splitMethod == 'percent' ? 0 : 1)
        .replaceAll(RegExp(r'\.0$'), '');
  }

  void _validate() {
    double sum = 0.0;
    for (var uid in widget.memberIds) {
      final val = double.tryParse(_controllers[uid]!.text) ?? 0.0;
      sum += val;
    }

    setState(() {
      _currentTotal = sum;
      if (widget.splitMethod == 'percent') {
        _isValid = (sum - 100).abs() < 0.1; // 容許些微誤差
      } else {
        _isValid = (sum - widget.totalAmount).abs() < 0.1;
      }
    });
  }

  void _onSave() {
    if (!_isValid) return;
    final Map<String, double> result = {};
    for (var uid in widget.memberIds) {
      result[uid] = double.tryParse(_controllers[uid]!.text) ?? 0.0;
    }
    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPercent = widget.splitMethod == 'percent';
    final target = isPercent ? 100.0 : widget.totalAmount;
    final remainder = target - _currentTotal;

    // 狀態顏色：綠色代表剛好，紅色代表超支或不足
    final statusColor = _isValid ? colorScheme.primary : colorScheme.error;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85, // 佔據 85% 高度
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(t.common.cancel),
                ),
                Text(
                  t.B02_SplitExpense_Edit.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _isValid ? _onSave : null,
                  child: Text(
                    t.B02_SplitExpense_Edit.action_save,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isValid ? colorScheme.primary : Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Status Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            color: statusColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.B02_SplitExpense_Edit.label_total(
                      current: _formatVal(_currentTotal),
                      target: _formatVal(target)),
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
                Text(
                  t.B02_SplitExpense_Edit.label_remainder(
                      amount: _formatVal(remainder)),
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Member List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: widget.memberIds.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final uid = widget.memberIds[index];
                return Row(
                  children: [
                    // Avatar (Mock)
                    CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(uid[0].toUpperCase()),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Member $uid", // 這裡應顯示真實名稱
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    // Input Field
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _controllers[uid],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textAlign: TextAlign.end,
                        decoration: InputDecoration(
                          hintText: isPercent
                              ? t.B02_SplitExpense_Edit.hint_percent
                              : t.B02_SplitExpense_Edit.hint_amount,
                          suffixText: isPercent ? '%' : '',
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
