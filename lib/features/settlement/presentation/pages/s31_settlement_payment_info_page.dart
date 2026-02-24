// lib/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/record/data/record_repository.dart';
import 'package:iron_split/features/settlement/application/settlement_service.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
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
        authRepo: context.read<AuthRepository>(),
        systemRepo: context.read<SystemRepository>(),
      )..init(),
      child: const _S31Content(),
    );
  }
}

class _S31Content extends StatefulWidget {
  const _S31Content();

  @override
  State<_S31Content> createState() => _S31ContentState();
}

class _S31ContentState extends State<_S31Content> {
  late FocusNode _bankNameNode;
  late FocusNode _bankAccountNode;
  final Map<int, FocusNode> _appNameNodes = {};
  final Map<int, FocusNode> _appLinkNodes = {};

  @override
  void initState() {
    super.initState();
    _bankNameNode = FocusNode();
    _bankAccountNode = FocusNode();
  }

  @override
  void dispose() {
    _bankNameNode.dispose();
    _bankAccountNode.dispose();
    for (var node in _appNameNodes.values) {
      node.dispose();
    }
    for (var node in _appLinkNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  // 取得動態 Node 的 Helper
  FocusNode _getAppLinkNode(int index) {
    return _appLinkNodes.putIfAbsent(index, () => FocusNode());
  }

  FocusNode _getAppNameNode(int index) {
    return _appNameNodes.putIfAbsent(index, () => FocusNode());
  }

  Future<void> _handleSettlement(
      BuildContext context,
      S31SettlementPaymentInfoViewModel vm,
      Translations t,
      TextTheme textTheme) async {
    try {
      // 執行結算
      await vm.executeSettlement();
      if (!context.mounted) return;
      context.goNamed('S32', pathParameters: {'taskId': vm.taskId});
    } on AppErrorCodes catch (code) {
      switch (code) {
        case AppErrorCodes.dataConflict:
          // [異常處理] 資料變動
          if (!context.mounted) return;
          await CommonAlertDialog.show(
            context,
            title: t.error.dialog.data_conflict.title,
            content: Text(
              t.error.dialog.data_conflict.content,
              style: textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            actions: [
              AppButton(
                text: t.common.buttons.back,
                type: AppButtonType.primary,
                // 按下後，只負責關閉 Dialog
                onPressed: () => context.pop(),
              ),
            ],
          );
          // Dialog 關閉後，執行退回 S30 (這會觸發 PopScope 的解鎖邏輯)
          if (!context.mounted) return;
          context.pop();
          break;
        case AppErrorCodes.taskStatusError:
          if (!context.mounted) return;
          CommonAlertDialog.show(
            context,
            title: t.error.title,
            content: Text(t.error.message.task_status_error),
            actions: [
              AppButton(
                text: t.common.buttons.ok,
                type: AppButtonType.primary,
                onPressed: () => context.pop(),
              ),
            ],
          );
          break;
        default:
          if (!context.mounted) return;
          final String msg = ErrorMapper.map(context, code: code);
          AppToast.showError(context, msg);
      }
    }
  }

  Future<void> _showRateInfoDialog(
      BuildContext context,
      S31SettlementPaymentInfoViewModel vm,
      Translations t,
      TextTheme textTheme) async {
    await CommonAlertDialog.show(
          context,
          title: t.D06_settlement_confirm.title, // "結算確認"
          // 直接顯示純文字警告，不用再包 Column 或顯示金額
          content: Text(
            t.D06_settlement_confirm.content,
            style: textTheme.bodyMedium,
          ),
          actions: [
            // 取消按鈕
            AppButton(
              text: t.common.buttons.cancel,
              type: AppButtonType.secondary,
              onPressed: () => context.pop(),
            ),
            // 確定結算按鈕
            AppButton(
              text: t.common.buttons.settlement, // "確定結算"
              type: AppButtonType.primary,
              onPressed: () => _handleSettlement(context, vm, t, textTheme),
            ),
          ],
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final vm = context.watch<S31SettlementPaymentInfoViewModel>();

    final allNodes = [
      _bankNameNode,
      _bankAccountNode,
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppNameNode(i)),
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppLinkNode(i)),
    ];

    final title = t.S31_settlement_payment_info.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: AppKeyboardActionsWrapper(
        focusNodes: allNodes,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title), // 需新增 i18n
            centerTitle: true,
            actions: [
              StepDots(currentStep: 2, totalSteps: 2), // Step 2/2
              const SizedBox(width: 24),
            ],
          ),
          body: SingleChildScrollView(
            child: PaymentInfoForm(
              controller: vm.formController,
              isSelectedBackgroundColor: colorScheme.surface,
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sync Checkbox (Smart Display)
              if (vm.showSyncOption &&
                  vm.formController.mode == PaymentMode.specific)
                SelectionTile(
                  isSelected: vm.isSyncChecked,
                  isRadio: false, // Checkbox 模式
                  onTap: () => vm.toggleSync(!vm.isSyncChecked),
                  title: vm.isUpdate
                      ? t.S31_settlement_payment_info
                          .sync_update // "更新我的預設收款資訊"
                      : t.S31_settlement_payment_info.sync_save, // "儲存為預設收款資訊"
                  backgroundColor: Colors.transparent,
                  isSelectedBackgroundColor: Colors.transparent,
                ),

              StickyBottomActionBar(
                children: [
                  AppButton(
                    text: t.S31_settlement_payment_info.buttons.prev_step,
                    type: AppButtonType.secondary,
                    onPressed: () => context.pop(),
                  ),
                  AppButton(
                    text: t.common.buttons.settlement, // "結算"
                    type: AppButtonType.primary,
                    isLoading: vm.settlementStatus == LoadStatus.loading,
                    onPressed: () =>
                        _showRateInfoDialog(context, vm, t, textTheme),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
