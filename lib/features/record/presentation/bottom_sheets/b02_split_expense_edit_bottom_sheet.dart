import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
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

  // ✅ 加入 helper 讓外部呼叫更方便且設定統一
  static Future<dynamic> show(
    BuildContext context, {
    RecordDetail? detail,
    required List<Map<String, dynamic>> allMembers,
    required Map<String, double> defaultWeights,
    required CurrencyConstants selectedCurrency,
    required String parentTitle,
    required double availableAmount,
    double exchangeRate = 1.0,
    required CurrencyConstants baseCurrency,
  }) {
    return showModalBottomSheet<RecordDetail>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (context) => B02SplitExpenseEditBottomSheet(
        detail: detail,
        allMembers: allMembers,
        defaultWeights: defaultWeights,
        selectedCurrency: selectedCurrency,
        parentTitle: parentTitle,
        availableAmount: availableAmount,
        exchangeRate: exchangeRate,
        baseCurrency: baseCurrency,
      ),
    );
  }

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

    _splitMethod =
        widget.detail?.splitMethod ?? SplitMethodConstants.defaultMethod;
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

    // 防呆：金額為 0 不能分帳
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                Translations.of(context).S15_Record_Edit.err_input_amount)),
      );
      return;
    }

    final result = await B03SplitMethodEditBottomSheet.show(
      context,
      totalAmount: amount,
      selectedCurrency: widget.selectedCurrency,
      allMembers: widget.allMembers,
      defaultMemberWeights: widget.defaultWeights,
      initialSplitMethod: _splitMethod,
      initialMemberIds: _splitMemberIds,
      initialDetails: _splitDetails ?? {},
      exchangeRate: widget.exchangeRate,
      baseCurrency: widget.baseCurrency,
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
      // [最後防線] 如果 splitDetails 存在，檢查總和是否吻合
      // 如果不吻合 (且不是比例模式)，理論上應該要重算，但這裡為了簡單，
      // 如果發現金額變了但 splitDetails 沒清乾淨，這裡強制清空讓 S15 處理
      Map<String, double>? finalSplitDetails = _splitDetails;
      if (finalSplitDetails != null) {
        final sum = finalSplitDetails.values.fold(0.0, (p, c) => p + c);
        if ((sum - amount).abs() > 0.1) {
          finalSplitDetails = null; // 強制失效，回退到自動均分
          _splitMethod = SplitMethodConstants.defaultMethod;
        }
      }
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
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // ✅ 使用 CommonBottomSheet
    return CommonBottomSheet(
      title: t.B02_SplitExpense_Edit.title,

      // ✅ 右上角放刪除按鈕 (如果有 detail)
      actions: [
        if (widget.detail != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: colorScheme.error,
            onPressed: () => context.pop('DELETE'),
            tooltip: t.common.buttons.delete,
          ),
      ],

      // ✅ 底部按鈕：使用 .sheet 樣式 (內縮分隔線)
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          AppButton(
            text: t.B02_SplitExpense_Edit.buttons.save,
            type: AppButtonType.primary,
            onPressed: _onSave,
          ),
        ],
      ),

      // ✅ 內容區
      children: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),

              // 1. Context Header (Parent Title + Available Amount)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 24),
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

              // 2. Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t.B02_SplitExpense_Edit.name_label,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) => v?.isEmpty == true ? t.common.required : null,
              ),
              const SizedBox(height: 16),

              // 3. Amount
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
                textInputAction: TextInputAction.done,
                validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0
                    ? t.S15_Record_Edit.err_input_amount
                    : null,
              ),
              const SizedBox(height: 16),

              // 4. Split Config Button
              InkWell(
                onTap: _handleSplitConfig,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

              // 5. Memo
              TextFormField(
                controller: _memoController,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: 4, // 允許稍微長一點
                decoration: InputDecoration(
                  labelText: t.B02_SplitExpense_Edit.hint_memo,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              // 底部安全留白
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
