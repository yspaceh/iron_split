import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/task_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/d04_common_unsaved_confirm_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/share_loading.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
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
        shareService: context.read<ShareService>(),
        deepLinkService: context.read<DeepLinkService>(),
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
  late FocusNode _nameFocusNode;

  @override
  void initState() {
    super.initState();
    // 監聽文字變動以即時更新 Suffix 計數器 (保留原邏輯)
    _nameFocusNode = FocusNode();
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleCreate(BuildContext context,
      S16TaskCreateEditViewModel vm, Translations t) async {
    try {
      // 呼叫 VM 執行建立流程
      final result = await vm.createTask(_nameController.text.trim());

      if (result != null && mounted) {
        // 2. 如果有邀請碼 (代表多人任務)，呼叫 Helper 進行分享
        if (!context.mounted) return;
        if (result.inviteCodeDetail?.code == null) {
          throw AppErrorCodes.initFailed;
        }
        final message = t.common.share.invite.content(
          taskName: _nameController.text.trim(),
          code: result.inviteCodeDetail?.code ?? '',
          link: vm.link,
        );

        await vm.notifyMembers(
          message: message,
          subject: t.common.share.invite.subject,
        );
        // 3. 導航到任務 Dashboard
        if (!context.mounted) return;
        context.goNamed(
          'S13',
          pathParameters: {'taskId': result.taskId},
        );
      }
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _showConfirmDialog(BuildContext context,
      S16TaskCreateEditViewModel vm, Translations t) async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();

    // 1. 顯示 D03 確認框 (純 UI)
    final bool? confirmed = await D03TaskCreateConfirmDialog.show<bool>(
      context,
      taskName: _nameController.text.trim(),
      startDate: vm.startDate,
      endDate: vm.endDate,
      baseCurrency: vm.baseCurrency,
      memberCount: vm.memberCount,
    );
    if (confirmed == true && context.mounted) {
      await _handleCreate(context, vm, t);
    }
  }

  // 判斷是否需要攔截
  Future<void> _handleClose(BuildContext context) async {
    final confirm = await D04CommonUnsavedConfirmDialog.show<bool>(context);
    if (confirm == true && context.mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<S16TaskCreateEditViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.s16_task_create_edit.title;
    final leading = IconButton(
      icon: Icon(Icons.adaptive.arrow_back),
      onPressed: () => _handleClose(context),
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
              if (vm.createStatus == LoadStatus.loading ||
                  vm.shareStatus == LoadStatus.loading) {
                return; // Do nothing, ignore the back button
              }
              await _handleClose(context);
            },
            child: AppKeyboardActionsWrapper(
              focusNodes: [_nameFocusNode],
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  centerTitle: true,
                  leading: leading,
                ),
                // 1. 全局點擊偵測：點擊背景收起鍵盤
                body: SafeArea(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalMargin,
                          vertical: AppLayout.spaceL),
                      children: [
                        SectionWrapper(
                            title: t.s16_task_create_edit.section.task_name,
                            children: [
                              TaskNameInput(
                                controller: _nameController,
                                focusNode: _nameFocusNode,
                                label: t.common.label.task_name,
                                hint: t.s16_task_create_edit.hint.name,
                                maxLength: TaskConstants.maxTaskNameLength,
                              )
                            ]),
                        SectionWrapper(
                            title: t.s16_task_create_edit.section.task_period,
                            children: [
                              TaskDateInput(
                                label: t.common.label.start_date,
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
                              SizedBox(
                                  height: isEnlarged
                                      ? AppLayout.spaceL
                                      : AppLayout.spaceS),
                              TaskDateInput(
                                label: t.common.label.end_date,
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
                            title: t.s16_task_create_edit.section.settlement,
                            children: [
                              TaskCurrencyInput(
                                currency: vm.baseCurrency,
                                onCurrencyChanged: vm.updateCurrency,
                                enabled: vm.isCurrencyEnabled,
                              ),
                              SizedBox(
                                  height: isEnlarged
                                      ? AppLayout.spaceL
                                      : AppLayout.spaceS),
                              TaskMemberCountInput(
                                value: vm.memberCount,
                                onChanged: vm.updateMemberCount,
                              ),
                            ]),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: StickyBottomActionBar(
                  isSheetMode: false,
                  children: [
                    AppButton(
                      text: t.common.buttons.save,
                      type: AppButtonType.primary,
                      onPressed: () => _showConfirmDialog(context, vm, t),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 全局 Loading Overlay
          if (vm.createStatus == LoadStatus.loading ||
              vm.shareStatus == LoadStatus.loading)
            SharePreparing(),
        ],
      ),
    );
  }
}
