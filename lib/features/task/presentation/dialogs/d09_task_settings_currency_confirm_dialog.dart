import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
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
      child: const _D09DialogContent(),
    );
  }
}

class _D09DialogContent extends StatelessWidget {
  const _D09DialogContent();
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<D09TaskSettingsCurrencyConfirmViewModel>();

    return CommonAlertDialog(
      title: t.D09_TaskSettings_CurrencyConfirm.title,
      content: Text(
        "${t.D09_TaskSettings_CurrencyConfirm.content}\n\n-> ${vm.newCurrency.code} (${vm.newCurrency.symbol})",
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
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
          isLoading: vm.isProcessing,
          onPressed: () async {
            final success = await vm.handleConfirm();
            if (context.mounted) {
              context.pop(success);
            }
          },
        ),
      ],
    );
  }
}
