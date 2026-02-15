import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/task_service.dart';

import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s12_task_close_notice_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S12TaskCloseNoticePage extends StatelessWidget {
  final String taskId;

  const S12TaskCloseNoticePage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S12TaskCloseNoticeViewModel(
        taskId: taskId,
        authRepo: context.read<AuthRepository>(),
        service: context.read<TaskService>(),
      )..init(),
      child: const _S12Content(),
    );
  }
}

class _S12Content extends StatelessWidget {
  const _S12Content();

  Future<void> _handleClose(
      BuildContext context, S12TaskCloseNoticeViewModel vm) async {
    try {
      await vm.closeTask();

      if (!context.mounted) return;
      context.pop();
      context.goNamed(
        'S17',
        pathParameters: {'taskId': vm.taskId},
      );
    } on AppErrorCodes catch (code) {
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _showConfirmDialog(
      BuildContext context, S12TaskCloseNoticeViewModel vm) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    CommonAlertDialog.show(
      context,
      title: t.D08_TaskClosed_Confirm.title,
      content: Text(
        t.D08_TaskClosed_Confirm.content,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.D08_TaskClosed_Confirm.buttons.confirm,
          type: AppButtonType.primary,
          onPressed: () => _handleClose(context, vm),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S12TaskCloseNoticeViewModel>();
    final title = t.S12_TaskClose_Notice.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        bottomNavigationBar: StickyBottomActionBar(
          children: [
            AppButton(
              text: t.common.buttons.back,
              type: AppButtonType.secondary,
              onPressed: () => context.pop(),
            ),
            AppButton(
              text: t.S12_TaskClose_Notice.buttons.close,
              type: AppButtonType.primary,
              isLoading: vm.closeStatus == LoadStatus.loading,
              onPressed: () => _showConfirmDialog(context, vm),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Column(
              children: [
                Text(
                  t.S12_TaskClose_Notice.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
