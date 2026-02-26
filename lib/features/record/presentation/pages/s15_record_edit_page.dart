import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
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
import 'package:iron_split/features/record/presentation/views/s15_prepay_form.dart';
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

  Future<void> _handleUpdateCurrency(
      BuildContext context, S15RecordEditViewModel vm, String code) async {
    try {
      await vm.updateCurrency(code);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    } catch (e) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleFetchExchangeRate(
      BuildContext context, S15RecordEditViewModel vm) async {
    try {
      await vm.fetchExchangeRate();
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    } catch (e) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
    }
  }

  // Show B03
  Future<void> _handleBaseSplitConfig(
      BuildContext context, S15RecordEditViewModel vm) async {
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

  Future<void> _showSplitExpenseEditBottomSheet(BuildContext context,
      S15RecordEditViewModel vm, RecordDetail? detail) async {
    if (vm.baseRemainingAmount <= 0) {
      AppToast.showError(
          context, t.error.message.enter_first(key: t.common.label.amount));
      return;
    }

    final rate = detail == null
        ? vm.exchangeRateValue
        : double.tryParse(vm.exchangeRateController.text) ?? 1.0;

    final availableAmount = detail == null
        ? vm.baseRemainingAmount
        : vm.baseRemainingAmount + detail.amount;

    final Map<String, double> defaultWeights = {
      for (var m in vm.taskMembers) (m.id): 1.0
    };

    final result = await B02SplitExpenseEditBottomSheet.show(
      context,
      detail: detail,
      allMembers: vm.taskMembers,
      defaultWeights: defaultWeights,
      selectedCurrency: vm.selectedCurrencyConstants,
      parentTitle: vm.titleController.text,
      availableAmount: availableAmount,
      exchangeRate: rate,
      baseCurrency: vm.baseCurrency,
    );
    if (!context.mounted) return;
    if (detail == null) {
      if (result is RecordDetail) {
        _handleAddItem(vm, result);
      }
    } else {
      if (result == 'DELETE') {
        _handleDeleteItem(vm, detail.id);
      } else if (result is RecordDetail) {
        _handleUpdateItem(vm, result);
      }
    }
  }

  void _handleAddItem(S15RecordEditViewModel vm, RecordDetail item) {
    vm.addItem(item);
  }

  void _handleUpdateItem(S15RecordEditViewModel vm, RecordDetail item) {
    vm.updateItem(item);
  }

  void _handleDeleteItem(S15RecordEditViewModel vm, String itemId) {
    vm.deleteItem(itemId);
  }

  void _showRateInfoDialog(BuildContext context, Translations t) {
    CommonInfoDialog.show(
      context,
      title: t.S15_Record_Edit.rate_dialog.title,
      content: t.S15_Record_Edit.rate_dialog.content,
    );
  }

  void _handleSwitchSegmentedIndex(S15RecordEditViewModel vm, int index) {
    vm.setSegmentedIndex(index);
  }

  // Show B07
  Future<void> _handleUpdatePaymentMethod(
      BuildContext context, S15RecordEditViewModel vm) async {
    if (vm.totalAmount <= 0) {
      AppToast.showError(
          context, t.error.message.enter_first(key: t.common.label.amount));
      return;
    }

    final result = await B07PaymentMethodEditBottomSheet.show(
      context,
      totalAmount: vm.totalAmount,
      poolBalancesByCurrency: vm.adjustedPoolBalances,
      selectedCurrency: vm.selectedCurrencyConstants,
      baseCurrency: vm.baseCurrency,
      members: vm.taskMembers,
      initialUsePrepay: vm.complexPaymentData?['usePrepay'] ??
          (vm.payerType == PayerType.prepay),
      initialPrepayAmount: vm.complexPaymentData?['prepayAmount'] ??
          (vm.payerType == PayerType.prepay ? vm.totalAmount : 0.0),
      initialMemberAdvance: vm.getInitialMemberAdvance(),
    );

    if (result != null) vm.updatePaymentMethod(result);
  }

  Future<void> _handleSave(
      BuildContext context, S15RecordEditViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    final t = Translations.of(context);

    if (vm.segmentedIndex == 0 && vm.hasPaymentError) {
      AppToast.showError(context, t.B07_PaymentMethod_Edit.status.not_enough);
      return;
    }

    try {
      await vm.saveRecord(t);
      if (!context.mounted) return;
      context.pop();
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final String msg = ErrorMapper.map(context, code: code);

      if (code == AppErrorCodes.saveFailed) {
        CommonInfoDialog.show(context,
            title: t.error.dialog.unknown.title, content: msg);
      } else {
        AppToast.showError(context, msg);
      }
    } catch (e) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, error: e.toString());
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleClose(
      BuildContext context, S15RecordEditViewModel vm) async {
    if (!vm.hasUnsavedChanges()) {
      context.pop();
      return;
    }
    final confirm = await D04CommonUnsavedConfirmDialog.show<bool>(context);

    if (confirm == true && context.mounted) context.pop();
  }

  Future<void> _handleDelete(
      BuildContext context, S15RecordEditViewModel vm, Translations t) async {
    final confirm = await D10RecordDeleteConfirmDialog.show<bool>(context,
        recordTitle: vm.titleController.text,
        currency: vm.selectedCurrencyConstants,
        amount: vm.totalAmount);

    if (confirm == true && context.mounted) {
      try {
        await vm.deleteRecord(t);
        if (!context.mounted) return;
        // A. 刪除成功
        AppToast.showSuccess(context, t.success.deleted);

        context.pop();
      } on AppErrorCodes catch (code) {
        if (!context.mounted) return;

        final msg = ErrorMapper.map(context, code: code);

        if (code == AppErrorCodes.dataNotFound) {
          CommonInfoDialog.show(context,
              title: t.error.dialog.unknown.title, content: msg);
        } else {
          AppToast.showError(context, msg);
        }
      } catch (e) {
        if (!context.mounted) return;
        final msg = ErrorMapper.map(context, error: e.toString());
        AppToast.showError(context, msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S15RecordEditViewModel>();
    final displayStatus = context.watch<DisplayState>();
    final isEnlarged = displayStatus.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = vm.recordId == null
        ? t.S15_Record_Edit.title.add
        : t.S15_Record_Edit.title.edit;
    final leading = IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => _handleClose(context, vm));
    final actions = [
      if (vm.recordId != null)
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: theme.colorScheme.error,
          onPressed: () => _handleDelete(context, vm, t),
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
                isLoading: vm.saveStatus == LoadStatus.loading,
                onPressed: () => _handleSave(context, vm),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalMargin, vertical: 8),
                  // [修正] 改用 CustomSlidingSegment
                  child: CustomSlidingSegment<int>(
                    selectedValue: vm.segmentedIndex,
                    onValueChanged: (val) =>
                        _handleSwitchSegmentedIndex(vm, val),
                    segments: {
                      0: t.S15_Record_Edit.tab.expense,
                      1: t.S15_Record_Edit.tab.prepay,
                    },
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: vm.segmentedIndex == 0
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
                            onPaymentMethodTap: () =>
                                _handleUpdatePaymentMethod(context, vm),
                            onDateChanged: vm.updateDate,
                            onCategoryChanged: vm.updateCategory,
                            onCurrencyChanged: (code) =>
                                _handleUpdateCurrency(context, vm, code),
                            onFetchExchangeRate: () =>
                                _handleFetchExchangeRate(context, vm),
                            onShowRateInfo: () =>
                                _showRateInfoDialog(context, t),
                            onBaseSplitConfigTap: () =>
                                _handleBaseSplitConfig(context, vm),
                            onAddItemTap: () =>
                                _showSplitExpenseEditBottomSheet(
                                    context, vm, null),
                            onDetailEditTap: (detail) =>
                                _showSplitExpenseEditBottomSheet(
                                    context, vm, detail),
                          )
                        : S15PrepayForm(
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
                                _handleUpdateCurrency(context, vm, code),
                            onFetchExchangeRate: () =>
                                _handleFetchExchangeRate(context, vm),
                            onShowRateInfo: () =>
                                _showRateInfoDialog(context, t),
                            onBaseSplitConfigTap: () =>
                                _handleBaseSplitConfig(context, vm),
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
