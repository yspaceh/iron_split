import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart'; // 使用您上傳的元件
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/application/pending_invite_provider.dart';
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
        pendingProvider: context.read<PendingInviteProvider>(),
      )..init(inviteCode), // 初始化 VM
      child: const _S11Content(),
    );
  }
}

class _S11Content extends StatefulWidget {
  const _S11Content();

  @override
  State<_S11Content> createState() => _S11ContentState();
}

class _S11ContentState extends State<_S11Content> {
  bool _hasShownError = false;
  void _showErrorDialog(
      BuildContext context, S11InviteConfirmViewModel vm, String error) {
    final friendlyMessage = ErrorMapper.map(context, error);
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
      content: Text(friendlyMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<S11InviteConfirmViewModel>();
    final dateFormat = DateFormat('yyyy/MM/dd');

    // 1. Loading
    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Init Error (例如無效代碼)
    if (vm.errorCode != null && !_hasShownError) {
      _hasShownError = true;
      // 使用 PostFrameCallback 避免 build 期間彈窗
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, vm, vm.errorCode!);
      });
      return const Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S11_Invite_Confirm.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            vm.clearInvite();
            context.goNamed('S00');
          }, // 取消
        ),
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S11_Invite_Confirm.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () {
              vm.clearInvite();
              context.goNamed('S00');
            },
          ),
          AppButton(
            text: t.S11_Invite_Confirm.buttons.confirm,
            type: AppButtonType.primary,
            isLoading: vm.isJoining,
            // 按鈕狀態由 VM 決定 (是否已選 Ghost)
            onPressed: vm.canConfirm
                ? () {
                    vm.confirmJoin(
                      onSuccess: (taskId) {
                        context
                            .goNamed('S13', pathParameters: {'taskId': taskId});
                      },
                      onError: (code) => _showErrorDialog(context, vm, code),
                    );
                  }
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // 純白背景
                  borderRadius: BorderRadius.circular(16), // 精緻圓角
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
                    _buildColumn(context, t.D03_TaskCreate_Confirm.label_name,
                        vm.taskName),
                    const SizedBox(height: 8),
                    _buildColumn(context, t.D03_TaskCreate_Confirm.label_period,
                        '${dateFormat.format(vm.startDate)} - ${dateFormat.format(vm.endDate)}'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- B. Ghost Selection (如果需要) ---
              if (vm.showGhostSelection) ...[
                SectionWrapper(
                    title: t.S11_Invite_Confirm.label_select_ghost,
                    children: [
                      ...vm.ghosts.map((ghost) {
                        final id = ghost['id'] as String;
                        final name = ghost['displayName'] as String;
                        final prepaid =
                            (ghost['prepaid'] as num?)?.toDouble() ?? 0.0;
                        final expense =
                            (ghost['expense'] as num?)?.toDouble() ?? 0.0;

                        final isSelected = vm.selectedGhostId == id;

                        return SelectionTile(
                          backgroundColor:
                              theme.colorScheme.surfaceContainerLow,
                          isSelectedBackgroundColor: theme.colorScheme.surface,
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
                                "${t.S11_Invite_Confirm.label_prepaid}: ${CurrencyConstants.formatAmount(prepaid, vm.baseCurrency.code)}",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.tertiary,
                                ),
                              ),
                              Text(
                                "${t.S11_Invite_Confirm.label_expense}: ${CurrencyConstants.formatAmount(expense, vm.baseCurrency.code)}",
                                style: theme.textTheme.bodySmall?.copyWith(
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
    );
  }

  Widget _buildColumn(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
