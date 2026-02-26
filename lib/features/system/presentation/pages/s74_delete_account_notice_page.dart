import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/preferences_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s74_delete_account_notice_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/gen/strings.g.dart';

class S74DeleteAccountNoticePage extends StatelessWidget {
  const S74DeleteAccountNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S74DeleteAccountNoticeViewModel(
          authRepo: context.read<AuthRepository>(),
          prefsService: context.read<PreferencesService>())
        ..init(),
      child: const _S74Content(),
    );
  }
}

class _S74Content extends StatelessWidget {
  const _S74Content();

  Future<void> _handleDeleteAccount(
      BuildContext context, S74DeleteAccountNoticeViewModel vm) async {
    // 執行刪除
    try {
      await vm.deleteAccount();
      if (!context.mounted) return;
      context.goNamed('S00');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _showConfirmDialog(
      BuildContext context,
      S74DeleteAccountNoticeViewModel vm,
      Translations t,
      TextTheme textTheme,
      double finalLineHeight) {
    CommonAlertDialog.show(
      context,
      title: t.D13_DeleteAccount_Confirm.title,
      content: Text(
        t.D13_DeleteAccount_Confirm.content,
        style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.common.buttons.confirm,
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
    final textTheme = theme.textTheme;
    final vm = context.watch<S74DeleteAccountNoticeViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

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
            text: t.S74_DeleteAccount_Notice.buttons.delete_account,
            type: AppButtonType.primary,
            isLoading: vm.deleteStatus == LoadStatus.loading,
            onPressed: () =>
                _showConfirmDialog(context, vm, t, textTheme, finalLineHeight),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin, vertical: AppLayout.spaceL),
          child: Column(
            children: [
              Text(
                t.S74_DeleteAccount_Notice.content,
                style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
