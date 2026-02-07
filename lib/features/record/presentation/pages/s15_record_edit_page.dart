import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_error_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/record/presentation/viewmodels/s15_record_edit_vm.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/models/record_model.dart';
import 'package:iron_split/features/record/presentation/views/s15_expense_form.dart';
import 'package:iron_split/features/record/presentation/views/s15_income_form.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b02_split_expense_edit_bottom_sheet.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b03_split_method_edit_bottom_sheet.dart';
import 'package:iron_split/features/record/presentation/bottom_sheets/b07_payment_method_edit_bottom_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class S15RecordEditPage extends StatelessWidget {
  final String taskId;
  final String? recordId;
  final RecordModel? record;
  final CurrencyConstants baseCurrency;
  final Map<String, double> poolBalancesByCurrency;
  final DateTime? initialDate;

  const S15RecordEditPage({
    super.key,
    required this.taskId,
    this.recordId,
    this.record,
    this.baseCurrency = CurrencyConstants.defaultCurrencyConstants,
    this.poolBalancesByCurrency = const {},
    this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S15RecordEditViewModel(
        taskId: taskId,
        recordId: recordId,
        record: record,
        baseCurrency: baseCurrency,
        poolBalancesByCurrency: poolBalancesByCurrency,
        initialDate: initialDate,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
      ),
      child: const _S15Content(),
    );
  }
}

class _S15Content extends StatefulWidget {
  const _S15Content();

  @override
  State<_S15Content> createState() => _S15ContentState();
}

