import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_info_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/dialogs/d10_record_delete_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
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
        authRepo: context.read<AuthRepository>(),
        prefsService: context.read<PreferencesService>(),
      )..init(),
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
  late FocusNode _amountNode;
  late FocusNode _rateNode;
  late FocusNode _titleNode; // 新增：給品項名稱
  late FocusNode _memoNode; // 新增：給備註
  @override
  void initState() {
    super.initState();
    _amountNode = FocusNode();
    _rateNode = FocusNode();
    _titleNode = FocusNode();
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
    _rateNode.dispose();
    _titleNode.dispose();
    _memoNode.dispose();
    super.dispose();
  }

  Future<void> _onUpdateCurrency(S15RecordEditViewModel vm, String code) async {
    try {
      await vm.updateCurrency(code);
    } on AppErrorCodes catch (code) {
      if (!mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    } catch (e) {
      if (!mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
    }
  }

  Future<void> _onFetchExchangeRate(S15RecordEditViewModel vm) async {
    try {
      await vm.fetchExchangeRate();
    } on AppErrorCodes catch (code) {
      if (!mounted) return;
      // [攔截錯誤] 顯示 Toast
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    } catch (e) {
      if (!mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
    }
  }

  // Show B03
  Future<void> _onBaseSplitConfigTap(S15RecordEditViewModel vm) async {
    final result = await B03SplitMethodEditBottomSheet.show(
      context,
      totalAmount: vm.amountToSplit,
      selectedCurrency: vm.selectedCurrencyConstants,
      allMembers: vm.taskMembers,
      defaultMemberWeights: vm.memberDefaultWeights,
      initialSplitMethod: vm.baseSplitMethod,
      initialMemberIds: vm.baseMemberIds,
      initialDetails: vm.baseRawDetails,
      exchangeRate: vm.exchangeRateValue,
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
      for (var m in vm.taskMembers) (m.id): 1.0
    };

    final result = await B02SplitExpenseEditBottomSheet.show(
      context,
      detail: null,
      allMembers: vm.taskMembers,
      defaultWeights: defaultWeights,
      selectedCurrency: vm.selectedCurrencyConstants,
      parentTitle: vm.titleController.text,
      availableAmount: vm.baseRemainingAmount,
      exchangeRate: vm.exchangeRateValue,
      baseCurrency: vm.baseCurrency,
    );

    if (result != null) vm.addItem(result);
  }

  // Show B02 (Edit)
  Future<void> _onDetailEditTap(
      S15RecordEditViewModel vm, RecordDetail detail) async {
    // 🛠️ 修正點 3：明確轉型為 Map<String, double>
    final Map<String, double> defaultWeights = {
      for (var m in vm.taskMembers) (m.id): 1.0
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
    CommonInfoDialog.show(
      context,
      title: t.S15_Record_Edit.rate_dialog.title,
      content: t.S15_Record_Edit.rate_dialog.message,
    );
  }

  // Show B07
  Future<void> _onPaymentMethodTap(S15RecordEditViewModel vm) async {
    if (vm.totalAmount <= 0) {
      AppToast.showError(
        context,
        t.error.message.enter_first(key: t.S15_Record_Edit.label.amount),
      );
      return;
    }

    final result = await B07PaymentMethodEditBottomSheet.show(
      context,
      totalAmount: vm.totalAmount,
      poolBalancesByCurrency: vm.adjustedPoolBalances,
      selectedCurrency: vm.selectedCurrencyConstants,
      baseCurrency: vm.baseCurrency,
      members: vm.taskMembers,
      initialUsePrepay:
          vm.complexPaymentData?['usePrepay'] ?? (vm.payerType == 'prepay'),
      initialPrepayAmount: vm.complexPaymentData?['prepayAmount'] ??
          (vm.payerType == 'prepay' ? vm.totalAmount : 0.0),
      initialMemberAdvance: vm.getInitialMemberAdvance(),
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
    } on AppErrorCodes catch (code) {
      if (!mounted) return;
      final String msg = ErrorMapper.map(context, code: code);

      if (code == AppErrorCodes.saveFailed) {
        CommonInfoDialog.show(context,
            title: t.error.dialog.unknown.title, content: msg);
      } else {
        AppToast.showError(context, msg);
      }
    } catch (e) {
      if (!mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
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
        await vm.deleteRecord(t);
        if (!mounted) return;
        // A. 刪除成功
        AppToast.showSuccess(
            context, t.D10_RecordDelete_Confirm.deleted_success);

        context.pop();
      } on AppErrorCodes catch (code) {
        if (!mounted) return;

        final msg = ErrorMapper.map(context, code: code);

        if (code == AppErrorCodes.dataNotFound) {
          CommonInfoDialog.show(context,
              title: t.error.dialog.unknown.title, content: msg);
        } else {
          AppToast.showError(context, msg);
        }
      } catch (e) {
        if (!mounted) return;
        final msg = ErrorMapper.map(context, error: e.toString());
        AppToast.showError(context, msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S15RecordEditViewModel>();
    final title = vm.recordId == null
        ? t.S15_Record_Edit.title.add
        : t.S15_Record_Edit.title.edit;
    final leading = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => _onClose(vm));
    final actions = [
      if (vm.recordId != null)
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Theme.of(context).colorScheme.error,
          onPressed: () => _onDelete(vm),
        ),
    ];
    return CommonStateView(
      status: vm.initStatus,
      title: title,
      leading: leading,
      actions: actions,
      errorCode: vm.initErrorCode,
      child: AppKeyboardActionsWrapper(
        // 4. [新增] 把所有 Node 都註冊進去
        focusNodes: [_amountNode, _rateNode, _titleNode, _memoNode],
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            leading: leading,
            actions: actions,
          ),
          extendBody: true,
          bottomNavigationBar: StickyBottomActionBar(
            isSheetMode: false,
            children: [
              AppButton(
                text: t.common.buttons.save,
                type: AppButtonType.primary,
                icon: Icons.add,
                isLoading: vm.saveStatus == LoadStatus.loading,
                onPressed: () => _onSave(vm),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            selectedCurrencyConstants:
                                vm.selectedCurrencyConstants,
                            baseCurrency: vm.baseCurrency,
                            selectedCategoryId: vm.selectedCategoryId,
                            isRateLoading:
                                vm.rateLoadStatus == LoadStatus.loading,
                            poolBalancesByCurrency: vm.adjustedPoolBalances,
                            members: vm.taskMembers,
                            details: vm.details,
                            baseRemainingAmount: vm.baseRemainingAmount,
                            baseSplitMethod: vm.baseSplitMethod,
                            baseMemberIds: vm.baseMemberIds,
                            baseRawDetails: vm.baseRawDetails,
                            remainderDetail: vm.remainderDetail,
                            payerType: vm.payerType,
                            payersId: vm.payersId,
                            hasPaymentError: vm.hasPaymentError,
                            amountFocusNode: _amountNode,
                            rateFocusNode: _rateNode,
                            titleFocusNode: _titleNode,
                            memoFocusNode: _memoNode,
                            onPaymentMethodTap: () => _onPaymentMethodTap(vm),
                            onDateChanged: vm.updateDate,
                            onCategoryChanged: vm.updateCategory,
                            onCurrencyChanged: (code) =>
                                _onUpdateCurrency(vm, code),
                            onFetchExchangeRate: () => _onFetchExchangeRate(vm),
                            onShowRateInfo: () => _showRateInfoDialog(),
                            onBaseSplitConfigTap: () =>
                                _onBaseSplitConfigTap(vm),
                            onAddItemTap: () => _onAddItemTap(vm),
                            onDetailEditTap: (detail) =>
                                _onDetailEditTap(vm, detail),
                          )
                        : S15IncomeForm(
                            amountController: vm.amountController,
                            memoController: vm.memoController,
                            exchangeRateController: vm.exchangeRateController,
                            selectedDate: vm.selectedDate,
                            selectedCurrencyConstants:
                                vm.selectedCurrencyConstants,
                            baseCurrency: vm.baseCurrency,
                            isRateLoading:
                                vm.rateLoadStatus == LoadStatus.loading,
                            members: vm.taskMembers,
                            baseRemainingAmount: vm.totalAmount,
                            remainderDetail: vm.remainderDetail,
                            baseSplitMethod: vm.baseSplitMethod,
                            baseMemberIds: vm.baseMemberIds,
                            baseRawDetails: vm.baseRawDetails,
                            amountFocusNode: _amountNode,
                            rateFocusNode: _rateNode,
                            memoFocusNode: _memoNode,
                            onDateChanged: vm.updateDate,
                            onCurrencyChanged: (code) =>
                                _onUpdateCurrency(vm, code),
                            onFetchExchangeRate: () => _onFetchExchangeRate(vm),
                            onShowRateInfo: () => _showRateInfoDialog(),
                            onBaseSplitConfigTap: () =>
                                _onBaseSplitConfigTap(vm),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
