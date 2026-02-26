import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/constants/remainder_rule_constants.dart';
import 'package:iron_split/core/constants/task_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/deep_link_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_date_input.dart';
import 'package:iron_split/features/common/presentation/widgets/nav_title.dart';
import 'package:iron_split/features/common/presentation/widgets/share_loading.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/application/share_service.dart';
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
        inviteRepo: context.read<InviteRepository>(),
        deepLinkService: context.read<DeepLinkService>(),
        shareService: context.read<ShareService>(),
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
    // Auto-save Name when focus is lost
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _vm.updateName();
      }
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateDateRange(
      BuildContext context, S14TaskSettingsViewModel vm,
      {required DateTime start, required DateTime end}) async {
    // 髒檢查
    try {
      await vm.updateDateRange(start, end);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _showCurrencyChangeConfirmDialog(BuildContext context,
      S14TaskSettingsViewModel vm, CurrencyConstants selectedOption) async {
    final bool? success = await showDialog<bool>(
      context: context,
      builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
        taskId: vm.taskId,
        newCurrency: selectedOption,
      ),
    );
    if (success == true && context.mounted) {
      _handleCurrencyChange(context, vm, selectedOption);
    }
  }

  void _handleCurrencyChange(BuildContext context, S14TaskSettingsViewModel vm,
      CurrencyConstants selectedOption) {
    try {
      vm.updateCurrency(selectedOption);
    } on AppErrorCodes catch (code) {
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _showRemainderRuleChangeBottomSheet(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    final result = await B01BalanceRuleEditBottomSheet.show(context,
        initialRule: vm.remainderRule,
        initialMemberId: vm.remainderAbsorberId,
        members: vm.membersList,
        currentRemainder: vm.currentRemainder, // 從 VM 拿
        baseCurrency: vm.currency!);
    if (result != null && context.mounted) {
      await _handleRemainderRuleChange(context, vm, result);
    }
  }

  Future<void> _handleRemainderRuleChange(BuildContext context,
      S14TaskSettingsViewModel vm, Map<String, dynamic> result) async {
    try {
      await vm.updateRemainderRule(result['rule'], result['memberId']);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleInviteMember(
      BuildContext context, S14TaskSettingsViewModel vm, Translations t) async {
    try {
      final inviteCode = await vm.inviteMember();
      final message = t.common.share.invite.content(
        taskName: vm.nameController.value.text,
        code: inviteCode,
        link: vm.link,
      );
      // 2. 委派 VM 執行
      await vm.notifyMembers(
        message: message,
        subject: t.common.share.invite.subject,
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _redirectToMemberSettings(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    context.pushNamed(
      'S53',
      pathParameters: {'taskId': vm.taskId},
    );
  }

  void _redirectToHistory(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    context.pushNamed(
      'S52',
      pathParameters: {'taskId': vm.taskId},
      extra: vm.membersData,
    );
  }

  void _redirectToCloseTask(
      BuildContext context, S14TaskSettingsViewModel vm) async {
    context.pushNamed('S12', pathParameters: {'taskId': vm.taskId});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S14TaskSettingsViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.S14_Task_Settings.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      onErrorAction: () => vm.init(),
      child: AppKeyboardActionsWrapper(
        focusNodes: [_nameFocusNode],
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(title),
                centerTitle: true,
              ),
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                children: [
                  SectionWrapper(
                      title: t.S14_Task_Settings.section.task_name,
                      children: [
                        TaskNameInput(
                          controller: vm.nameController,
                          focusNode: _nameFocusNode,
                          label: t.common.label.task_name,
                          hint: t.S16_TaskCreate_Edit.hint.name,
                          maxLength: TaskConstants.maxTaskNameLength,
                          enabled: vm.taskStatus != TaskStatus.settled &&
                              vm.taskStatus != TaskStatus.closed,
                        ),
                        if (vm.taskStatus != TaskStatus.settled &&
                            vm.taskStatus != TaskStatus.closed) ...[
                          SizedBox(
                              height: isEnlarged
                                  ? AppLayout.spaceL
                                  : AppLayout.spaceS),
                          NavTile(
                            title: t.S14_Task_Settings.menu.invite,
                            onTap: () => _handleInviteMember(context, vm, t),
                          ),
                        ]
                      ]),
                  SectionWrapper(
                      title: t.S14_Task_Settings.section.task_period,
                      children: [
                        if (vm.startDate != null && vm.endDate != null) ...[
                          TaskDateInput(
                            label: t.common.label.start_date,
                            date: vm.startDate!,
                            onDateChanged: (val) => _handleUpdateDateRange(
                                context, vm,
                                start: val, end: vm.endDate!),
                            enabled: vm.taskStatus != TaskStatus.settled &&
                                vm.taskStatus != TaskStatus.closed,
                          ),
                          SizedBox(
                              height: isEnlarged
                                  ? AppLayout.spaceL
                                  : AppLayout.spaceS),
                          TaskDateInput(
                            label: t.common.label.end_date,
                            date: vm.endDate!,
                            onDateChanged: (val) => _handleUpdateDateRange(
                                context, vm,
                                start: vm.startDate!, end: val),
                            enabled: vm.taskStatus != TaskStatus.settled &&
                                vm.taskStatus != TaskStatus.closed,
                          ),
                        ],
                      ]),
                  SectionWrapper(
                      title: t.S14_Task_Settings.section.settlement,
                      children: [
                        if (vm.currency != null) ...[
                          TaskCurrencyInput(
                            currency: vm.currency!,
                            onCurrencyChanged: (val) =>
                                _showCurrencyChangeConfirmDialog(
                                    context, vm, val),
                            enabled: vm.taskStatus != TaskStatus.settled &&
                                vm.taskStatus != TaskStatus.closed,
                          ),
                          SizedBox(
                              height: isEnlarged
                                  ? AppLayout.spaceL
                                  : AppLayout.spaceS),
                        ],
                        TaskRemainderRuleInput(
                          rule: RemainderRuleConstants.getLabel(
                              context, vm.remainderRule),
                          onTap: () =>
                              _showRemainderRuleChangeBottomSheet(context, vm),
                          enabled: vm.taskStatus != TaskStatus.settled &&
                              vm.taskStatus != TaskStatus.closed,
                        ),
                      ]),
                  SectionWrapper(
                    title: t.S14_Task_Settings.section.other,
                    children: [
                      if (vm.taskStatus != TaskStatus.settled &&
                          vm.taskStatus != TaskStatus.closed) ...[
                        NavTile(
                          title: t.S14_Task_Settings.menu.member_settings,
                          onTap: () => _redirectToMemberSettings(context, vm),
                        ),
                        SizedBox(
                            height: isEnlarged
                                ? AppLayout.spaceL
                                : AppLayout.spaceS),
                      ],
                      NavTile(
                          title: t.S14_Task_Settings.menu.history,
                          onTap: () => _redirectToHistory(context, vm)),
                    ],
                  ),
                  // Settings Navigation

                  if (vm.isOwner &&
                      (vm.taskStatus != TaskStatus.settled &&
                          vm.taskStatus != TaskStatus.closed)) ...[
                    const SizedBox(height: AppLayout.spaceL),
                    NavTile(
                      title: t.S14_Task_Settings.menu.close_task,
                      isDestructive: true,
                      onTap: () => _redirectToCloseTask(context, vm),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (vm.inviteMemberStatus == LoadStatus.loading) SharePreparing(),
          ],
        ),
      ),
    );
  }
}
