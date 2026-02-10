import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/common_avatar.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart'; // 使用您上傳的元件
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/invite_repository.dart';
import 'package:iron_split/features/onboarding/presentation/dialogs/d02_invite_result_dialog.dart';
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
      )..init(inviteCode), // 初始化 VM
      child: const _S11Content(),
    );
  }
}

class _S11Content extends StatelessWidget {
  const _S11Content();

  void _showErrorDialog(BuildContext context, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => D02InviteResultDialog(
        errorCode: code,
        onConfirm: () => context.goNamed('S00'), // 失敗回首頁
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<S11InviteConfirmViewModel>();

    // 1. Loading
    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Init Error (例如無效代碼)
    if (vm.errorCode != null) {
      // 使用 PostFrameCallback 避免 build 期間彈窗
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorDialog(context, vm.errorCode!);
      });
      return const Scaffold();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S11_Invite_Confirm.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.goNamed('S00'), // 取消
        ),
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S11_Invite_Confirm.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => context.goNamed('S00'),
          ),
          AppButton(
            text: t.S11_Invite_Confirm.buttons.confirm,
            type: AppButtonType.primary,
            isLoading: vm.isJoining,
            // 按鈕狀態由 VM 決定 (是否已選 Ghost)
            onPressed: vm.canConfirm
                ? () {
                    vm.confirmJoin(
                      onSuccess: () {
                        // 成功後跳轉到 S10 (由 S10 決定下一步去哪)
                        // 或者直接去 Task Detail: context.go('/tasks/$taskId');
                        context.goNamed('S10');
                      },
                      onError: (code) => _showErrorDialog(context, code),
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
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  vm.taskName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- B. Ghost Selection (如果需要) ---
              if (vm.showGhostSelection) ...[
                Text(
                  t.S11_Invite_Confirm.label_select_ghost,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...vm.ghosts.map((ghost) {
                  final id = ghost['id'] as String;
                  final name = ghost['displayName'] as String;
                  final prepaid = (ghost['prepaid'] as num?)?.toDouble() ?? 0.0;
                  final expense = (ghost['expense'] as num?)?.toDouble() ?? 0.0;

                  final isSelected = vm.selectedGhostId == id;

                  return SelectionTile(
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
                          "${t.S11_Invite_Confirm.label_prepaid}: ${CurrencyConstants.formatAmount(prepaid, vm.currencyCode)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          "${t.S11_Invite_Confirm.label_expense}: ${CurrencyConstants.formatAmount(expense, vm.currencyCode)}",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
