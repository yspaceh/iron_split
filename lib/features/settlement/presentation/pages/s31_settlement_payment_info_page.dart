// lib/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/error/exceptions.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/task/data/task_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/models/payment_info_model.dart';

// ViewModels & Widgets
import 'package:iron_split/features/settlement/presentation/viewmodels/s31_settlement_payment_info_vm.dart';
import 'package:iron_split/features/settlement/presentation/widgets/step_dots.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';

// [NOTE]: 這裡需要一個簡化版的摘要卡片，或者沿用 GroupBalanceCard
// 為了 DRY，這裡假設您可以傳入 totalAmount 等資訊，或是直接顯示靜態文字
// 實際專案中請引用 S30 的 ViewModel 或參數

class S31SettlementPaymentInfoPage extends StatelessWidget {
  final String taskId;
  final double checkPointPoolBalance;
  final Map<String, List<String>> mergeMap;

  // 實務上 S30 轉場時會把摘要資料傳過來 (extra)，這裡簡化處理
  const S31SettlementPaymentInfoPage({
    super.key,
    required this.taskId,
    required this.checkPointPoolBalance,
    required this.mergeMap,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S31SettlementPaymentInfoViewModel(
        taskId: taskId,
        checkPointPoolBalance: checkPointPoolBalance,
        mergeMap: mergeMap,
        settlementService: context.read<SettlementService>(),
        taskRepo: context.read<TaskRepository>(),
        recordRepo: context.read<RecordRepository>(),
      )..init(),
      child: const _S31Content(),
    );
  }
}

class _S31Content extends StatelessWidget {
  const _S31Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final vm = context.watch<S31SettlementPaymentInfoViewModel>();

    Future<void> executeSettlement() async {
      try {
        // 執行結算
        await vm.handleExecuteSettlement();

        if (context.mounted) {
          context.goNamed('S32', pathParameters: {'taskId': vm.taskId});
        }
      } on SettlementDataConflictException catch (_) {
        // [異常處理] 資料變動
        if (!context.mounted) return;

        // 跳出警告 Dialog，並等待使用者按下按鈕
        await CommonAlertDialog.show(
          context,
          title: t.error.dialog.data_conflict.title,
          content: Text(
            t.error.dialog.data_conflict.message,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            AppButton(
              text: t.common.buttons.back,
              type: AppButtonType.primary,
              // 按下後，只負責關閉 Dialog
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );

        // Dialog 關閉後，執行退回 S30 (這會觸發 PopScope 的解鎖邏輯)
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } on SettlementStatusInvalidException catch (_) {
        if (!context.mounted) return;
        CommonAlertDialog.show(
          context,
          title: t.common.error.title,
          content: Text(t.error.settlement.status_invalid),
          actions: [
            AppButton(
              text: t.common.buttons.ok,
              type: AppButtonType.primary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      } catch (e) {
        // TODO: handle error
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.common.error.unknown(error: e.toString())),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    }

    Future<bool> showRateInfoDialog() async {
      return await CommonAlertDialog.show<bool>(
            context,
            title: t.D06_settlement_confirm.title, // "結算確認"
            // 直接顯示純文字警告，不用再包 Column 或顯示金額
            content: Text(
              t.D06_settlement_confirm.warning_text,
              style: textTheme.bodyMedium,
            ),
            actions: [
              // 取消按鈕
              AppButton(
                text: t.common.buttons.cancel,
                type: AppButtonType.secondary,
                onPressed: () => context.pop(false),
              ),
              // 確定結算按鈕
              AppButton(
                text: t.D06_settlement_confirm.buttons.confirm, // "確定結算"
                type: AppButtonType.primary,
                onPressed: () => context.pop(true),
              ),
            ],
          ) ??
          false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S31_settlement_payment_info.title), // 需新增 i18n
        centerTitle: true,
        actions: [
          StepDots(currentStep: 2, totalSteps: 2), // Step 2/2
          const SizedBox(width: 24),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: PaymentInfoForm(controller: vm.formController),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sync Checkbox (Smart Display)
          if (vm.showSyncOption &&
              vm.formController.mode == PaymentMode.specific)
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

          StickyBottomActionBar(
            children: [
              AppButton(
                text: t.S31_settlement_payment_info.buttons.prev_step,
                type: AppButtonType.secondary,
                onPressed: () => context.pop(),
              ),
              AppButton(
                text: t.S31_settlement_payment_info.buttons.settle, // "結算"
                type: AppButtonType.primary,
                onPressed: () async {
                  final bool shouldSettle = await showRateInfoDialog();
                  debugPrint(shouldSettle.toString());
                  if (shouldSettle == true && context.mounted) {
                    await executeSettlement();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
