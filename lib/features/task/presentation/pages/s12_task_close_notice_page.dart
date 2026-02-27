import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
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
        record: context.read<RecordRepository>(),
        taskService: context.read<TaskService>(),
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
      context.goNamed('S00');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _showConfirmDialog(BuildContext context, S12TaskCloseNoticeViewModel vm,
      double finalLineHeight) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    CommonAlertDialog.show(
      context,
      title: t.d08_task_closed_confirm.title,
      content: Text(
        t.d08_task_closed_confirm.content,
        style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.common.buttons.confirm,
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
    final textTheme = theme.textTheme;
    final vm = context.watch<S12TaskCloseNoticeViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.s12_task_close_notice.title;

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
              text: t.s12_task_close_notice.buttons.close_task,
              type: AppButtonType.primary,
              isLoading: vm.closeStatus == LoadStatus.loading,
              onPressed: () => _showConfirmDialog(context, vm, finalLineHeight),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalMargin, vertical: AppLayout.spaceL),
            child: Column(
              children: [
                Text(
                  t.s12_task_close_notice.content,
                  style:
                      textTheme.bodyMedium?.copyWith(height: finalLineHeight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
