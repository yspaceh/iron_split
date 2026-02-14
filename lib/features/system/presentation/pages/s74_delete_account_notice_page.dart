import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/preferences_service.dart';
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

class _S74Content extends StatefulWidget {
  const _S74Content();

  @override
  State<_S74Content> createState() => _S74ContentState();
}

class _S74ContentState extends State<_S74Content> {
  late S74DeleteAccountNoticeViewModel _vm;
  @override
  void initState() {
    super.initState();
    _vm = context.read<S74DeleteAccountNoticeViewModel>();
    _vm.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _onStateChanged();
    });
  }

  @override
  void dispose() {
    _vm.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    // 處理自動導航 (如未登入)
    if (_vm.initErrorCode == AppErrorCodes.unauthorized) {
      context.goNamed('S00');
    }
  }

  Future<void> _handleDeleteAccount(
      BuildContext context, S74DeleteAccountNoticeViewModel vm) async {
    // 執行刪除
    try {
      await vm.deleteAccount();
      if (!context.mounted) return;
      context.goNamed('S00');
    } on AppErrorCodes catch (code) {
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
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
            isLoading: vm.deleteStatus == LoadStatus.loading,
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
