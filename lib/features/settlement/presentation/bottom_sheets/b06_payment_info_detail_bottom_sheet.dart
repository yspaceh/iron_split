import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/models/task_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/bottom_sheets/common_bottom_sheet.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/bottom_sheets/b05_payment_info_edit_bottom_sheet.dart';
import 'package:iron_split/features/settlement/presentation/viewmodels/b06_payment_info_detail_vm.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

/// B06: 收款資訊詳情 (ReadOnly)
class B06PaymentInfoDetailBottomSheet extends StatelessWidget {
  final TaskModel task;
  final bool isCaptain;

  const B06PaymentInfoDetailBottomSheet({
    super.key,
    required this.task,
    required this.isCaptain,
  });

  static void show(BuildContext context,
      {required TaskModel task, required bool isCaptain}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) =>
          B06PaymentInfoDetailBottomSheet(task: task, isCaptain: isCaptain),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => B06PaymentInfoDetailViewModel(
        authRepo: context.read<AuthRepository>(),
        task: task,
        isCaptain: isCaptain,
      )..init(),
      child: const _B06Content(),
    );
  }
}

class _B06Content extends StatelessWidget {
  const _B06Content();

  void _copyToClipboard(BuildContext context, String text) {
    final t = Translations.of(context);
    Clipboard.setData(ClipboardData(text: text));
    AppToast.showSuccess(context, t.success.copied);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<B06PaymentInfoDetailViewModel>();
    final title = t.S31_settlement_payment_info.title;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    final double iconSize = AppLayout.inlineIconSize(isEnlarged);

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      isSheetMode: true,
      child: CommonBottomSheet(
        title: title,
        bottomActionBar: StickyBottomActionBar.sheet(
          children: [
            if (vm.isCaptain)
              AppButton(
                text: t.common.buttons.edit,
                type: AppButtonType.secondary,
                onPressed: () {
                  context.pop(); // 關閉 B06
                  // 開啟 B05
                  B05PaymentinfoEditBottomSheet.show(context, task: vm.task);
                },
              ),
            AppButton(
              text: t.common.buttons.close,
              type: AppButtonType.primary,
              onPressed: () => context.pop(),
            ),
          ],
        ),
        children: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppLayout.spaceM),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (vm.isPrivate)
                Text(t.common.payment_info.mode.private)
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (vm.info!.acceptCash)
                          _buildCashTile(context, colorScheme, textTheme, t),
                        if (vm.info!.bankAccount != null &&
                            vm.info!.bankAccount!.isNotEmpty)
                          _buildBankSection(context, vm.info!, colorScheme,
                              textTheme, t, iconSize),
                        if (vm.info!.paymentApps.isNotEmpty)
                          _buildAppsSection(context, colorScheme, textTheme, t,
                              iconSize, vm.info!.paymentApps),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCashTile(BuildContext context, ColorScheme colorScheme,
      TextTheme textTheme, Translations t) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppLayout.spaceL),
      padding: const EdgeInsets.all(AppLayout.spaceL),
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppLayout.radiusM),
          color: colorScheme.surfaceContainerLow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.common.payment_info.type.cash, style: textTheme.labelLarge),
        ],
      ),
    );
  }

  Widget _buildBankSection(
      BuildContext context,
      PaymentInfoModel info,
      ColorScheme colorScheme,
      TextTheme textTheme,
      Translations t,
      double iconSize) {
    final copyText = "${info.bankName ?? ''}\n${info.bankAccount}".trim();

    return Container(
      margin: const EdgeInsets.only(bottom: AppLayout.spaceL),
      padding: const EdgeInsets.all(AppLayout.spaceL),
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppLayout.radiusM),
          color: colorScheme.surfaceContainerLow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.common.payment_info.type.bank, style: textTheme.labelLarge),
          if (info.bankName != null && info.bankName!.isNotEmpty) ...[
            const SizedBox(height: AppLayout.spaceXS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.bankName!, style: textTheme.bodyMedium),
                    Text(
                      info.bankAccount!,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.copy, size: iconSize),
                  onPressed: () => _copyToClipboard(context, copyText),
                  tooltip: t.B06_payment_info_detail.buttons.copy,
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildAppsSection(
      BuildContext context,
      ColorScheme colorScheme,
      TextTheme textTheme,
      Translations t,
      double iconSize,
      List<PaymentAppInfo> apps) {
    String copyText(String? appName, String? appLink) {
      return "${appName ?? ''}\n${appLink ?? ''}".trim();
    }

    return Container(
      padding: const EdgeInsets.all(AppLayout.spaceL),
      decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppLayout.radiusM),
          color: colorScheme.surfaceContainerLow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(t.common.payment_info.type.apps, style: textTheme.labelLarge),
          const SizedBox(height: AppLayout.spaceXS),
          ...apps.map(
            (app) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app.name, style: textTheme.bodyMedium),
                      Text(
                        app.link,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.copy, size: iconSize),
                    onPressed: () =>
                        _copyToClipboard(context, copyText(app.name, app.link)),
                    tooltip: t.B06_payment_info_detail.buttons.copy,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
