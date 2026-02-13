import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/helpers/task_share_helper.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s16_task_create_edit_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_currency_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_member_count_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';

/// Page Key: S16_TaskCreate.Edit
class S16TaskCreateEditPage extends StatelessWidget {
  const S16TaskCreateEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注入 VM
    return ChangeNotifierProvider(
      create: (_) => S16TaskCreateEditViewModel(
        taskRepo: context.read<TaskRepository>(),
        authRepo: context.read<AuthRepository>(),
        inviteRepo: context.read<InviteRepository>(),
      )..init(),
      child: const _S16Content(),
    );
  }
}

class _S16Content extends StatefulWidget {
  const _S16Content();

  @override
  State<_S16Content> createState() => _S16ContentState();
}

class _S16ContentState extends State<_S16Content> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late S16TaskCreateEditViewModel _vm;

  @override
  void initState() {
    super.initState();
    // 監聽文字變動以即時更新 Suffix 計數器 (保留原邏輯)
    _nameController.addListener(() {
      setState(() {});
    });
    _vm = context.read<S16TaskCreateEditViewModel>();
    _vm.addListener(_onStateChanged);

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
    _nameController.dispose();
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  Future<void> _onSave(
      BuildContext context, S16TaskCreateEditViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // 1. 顯示 D03 確認框 (純 UI)
    final bool? confirmed = await D03TaskCreateConfirmDialog.show<bool>(
      context,
      taskName: _nameController.text.trim(),
      startDate: vm.startDate,
      endDate: vm.endDate,
      baseCurrency: vm.baseCurrency,
      memberCount: vm.memberCount,
    );

    // 2. 如果使用者確認
    if (confirmed == true && mounted) {
      try {
        // 呼叫 VM 執行建立流程
        final result = await vm.createTask(_nameController.text.trim(), t);

        if (result != null && mounted) {
          // 2. 如果有邀請碼 (代表多人任務)，呼叫 Helper 進行分享
          if (result.inviteCode != null && context.mounted) {
            await TaskShareHelper.inviteMember(
              context: context,
              taskName: _nameController.text.trim(),
              inviteCode: result.inviteCode!,
            );
          }

          // 3. 導航到任務 Dashboard
          if (context.mounted) {
            context.goNamed(
              'S13', // 請確認您的 Router name (例如 S13)
              pathParameters: {'taskId': result.taskId},
            );
          }
        }
      } on AppErrorCodes catch (code) {
        if (!context.mounted) return;
        final msg = ErrorMapper.map(context, code: code);
        AppToast.showError(context, msg);
      }
    }
  }

  // 判斷是否需要攔截
  Future<void> _handleClose() async {
    final confirm = await D04CommonUnsavedConfirmDialog.show<bool>(context);

    if (confirm == true && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<S16TaskCreateEditViewModel>();
    final title = t.S16_TaskCreate_Edit.title;
    final leading = IconButton(
      icon: Icon(Icons.adaptive.arrow_back),
      onPressed: _handleClose,
    );

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      leading: leading,
      onErrorAction: () => vm.init(),
      child: Stack(
        children: [
          PopScope(
            canPop: false, // 設為 false 表示手動控制返回邏輯
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handleClose();
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(title),
                leading: leading,
              ),
              // 1. 全局點擊偵測：點擊背景收起鍵盤
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                behavior: HitTestBehavior.translucent, // 確保點擊空白處也能觸發
                child: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SectionWrapper(
                            title: t.S16_TaskCreate_Edit.section.task_name,
                            children: [
                              TaskNameInput(
                                controller: _nameController,
                                label: t.S16_TaskCreate_Edit.label.name,
                                hint: t.S16_TaskCreate_Edit.hint.name,
                                maxLength: 20,
                              )
                            ]),
                        SectionWrapper(
                            title: t.S16_TaskCreate_Edit.section.task_period,
                            children: [
                              TaskDateInput(
                                label: t.S16_TaskCreate_Edit.label.start_date,
                                date: vm.startDate,
                                onDateChanged: (val) {
                                  try {
                                    vm.updateDateRange(val, vm.endDate);
                                  } on AppErrorCodes catch (code) {
                                    final msg =
                                        ErrorMapper.map(context, code: code);
                                    AppToast.showError(context, msg);
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              TaskDateInput(
                                label: t.S16_TaskCreate_Edit.label.end_date,
                                date: vm.endDate,
                                onDateChanged: (val) {
                                  try {
                                    vm.updateDateRange(vm.startDate, val);
                                  } on AppErrorCodes catch (code) {
                                    final msg =
                                        ErrorMapper.map(context, code: code);
                                    AppToast.showError(context, msg);
                                  }
                                },
                              ),
                            ]),
                        SectionWrapper(
                            title: t.S16_TaskCreate_Edit.section.settlement,
                            children: [
                              TaskCurrencyInput(
                                currency: vm.baseCurrency,
                                onCurrencyChanged: vm.updateCurrency,
                                enabled: vm.isCurrencyEnabled,
                              ),
                              const SizedBox(height: 8),
                              TaskMemberCountInput(
                                value: vm.memberCount,
                                onChanged: vm.updateMemberCount,
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: StickyBottomActionBar(
                isSheetMode: false,
                children: [
                  AppButton(
                    text: t.S16_TaskCreate_Edit.buttons.save,
                    type: AppButtonType.primary,
                    onPressed: () => _onSave(context, vm),
                  ),
                ],
              ),
            ),
          ),
          // 全局 Loading Overlay
          if (vm.actionStatus == LoadStatus.loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      vm.statusText ?? t.D03_TaskCreate_Confirm.creating_task,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
