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
import 'package:iron_split/features/task/application/task_service.dart';
import 'package:iron_split/features/task/data/services/activity_log_service.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s20_task_leave_notice_vm.dart';

import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';

class S20TaskLeaveNoticePage extends StatelessWidget {
  final String taskId;

  const S20TaskLeaveNoticePage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S20TaskLeaveNoticeViewModel(
        taskId: taskId,
        authRepo: context.read<AuthRepository>(),
        taskService: context.read<TaskService>(),
        activityLogService:
            context.read<ActivityLogService?>() ?? ActivityLogService(),
      )..init(),
      child: const _S20Content(),
    );
  }
}

class _S20Content extends StatelessWidget {
  const _S20Content();

  Future<void> _handleLeave(
      BuildContext context, S20TaskLeaveNoticeViewModel vm) async {
    try {
      await vm.leaveTask();

      if (!context.mounted) return;
      context.pop();
      context.goNamed('S00');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final vm = context.watch<S20TaskLeaveNoticeViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.s20_task_leave_notice.title;

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
              text: t.s20_task_leave_notice.buttons.close_task,
              type: AppButtonType.primary,
              isLoading: vm.leaveStatus == LoadStatus.loading,
              onPressed: () => _handleLeave(context, vm),
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
                  t.s20_task_leave_notice.content,
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
