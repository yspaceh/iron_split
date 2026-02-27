import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/record/application/record_service.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/task/presentation/viewmodels/d09_task_settings_currency_confirm_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D09_TaskSettings.CurrencyConfirm
class D09TaskSettingsCurrencyConfirmDialog extends StatelessWidget {
  final String taskId;
  final CurrencyConstants newCurrency;

  const D09TaskSettingsCurrencyConfirmDialog({
    super.key,
    required this.taskId,
    required this.newCurrency,
  });

  static Future<T?> show<T>(BuildContext context,
      {required String taskId, required CurrencyConstants newCurrency}) {
    return showDialog(
      context: context,
      builder: (context) => D09TaskSettingsCurrencyConfirmDialog(
        taskId: taskId,
        newCurrency: newCurrency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => D09TaskSettingsCurrencyConfirmViewModel(
        taskId: taskId,
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
        recordService: context.read<RecordService>(),
        newCurrency: newCurrency,
      ),
      child: const _D09Content(),
    );
  }
}

class _D09Content extends StatelessWidget {
  const _D09Content();
  Future<void> _handleConfirm(
      BuildContext context, D09TaskSettingsCurrencyConfirmViewModel vm) async {
    try {
      await vm.confirm();
      if (!context.mounted) return;
      context.pop();
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
    final vm = context.watch<D09TaskSettingsCurrencyConfirmViewModel>();
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );

    return CommonAlertDialog(
      title: t.d09_task_settings_currency_confirm.title,
      content: Text(
        "${t.d09_task_settings_currency_confirm.content}\n\n-> ${vm.newCurrency.code} (${vm.newCurrency.symbol})",
        style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(false),
        ),
        AppButton(
          text: t.common.buttons.confirm,
          type: AppButtonType.primary,
          isLoading: vm.confirmStatus == LoadStatus.loading,
          onPressed: () => _handleConfirm(context, vm),
        ),
      ],
    );
  }
}