class _S15ContentState extends State<_S15Content> {
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<S15RecordEditViewModel>().initCurrency();
  }

  // Show B03
  Future<void> _onBaseSplitConfigTap(S15RecordEditViewModel vm) async {
    final amountToSplit =
        vm.recordTypeIndex == 1 ? vm.totalAmount : vm.baseRemainingAmount;

    final rate = double.tryParse(vm.exchangeRateController.text) ?? 1.0;

    final result = await B03SplitMethodEditBottomSheet.show(
      context,
      totalAmount: amountToSplit,
      selectedCurrency: vm.selectedCurrencyConstants,
      allMembers: vm.taskMembers,
      defaultMemberWeights: vm.memberDefaultWeights,
      initialSplitMethod: vm.baseSplitMethod,
      initialMemberIds: vm.baseMemberIds,
      initialDetails: vm.baseRawDetails,
      exchangeRate: rate,
      baseCurrency: vm.baseCurrency,
    );

    if (result != null) vm.updateBaseSplit(result);
  }

  // Show B02 (Create)
  Future<void> _onAddItemTap(S15RecordEditViewModel vm) async {
    if (vm.baseRemainingAmount <= 0) {
      AppToast.showError(
        context,
        t.error.message.enter_first(key: t.S15_Record_Edit.label.amount),
      );
      return;
    }

    // 🛠️ 修正點 2：明確轉型為 Map<String, double>
    final Map<String, double> defaultWeights = {
      for (var m in vm.taskMembers) (m['id'] as String): 1.0
    };

    final rate = double.tryParse(vm.exchangeRateController.text) ?? 1.0;

    final result = await B02SplitExpenseEditBottomSheet.show(
      context,
      detail: null,
      allMembers: vm.taskMembers,
      defaultWeights: defaultWeights,
      selectedCurrency: vm.selectedCurrencyConstants,
      parentTitle: vm.titleController.text,
      availableAmount: vm.baseRemainingAmount,
      exchangeRate: rate,
      baseCurrency: vm.baseCurrency,
    );

    if (result != null) vm.addItem(result);
  }

  // Show B02 (Edit)
  Future<void> _onDetailEditTap(
      S15RecordEditViewModel vm, RecordDetail detail) async {
    // 🛠️ 修正點 3：明確轉型為 Map<String, double>
    final Map<String, double> defaultWeights = {
      for (var m in vm.taskMembers) (m['id'] as String): 1.0
    };

    final rate = double.tryParse(vm.exchangeRateController.text) ?? 1.0;

    final result = await B02SplitExpenseEditBottomSheet.show(
      context,
      detail: detail,
      allMembers: vm.taskMembers,
      defaultWeights: defaultWeights,
      selectedCurrency: vm.selectedCurrencyConstants,
      parentTitle: vm.titleController.text,
      availableAmount: vm.baseRemainingAmount + detail.amount,
      exchangeRate: rate,
      baseCurrency: vm.baseCurrency,
    );

    if (result == 'DELETE') {
      vm.deleteItem(detail.id);
    } else if (result is RecordDetail) {
      vm.updateItem(result);
    }
  }

  void _showRateInfoDialog() {
    final t = Translations.of(context);
    CommonAlertDialog.show(
      context,
      title: t.S15_Record_Edit.rate_dialog.title,
      content: Text(t.S15_Record_Edit.rate_dialog.message),
      actions: [
        AppButton(
          text: t.common.buttons.close,
          type: AppButtonType.primary,
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  // Show B07
  Future<void> _onPaymentMethodTap(S15RecordEditViewModel vm) async {
    if (vm.totalAmount <= 0) {
      // TODO: 建議補上 SnackBar 提示
      return;
    }

    // 🛠️ 修正點 4：恢復完整的初始化邏輯，不簡化功能
    final Map<String, double> initialMemberAdvance =
        vm.complexPaymentData?['memberAdvance'] != null
            ? Map<String, double>.from(vm.complexPaymentData!['memberAdvance'])
            : (vm.payerType == 'member' ? {vm.payerId: vm.totalAmount} : {});

    final result = await B07PaymentMethodEditBottomSheet.show(
      context,
      totalAmount: vm.totalAmount,
      poolBalancesByCurrency: vm.poolBalancesByCurrency,
      selectedCurrency: vm.selectedCurrencyConstants,
      baseCurrency: vm.baseCurrency,
      members: vm.taskMembers,
      initialUsePrepay:
          vm.complexPaymentData?['usePrepay'] ?? (vm.payerType == 'prepay'),
      initialPrepayAmount: vm.complexPaymentData?['prepayAmount'] ??
          (vm.payerType == 'prepay' ? vm.totalAmount : 0.0),
      initialMemberAdvance: initialMemberAdvance,
    );

    if (result != null) vm.updatePaymentMethod(result);
  }

  Future<void> _onSave(S15RecordEditViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    final t = Translations.of(context);

    if (vm.recordTypeIndex == 0 && vm.hasPaymentError) {
      AppToast.showError(
          context, t.B07_PaymentMethod_Edit.err_balance_not_enough);
      return;
    }

    try {
      await vm.saveRecord(t);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        final msg = ErrorMapper.map(context, e);
        AppToast.showError(context, msg);
      }
    }
  }

  Future<void> _onClose(S15RecordEditViewModel vm) async {
    if (!vm.hasUnsavedChanges()) {
      context.pop();
      return;
    }
    final confirm = await D04CommonUnsavedConfirmDialog.show<bool>(context);

    if (confirm == true && mounted) context.pop();
  }

  Future<void> _onDelete(S15RecordEditViewModel vm) async {
    final t = Translations.of(context);

    final confirm = await D10RecordDeleteConfirmDialog.show<bool>(context,
        recordTitle: vm.titleController.text,
        currency: vm.selectedCurrencyConstants,
        amount: vm.totalAmount);

    if (confirm == true && context.mounted) {
      try {
        final success = await vm.deleteRecord(t);
        if (success) {
          // A. 刪除成功
          AppToast.showSuccess(
              context, t.D10_RecordDelete_Confirm.deleted_success);

          if (context.mounted) context.pop();
        } else {
          // B. 刪除失敗 (因為被使用) -> 彈出錯誤 Dialog
          if (context.mounted) {
            CommonErrorDialog.show(context,
                title: t.error.dialog.delete_failed.title,
                content: t.error.dialog.delete_failed.message);
          }
        }
      } catch (e) {
        if (!context.mounted) return;

        final eStr = e.toString();
        final friendlyMessage = ErrorMapper.map(context, e);

        if (eStr.contains(AppErrorCodes.recordNotFound)) {
          CommonErrorDialog.show(context,
              title: t.error.dialog.unknown.title, content: friendlyMessage);
        } else {
          AppToast.showError(context, friendlyMessage);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S15RecordEditViewModel>();

    if (vm.isLoadingTaskData) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.recordId == null
            ? t.S15_Record_Edit.title.add
            : t.S15_Record_Edit.title.edit),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => _onClose(vm)),
        actions: [
          if (vm.recordId != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Theme.of(context).colorScheme.error,
              onPressed: () => _onDelete(vm),
            ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: StickyBottomActionBar(
        isSheetMode: false,
        children: [
          AppButton(
            text: t.common.buttons.save,
            type: AppButtonType.primary,
            icon: Icons.add,
            isLoading: vm.isSaving,
            onPressed: vm.isSaving ? null : () => _onSave(vm),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            // [修正] 改用 CustomSlidingSegment
            child: CustomSlidingSegment<int>(
              selectedValue: vm.recordTypeIndex,
              onValueChanged: (val) => vm.setRecordType(val),
              segments: {
                0: t.S15_Record_Edit.tab.expense,
                1: t.S15_Record_Edit.tab.income,
              },
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: vm.recordTypeIndex == 0
                  ? S15ExpenseForm(
                      amountController: vm.amountController,
                      titleController: vm.titleController,
                      memoController: vm.memoController,
                      exchangeRateController: vm.exchangeRateController,
                      selectedDate: vm.selectedDate,
                      selectedCurrencyConstants: vm.selectedCurrencyConstants,
                      baseCurrency: vm.baseCurrency,
                      selectedCategoryId: vm.selectedCategoryId,
                      isRateLoading: vm.isRateLoading,
                      poolBalancesByCurrency: vm.poolBalancesByCurrency,
                      members: vm.taskMembers,
                      details: vm.details,
                      baseRemainingAmount: vm.baseRemainingAmount,
                      baseSplitMethod: vm.baseSplitMethod,
                      baseMemberIds: vm.baseMemberIds,
                      baseRawDetails: vm.baseRawDetails,
                      totalRemainder: vm.calculatedTotalRemainder,
                      payerType: vm.payerType,
                      payerId: vm.payerId,
                      hasPaymentError: vm.hasPaymentError,
                      onPaymentMethodTap: () => _onPaymentMethodTap(vm),
                      onDateChanged: vm.updateDate,
                      onCategoryChanged: vm.updateCategory,
                      onCurrencyChanged: vm.updateCurrency,
                      onFetchExchangeRate: vm.fetchExchangeRate,
                      onShowRateInfo: () => _showRateInfoDialog(),
                      onBaseSplitConfigTap: () => _onBaseSplitConfigTap(vm),
                      onAddItemTap: () => _onAddItemTap(vm),
                      onDetailEditTap: (detail) => _onDetailEditTap(vm, detail),
                    )
                  : S15IncomeForm(
                      amountController: vm.amountController,
                      memoController: vm.memoController,
                      exchangeRateController: vm.exchangeRateController,
                      selectedDate: vm.selectedDate,
                      selectedCurrencyConstants: vm.selectedCurrencyConstants,
                      baseCurrency: vm.baseCurrency,
                      isRateLoading: vm.isRateLoading,
                      members: vm.taskMembers,
                      baseRemainingAmount: vm.totalAmount,
                      totalRemainder: vm.calculatedTotalRemainder,
                      baseSplitMethod: vm.baseSplitMethod,
                      baseMemberIds: vm.baseMemberIds,
                      baseRawDetails: vm.baseRawDetails,
                      onDateChanged: vm.updateDate,
                      onCurrencyChanged: vm.updateCurrency,
                      onFetchExchangeRate: vm.fetchExchangeRate,
                      onShowRateInfo: () => _showRateInfoDialog(),
                      onBaseSplitConfigTap: () => _onBaseSplitConfigTap(vm),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
