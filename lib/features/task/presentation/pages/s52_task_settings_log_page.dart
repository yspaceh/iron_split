import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/task/application/export_service.dart';
import 'package:iron_split/features/task/application/share_service.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/features/task/presentation/widgets/activity_log_item.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/task/presentation/viewmodels/s52_task_settings_log_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S52TaskSettingsLogPage extends StatelessWidget {
  const S52TaskSettingsLogPage({
    super.key,
    required this.taskId,
    required this.membersData,
  });

  final String taskId;
  final Map<String, TaskMember> membersData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S52TaskSettingsLogViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        authRepo: context.read<AuthRepository>(),
        exportService: context.read<ExportService>(),
        shareService: context.read<ShareService>(),
        membersData: membersData,
      )..init(),
      child: const _S52Content(),
    );
  }
}

class _S52Content extends StatelessWidget {
  const _S52Content();

  Future<void> _handleExport(BuildContext context,
      S52TaskSettingsLogViewModel vm, Translations t) async {
    try {
      await vm.exportCsv(
        subject: t.s52_task_settings_log.title,
        fileName: t.s52_task_settings_log.export_file_prefix,
        header: '${t.s52_task_settings_log.csv_header.time},'
            '${t.s52_task_settings_log.csv_header.user},'
            '${t.s52_task_settings_log.csv_header.action},'
            '${t.s52_task_settings_log.csv_header.details}',
        getAction: (log) => log.getLocalizedAction(context),
        getDetails: (log) => log.getFormattedDetails(context),
        defaultMemberName: t.s53_task_settings_members.member_default_name,
      );
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final t = Translations.of(context);
    final vm = context.watch<S52TaskSettingsLogViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final title = t.s52_task_settings_log.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
                  itemCount: vm.logs.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                  ),
                  itemBuilder: (context, index) {
                    final log = vm.logs[index];
                    return ActivityLogItem(
                      log: log,
                      members: vm.membersData,
                      isEnlarged: isEnlarged, // Use data from VM
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: StickyBottomActionBar(
          isSheetMode: false,
          children: [
            AppButton(
              text: t.s52_task_settings_log.buttons.export_csv,
              type: AppButtonType.secondary,
              isLoading: vm.exportStatus == LoadStatus.loading,
              onPressed: () => _handleExport(context, vm, t),
            ),
          ],
        ),
      ),
    );
  }
}
