import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s74_delete_account_notice_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

class S74DeleteAccountNoticePage extends StatelessWidget {
  const S74DeleteAccountNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S74DeleteAccountNoticeViewModel(),
      child: const _S74Content(),
    );
  }
}

class _S74Content extends StatelessWidget {
  const _S74Content();

  Future<void> _handleDeleteAccount(
      BuildContext context, S74DeleteAccountNoticeViewModel vm) async {
    // 執行刪除
    final success = await vm.deleteAccount();

    if (!context.mounted) return;

    if (success) {
      // 成功後，跳轉回歡迎頁面 (S00)
      // 使用 go (replace) 避免使用者按上一頁回到這裡
      context.goNamed('S00');
    } else {
      // 失敗提示
      // TODO:  update error
      AppToast.showError(context, "Delete account failed. Please try again.");
    }
  }

  void _showConfirmDialog(
      BuildContext context, S74DeleteAccountNoticeViewModel vm) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    CommonAlertDialog.show(
      context,
      title: t.D13_DeleteAccount_Confirm.title,
      content: Text(
        t.D13_DeleteAccount_Confirm.content,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.D13_DeleteAccount_Confirm.buttons.confirm,
          type: AppButtonType.primary,
          onPressed: () {
            context.pop(); // 關閉 Dialog
            _handleDeleteAccount(context, vm); // 執行刪除
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S74DeleteAccountNoticeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S74_DeleteAccount_Notice.title),
        centerTitle: true,
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.common.buttons.back,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          AppButton(
            text: t.S74_DeleteAccount_Notice.buttons.delete,
            type: AppButtonType.primary,
            isLoading: vm.isProcessing,
            onPressed: () => _showConfirmDialog(context, vm),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            children: [
              Text(
                t.S74_DeleteAccount_Notice.content,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
