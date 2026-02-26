import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart'; // 使用您上傳的元件
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s11_invite_confirm_vm.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class S11InviteConfirmPage extends StatelessWidget {
  final String inviteCode;

  const S11InviteConfirmPage({
    super.key,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S11InviteConfirmViewModel(
        inviteRepo: context.read<InviteRepository>(),
        authRepo: context.read<AuthRepository>(),
        pendingProvider: context.read<PendingInviteProvider>(),
      )..init(inviteCode), // 初始化 VM
      child: const _S11Content(),
    );
  }
}

class _S11Content extends StatelessWidget {
  const _S11Content();

  Future<void> _handleJoin(BuildContext context, S11InviteConfirmViewModel vm,
      Translations t, TextTheme textTheme, double finalLineHeight) async {
    try {
      final taskId = await vm.confirmJoin();
      if (taskId == null) return;
      if (!context.mounted) return;

      context.goNamed('S13', pathParameters: {'taskId': taskId});
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      CommonAlertDialog.show(
        context,
        title: t.D02_Invite_Result.title,
        actions: [
          AppButton(
            text: t.common.buttons.back,
            type: AppButtonType.primary,
            onPressed: () {
              vm.clearInvite();
              context.goNamed('S00');
            },
          ),
        ],
        content: Text(
          msg,
          style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
        ),
      );
    }
  }

  void _handleCancel(BuildContext context, S11InviteConfirmViewModel vm) {
    vm.clearInvite();
    context.goNamed('S00');
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<S11InviteConfirmViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final dateFormat = DateFormat('yyyy/MM/dd');

    final title = t.S11_Invite_Confirm.title;
    final leading = IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => _handleCancel(context, vm),
      // 取消
    );

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      errorActionText: t.common.buttons.back,
      onErrorAction: () => _handleCancel(context, vm),
      title: title,
      leading: leading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          leading: leading,
        ),
        bottomNavigationBar: StickyBottomActionBar(
          children: [
            AppButton(
              text: t.common.buttons.cancel,
              type: AppButtonType.secondary,
              onPressed: () => _handleCancel(context, vm),
            ),
            AppButton(
              text: t.common.buttons.confirm,
              type: AppButtonType.primary,
              isLoading: vm.joinStatus == LoadStatus.loading,
              // 按鈕狀態由 VM 決定 (是否已選 Ghost)
              onPressed: vm.canConfirm
                  ? () =>
                      _handleJoin(context, vm, t, textTheme, finalLineHeight)
                  : null,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppLayout.spaceL, horizontal: AppLayout.spaceL),
                  decoration: BoxDecoration(
                    color: colorScheme.surface, // 純白背景
                    borderRadius: BorderRadius.circular(AppLayout.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildColumn(context, t.common.label.task_name,
                          vm.taskName, colorScheme, textTheme),
                      const SizedBox(height: AppLayout.spaceS),
                      _buildColumn(
                          context,
                          t.common.label.period,
                          '${dateFormat.format(vm.startDate)} - ${dateFormat.format(vm.endDate)}',
                          colorScheme,
                          textTheme),
                    ],
                  ),
                ),

                const SizedBox(height: AppLayout.spaceL),

                // --- B. Ghost Selection (如果需要) ---
                if (vm.showGhostSelection) ...[
                  SectionWrapper(
                      title: t.S11_Invite_Confirm.label.select_ghost,
                      children: [
                        ...vm.ghosts.map((ghost) {
                          final id = ghost.id;
                          final name = ghost.displayName;
                          final prepaid = ghost.prepaid;
                          final expense = ghost.expense;
                          final isSelected = vm.selectedGhostId == id;

                          return SelectionTile(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            isSelectedBackgroundColor: colorScheme.surface,
                            isSelected: isSelected,
                            isRadio: true, // 這是單選列表
                            onTap: () => vm.selectGhost(id),
                            leading: CommonAvatar(
                              avatarId: null, // Ghost 通常沒有頭像 ID
                              name: name,
                              isLinked: false,
                              radius: 20,
                            ),
                            title: name,
                            // 將餘額顯示在右側
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${t.S11_Invite_Confirm.label.prepaid}: ${CurrencyConstants.formatAmount(prepaid, vm.baseCurrency.code)}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.tertiary,
                                  ),
                                ),
                                Text(
                                  "${t.S11_Invite_Confirm.label.expense}: ${CurrencyConstants.formatAmount(expense, vm.baseCurrency.code)}",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ]),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String label, String value,
      ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
