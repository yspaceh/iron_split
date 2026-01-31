import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b03_split_method_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class B02SplitExpenseEditBottomSheet extends StatefulWidget {
  final RecordDetail? detail;
  final List<Map<String, dynamic>> allMembers;
  final Map<String, double> defaultWeights;
  final CurrencyConstants selectedCurrency;
  final String parentTitle;
  final double availableAmount;
  final double exchangeRate;
  final CurrencyConstants baseCurrency;
  const B02SplitExpenseEditBottomSheet({
    super.key,
    this.detail,
    required this.allMembers,
    required this.defaultWeights,
    required this.selectedCurrency,
    required this.parentTitle,
    required this.availableAmount,
    this.exchangeRate = 1.0,
    required this.baseCurrency,
  });

  @override
  State<B02SplitExpenseEditBottomSheet> createState() =>
      _B02SplitExpenseEditBottomSheetState();
}

class _B02SplitExpenseEditBottomSheetState
    extends State<B02SplitExpenseEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _amountController;
  late TextEditingController _memoController;

  late String _splitMethod;
  late List<String> _splitMemberIds;
  late Map<String, double>? _splitDetails;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.detail?.name ?? '');
    _amountController =
        TextEditingController(text: widget.detail?.amount.toString() ?? '');
    _memoController = TextEditingController(text: widget.detail?.memo ?? '');

    _splitMethod = widget.detail?.splitMethod ?? 'even';
    _splitMemberIds = widget.detail?.splitMemberIds ??
        widget.allMembers.map((m) => m['id'] as String).toList();
    _splitDetails = widget.detail?.splitDetails;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _handleSplitConfig() async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    // Pass the current input amount to B03

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => B03SplitMethodEditBottomSheet(
        totalAmount: amount,
        selectedCurrency: widget.selectedCurrency,
        allMembers: widget.allMembers,
        defaultMemberWeights: widget.defaultWeights,
        initialSplitMethod: _splitMethod,
        initialMemberIds: _splitMemberIds,
        initialDetails: _splitDetails ?? {},
        exchangeRate: widget.exchangeRate,
        baseCurrency: widget.baseCurrency,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _splitMethod = result['splitMethod'];
        _splitMemberIds = List<String>.from(result['memberIds']);
        _splitDetails = Map<String, double>.from(result['details']);
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final newItem = RecordDetail(
        id: widget.detail?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        amount: amount,
        memo: _memoController.text,
        splitMethod: _splitMethod,
        splitMemberIds: _splitMemberIds,
        splitDetails: _splitDetails,
      );
      context.pop(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 這裡我們需要使用 Translations.of(context) 來取得 t
    final t = Translations.of(context);
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
          // 1. Top Action Bar (New)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(t.common.cancel,
                      style: const TextStyle(color: Colors.grey)),
                ),
                Text(t.B02_SplitExpense_Edit.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    if (widget.detail != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: colorScheme.error,
                        onPressed: () => context.pop('DELETE'),
                      ),
                    TextButton(
                      onPressed: _onSave,
                      child: Text(t.B02_SplitExpense_Edit.action_save,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 2. Context Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.parentTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "${widget.selectedCurrency.symbol} ${CurrencyConstants.formatAmount(widget.availableAmount, widget.selectedCurrency.code)}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // 3. Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: t.B02_SplitExpense_Edit.name_label,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) =>
                          v?.isEmpty == true ? t.common.required : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: t.B02_SplitExpense_Edit.amount_label,
                        prefixText: "${widget.selectedCurrency.symbol} ",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                          ? t.S15_Record_Edit.err_input_amount
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Split Configuration Button
                    InkWell(
                      onTap: _handleSplitConfig,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.call_split,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                t.B02_SplitExpense_Edit.split_button_prefix,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Avatar Stack
                            CommonAvatarStack(
                              allMembers: widget.allMembers,
                              targetMemberIds: _splitMemberIds,
                              radius: 12,
                              fontSize: 10,
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Memo Input (Exact Style from S15)
                    TextFormField(
                      controller: _memoController,
                      keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: t.B02_SplitExpense_Edit.hint_memo,
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
