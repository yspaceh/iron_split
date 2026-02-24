import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/split_method_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar_stack.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_amount_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_memo_input.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b03_split_method_edit_bottom_sheet.dart';
import 'package:iron_split/features/record/presentation/viewmodels/b02_split_expense_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/summary_row.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class B02SplitExpenseEditBottomSheet extends StatelessWidget {
  final RecordDetail? detail;
  final List<TaskMember> allMembers;
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

  static Future<dynamic> show(
    BuildContext context, {
    RecordDetail? detail,
    required List<TaskMember> allMembers,
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B02SplitExpenseEditViewModel(
        authRepo: context.read<AuthRepository>(),
        allMembers: allMembers,
        selectedCurrency: selectedCurrency,
        initialDetail: detail,
      )..init(),
      child: _B02Content(
        parentTitle: parentTitle,
        availableAmount: availableAmount,
        exchangeRate: exchangeRate,
        baseCurrency: baseCurrency,
        defaultWeights: defaultWeights,
        isEditMode: detail != null,
      ),
    );
  }
}

class _B02Content extends StatefulWidget {
  final String parentTitle;
  final double availableAmount;
  final double exchangeRate;
  final CurrencyConstants baseCurrency;
  final Map<String, double> defaultWeights;
  final bool isEditMode;

  const _B02Content({
    required this.parentTitle,
    required this.availableAmount,
    required this.exchangeRate,
    required this.baseCurrency,
    required this.defaultWeights,
    required this.isEditMode,
  });

  @override
  State<_B02Content> createState() => _B02ContentState();
}

class _B02ContentState extends State<_B02Content> {
  final _formKey = GlobalKey<FormState>();

  late FocusNode _amountNode;
  late FocusNode _nameNode; // 新增：給品項名稱
  late FocusNode _memoNode; // 新增：給備註

  @override
  void initState() {
    super.initState();
    _amountNode = FocusNode();
    _nameNode = FocusNode();
    _memoNode = FocusNode();
    _memoNode.addListener(() {
      if (_memoNode.hasFocus) {
        // 延遲 100 毫秒，確保底層的 SizedBox(height: 400) 已經瞬間出現了
        Future.delayed(const Duration(milliseconds: 100), () {
          final memoContext = _memoNode.context;
          if (memoContext != null && memoContext.mounted) {
            Scrollable.ensureVisible(
              memoContext,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              // alignment 0.2 代表將備註欄推到「從螢幕上方往下數 20%」的位置
              // 這樣絕對不可能被下方的鍵盤遮到！
              alignment: 0.2,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _amountNode.dispose();
    _nameNode.dispose();
    _memoNode.dispose();
    super.dispose();
  }

  Future<void> _showSplitMethodBottomSheet(BuildContext context,
      B02SplitExpenseEditViewModel vm, Translations t) async {
    final amountText = vm.amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText) ?? 0.0;

    // 2. 檢查金額是否為 0
    if (amount <= 0) {
      AppToast.showError(
          context, t.error.message.empty(key: t.common.label.amount));
      return;
    }

    final result = await B03SplitMethodEditBottomSheet.show(
      context,
      totalAmount: amount,
      selectedCurrency: vm.selectedCurrency,
      allMembers: vm.allMembers,
      defaultMemberWeights: widget.defaultWeights,
      initialSplitMethod: vm.splitMethod,
      initialMemberIds: vm.splitMemberIds,
      initialDetails: vm.splitDetails ?? {},
      exchangeRate: widget.exchangeRate,
      baseCurrency: widget.baseCurrency,
    );
    if (result is Map<String, dynamic> && context.mounted) {
      _handleSplitConfig(context, vm, result);
    }
  }

  Future<void> _handleSplitConfig(BuildContext context,
      B02SplitExpenseEditViewModel vm, Map<String, dynamic> details) async {
    vm.updateSplitConfig(
      details,
    );
  }

  void _handleSave(BuildContext context, B02SplitExpenseEditViewModel vm) {
    if (_formKey.currentState!.validate()) {
      final newItem = vm.prepareResult();
      context.pop(newItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<B02SplitExpenseEditViewModel>();
    final title = t.B02_SplitExpense_Edit.title;
    final actions = [
      if (widget.isEditMode)
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: colorScheme.error,
          onPressed: () => context.pop('DELETE'),
          tooltip: t.common.buttons.delete,
        ),
    ];

    return AppKeyboardActionsWrapper(
      focusNodes: [_amountNode, _nameNode, _memoNode],
      child: CommonStateView(
        status: vm.initStatus,
        title: title,
        actions: actions,
        errorCode: vm.initErrorCode,
        isSheetMode: true,
        child: CommonBottomSheet(
          title: title,
          actions: actions,
          bottomActionBar: StickyBottomActionBar.sheet(
            children: [
              AppButton(
                text: t.B02_SplitExpense_Edit.buttons.confirm_split,
                type: AppButtonType.primary,
                onPressed: () => _handleSave(context, vm),
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
                      currencyConstants: vm.selectedCurrency,
                      labelColor: widget.parentTitle.isEmpty
                          ? colorScheme.outline
                          : null,
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
                    controller: vm.nameController,
                    focusNode: _nameNode,
                    fillColor: colorScheme.surfaceContainerLow,
                    labelText: t.common.label.sub_item,
                    hintText: t.B02_SplitExpense_Edit.hint.sub_item,
                    validator: (v) =>
                        v?.isEmpty == true ? t.error.message.required : null,
                  ),
                  const SizedBox(height: 8),

                  // 3. Amount
                  TaskAmountInput(
                    amountController: vm.amountController,
                    focusNode: _amountNode,
                    fillColor: colorScheme.surfaceContainerLow,
                    selectedCurrencyConstants: vm.selectedCurrency,
                    isPrepay: false,
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
                    text: SplitMethodConstant.getLabel(
                        context, vm.splitMethod, t),
                    onTap: () => _showSplitMethodBottomSheet(context, vm, t),
                    fillColor: colorScheme.surfaceContainerLow,
                    labelText: t.common.label.split_method,
                    trailing: CommonAvatarStack(
                      allMembers: vm.allMembers,
                      targetMemberIds: vm.splitMemberIds,
                      radius: 12,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 5. Memo
                  TaskMemoInput(
                    memoController: vm.memoController,
                    focusNode: _memoNode,
                    fillColor: colorScheme.surfaceContainerLow,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
