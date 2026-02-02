import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  Future<void> _onConfirm(
      BuildContext context, D09TaskSettingsCurrencyConfirmViewModel vm) async {
    final success = await vm.handleConfirm();
    if (context.mounted) {
      context.pop(success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<D09TaskSettingsCurrencyConfirmViewModel>();

    return AlertDialog(
      title: Text(t.D09_TaskSettings_CurrencyConfirm.title),
      content: Text(
          "${t.D09_TaskSettings_CurrencyConfirm.content}\n\n-> ${vm.newCurrency.code} (${vm.newCurrency.symbol})"),
      actions: [
        // 取消按鈕
        TextButton(
          onPressed: vm.isProcessing ? null : () => context.pop(false),
          child: Text(t.common.buttons.cancel),
        ),
        // 確認按鈕
        TextButton(
          onPressed: vm.isProcessing ? null : () => _onConfirm(context, vm),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.error,
          ),
          child: vm.isProcessing
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(t.common.buttons.confirm),
        ),
      ],
    );
  }
}
