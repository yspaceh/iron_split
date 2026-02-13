import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/nav_title.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/presentation/bottom_sheets/b01_balance_rule_edit_bottom_sheet.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s14_task_settings_vm.dart';
import 'package:iron_split/features/task/presentation/dialogs/d09_task_settings_currency_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_remainder_rule_input.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S14_Task.Settings
class S14TaskSettingsPage extends StatelessWidget {
  final String taskId;
  const S14TaskSettingsPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S14TaskSettingsViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        authRepo: context.read<AuthRepository>(),
      )..init(),
      child: const _S14Content(),
    );
  }
}

class _S14Content extends StatefulWidget {
  const _S14Content();

  @override
  State<_S14Content> createState() => _S14ContentState();
}

class _S14ContentState extends State<_S14Content> {
  final FocusNode _nameFocusNode = FocusNode();
  late S14TaskSettingsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<S14TaskSettingsViewModel>();
    _vm.addListener(_onStateChanged);
    // Auto-save Name when focus is lost
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _vm.updateName();
      }
    });

    // 監聽未登入狀態並自動跳轉
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onStateChanged();
    });
  }

  void _onStateChanged() {
    if (!mounted) return;
    // 處理自動導航 (如未登入)
    if (_vm.initErrorCode == AppErrorCodes.unauthorized) {
      context.goNamed('S00');
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  Future<void> _onCurrencyChange(BuildContext context,
      S14TaskSettingsViewModel vm, CurrencyConstants selectedOption) async {
    // 髒檢查
    if (selectedOption.code == vm.currency?.code) return;

    // 等待 BottomSheet 關閉動畫
    await Future.delayed(const Duration(milliseconds: 300));
    if (!context.mounted) return;

    // 呼叫 D09 Dialog
    final bool? success = await showDialog<bool>(
      context: context,
      builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
        taskId: vm.taskId,
        newCurrency: selectedOption,
      ),
    );

    // 成功後更新 VM 狀態
    if (success == true && mounted) {
      vm.updateCurrency(selectedOption);
    }
  }

  Future<void> _onRemainderRuleChange(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    // 1. 準備成員資料 (Map 轉 List)

    // 2. 呼叫 B01
    final result = await B01BalanceRuleEditBottomSheet.show(context,
        initialRule: vm.remainderRule,
        initialMemberId: vm.remainderAbsorberId,
        members: vm.membersList,
        currentRemainder: vm.currentRemainder, // 從 VM 拿
        baseCurrency: vm.currency!);

    // 3. 處理回傳
    if (result != null && mounted) {
      await vm.updateRemainderRule(result['rule'], result['memberId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S14TaskSettingsViewModel>();
    final title = t.S14_Task_Settings.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      onErrorAction: () => vm.init(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              SectionWrapper(
                  title: t.S14_Task_Settings.section.task_name,
                  children: [
                    TaskNameInput(
                      controller: vm.nameController,
                      label: t.S16_TaskCreate_Edit.label.name,
                      hint: t.S16_TaskCreate_Edit.hint.name,
                      maxLength: 20,
                    ),
                  ]),
              SectionWrapper(
                  title: t.S14_Task_Settings.section.task_period,
                  children: [
                    if (vm.startDate != null && vm.endDate != null) ...[
                      TaskDateInput(
                          label: t.S16_TaskCreate_Edit.label.start_date,
                          date: vm.startDate!,
                          onDateChanged: (val) {
                            try {
                              vm.updateDateRange(val, vm.endDate!);
                            } on AppErrorCodes catch (code) {
                              final msg = ErrorMapper.map(context, code: code);
                              AppToast.showError(context, msg);
                            }
                          }),
                      const SizedBox(height: 8),
                      TaskDateInput(
                        label: t.S16_TaskCreate_Edit.label.end_date,
                        date: vm.endDate!,
                        onDateChanged: (val) {
                          try {
                            vm.updateDateRange(vm.startDate!, val);
                          } on AppErrorCodes catch (code) {
                            final msg = ErrorMapper.map(context, code: code);
                            AppToast.showError(context, msg);
                          }
                        },
                      ),
                    ],
                  ]),
              SectionWrapper(
                  title: t.S14_Task_Settings.section.settlement,
                  children: [
                    if (vm.currency != null) ...[
                      TaskCurrencyInput(
                        currency: vm.currency!,
                        onCurrencyChanged: (val) {
                          try {
                            _onCurrencyChange(context, vm, val);
                          } on AppErrorCodes catch (code) {
                            final msg = ErrorMapper.map(context, code: code);
                            AppToast.showError(context, msg);
                          }
                        },
                        enabled: true,
                      ),
                      const SizedBox(height: 8),
                    ],
                    TaskRemainderRuleInput(
                      rule: RemainderRuleConstants.getLabel(
                          context, vm.remainderRule),
                      onTap: () {
                        try {
                          _onRemainderRuleChange(context, vm);
                        } on AppErrorCodes catch (code) {
                          final msg = ErrorMapper.map(context, code: code);
                          AppToast.showError(context, msg);
                        }
                      },
                    ),
                  ]),
              SectionWrapper(
                title: t.S14_Task_Settings.section.other,
                children: [
                  NavTile(
                    title: t.S14_Task_Settings.menu.member_settings,
                    onTap: () {
                      context.pushNamed(
                        'S53',
                        pathParameters: {'taskId': vm.taskId},
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  NavTile(
                    title: t.S14_Task_Settings.menu.history,
                    onTap: () {
                      context.pushNamed(
                        'S52',
                        pathParameters: {'taskId': vm.taskId},
                        extra: vm.membersData,
                      );
                    },
                  ),
                ],
              ),
              // Settings Navigation

              if (vm.isOwner) ...[
                const SizedBox(height: 16),
                NavTile(
                  title: t.S14_Task_Settings.menu.close_task,
                  isDestructive: true,
                  onTap: () {
                    context.pushNamed('S12',
                        pathParameters: {'taskId': vm.taskId});
                  },
                ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
