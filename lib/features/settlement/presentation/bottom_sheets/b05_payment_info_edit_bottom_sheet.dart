import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/b05_payment_info_edit_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

/// B05: 編輯收款資訊 (BottomSheet)
class B05PaymentinfoEditBottomSheet extends StatelessWidget {
  final TaskModel task;

  const B05PaymentinfoEditBottomSheet({super.key, required this.task});

  static void show(BuildContext context, {required TaskModel task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      // 避免鍵盤遮擋
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: B05PaymentinfoEditBottomSheet(task: task),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B05PaymentInfoEditViewModel(
        taskRepo: context.read<TaskRepository>(),
        task: task,
      )..init(),
      child: const _B05Content(),
    );
  }
}

class _B05Content extends StatelessWidget {
  const _B05Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<B05PaymentInfoEditViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return CommonBottomSheet(
      title: t.S31_settlement_payment_info.title,
      bottomActionBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sync Checkbox (Smart Display)
          if (vm.showSyncOption)
            Container(
              color: colorScheme.surfaceContainerLow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: CheckboxListTile(
                value: vm.isSyncChecked,
                onChanged: vm.toggleSync,
                title: Text(
                  vm.isUpdate
                      ? t.S31_settlement_payment_info
                          .sync_update // "更新我的預設收款資訊"
                      : t.S31_settlement_payment_info.sync_save, // "儲存為預設收款資訊"
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: colorScheme.primary,
              ),
            ),
          StickyBottomActionBar.sheet(
            children: [
              AppButton(
                text: t.common.buttons.cancel,
                type: AppButtonType.secondary,
                onPressed: () => context.pop(),
              ),
              AppButton(
                text: t.common.buttons.save,
                type: AppButtonType.primary,
                onPressed: () async {
                  try {
                    await vm.save(t);
                    if (context.mounted) {
                      context.pop();
                    }
                  } catch (e) {
                    //TODO: Handle Error
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
      children: SingleChildScrollView(
        child: PaymentInfoForm(controller: vm.formController),
      ),
    );
  }
}
