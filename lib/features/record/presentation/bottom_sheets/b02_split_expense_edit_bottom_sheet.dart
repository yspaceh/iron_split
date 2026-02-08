import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b03_split_method_edit_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
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

  String? _splitMethodError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.detail?.name ?? '');
    _amountController = TextEditingController(
        text: CurrencyConstants.formatAmount(
            widget.detail?.amount ?? 0, widget.selectedCurrency.code));
    _memoController = TextEditingController(text: widget.detail?.memo ?? '');

    _splitMethod =
        widget.detail?.splitMethod ?? SplitMethodConstant.defaultMethod;
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
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;

    // 2. 檢查金額是否為 0
    if (amount <= 0) {
      setState(() {
        _splitMethodError =
            t.error.message.empty(key: t.S15_Record_Edit.label.amount);
      });
      return;
    }

    // 3. 如果金額正常，清空之前的錯誤訊息
    setState(() {
      _splitMethodError = null;
    });

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
      final amountText = _amountController.text.replaceAll(',', '');
      final amount = double.parse(amountText);

      Map<String, double>? finalSplitDetails = _splitDetails;
      if (finalSplitDetails != null) {
        final sum = finalSplitDetails.values.fold(0.0, (p, c) => p + c);
        if ((sum - amount).abs() > 0.1) {
          finalSplitDetails = null; // 強制失效，回退到自動均分
          _splitMethod = SplitMethodConstant.defaultMethod;
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

    return CommonBottomSheet(
      title: t.B02_SplitExpense_Edit.title,
      actions: [
        if (widget.detail != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: colorScheme.error,
            onPressed: () => context.pop('DELETE'),
            tooltip: t.common.buttons.delete,
          ),
      ],
      bottomActionBar: StickyBottomActionBar.sheet(
        children: [
          AppButton(
            text: t.B02_SplitExpense_Edit.buttons.save,
            type: AppButtonType.primary,
            onPressed: _onSave,
          ),
        ],
      ),
      children: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8), // 減少上下間距
                child: SummaryRow(
                  label: widget.parentTitle.isNotEmpty
                      ? widget.parentTitle
                      : t.B02_SplitExpense_Edit.item_name_empty,
                  amount: widget.availableAmount,
                  currencyConstants: widget.selectedCurrency,
                  labelColor:
                      widget.parentTitle.isEmpty ? colorScheme.outline : null,
                  valueColor: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Divider(
                height: 1,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),

              // 2. Name
              AppTextField(
                controller: _nameController,
                fillColor: colorScheme.surfaceContainerLow,
                labelText: t.B02_SplitExpense_Edit.label.sub_item,
                hintText: t.B02_SplitExpense_Edit.placeholder.sub_item,
                validator: (v) =>
                    v?.isEmpty == true ? t.error.message.required : null,
              ),
              const SizedBox(height: 8),

              // 3. Amount
              TaskAmountInput(
                amountController: _amountController,
                fillColor: colorScheme.surfaceContainerLow,
                selectedCurrencyConstants: widget.selectedCurrency,
                isIncome: false,
                showCurrencyPicker: false,
                externalValidator: (val) {
                  if (val > widget.availableAmount) {
                    return t.error.message.amount_not_enough;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // 4. Split Config Button
              AppSelectField(
                text: SplitMethodConstant.getLabel(context, _splitMethod),
                onTap: _handleSplitConfig,
                fillColor: colorScheme.surfaceContainerLow,
                labelText: t.B02_SplitExpense_Edit.label.split_method,
                trailing: CommonAvatarStack(
                  allMembers: widget.allMembers,
                  targetMemberIds: _splitMemberIds,
                  radius: 12,
                  fontSize: 10,
                ),
                errorText: _splitMethodError,
              ),
              const SizedBox(height: 8),

              // 5. Memo
              TaskMemoInput(
                memoController: _memoController,
                fillColor: colorScheme.surfaceContainerLow,
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
