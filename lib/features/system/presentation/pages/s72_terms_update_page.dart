import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/system/presentation/pages/s71_system_settings_terms_page.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s72_terms_update_vm.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

// Widgets
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/common/presentation/widgets/custom_sliding_segment.dart';

class S72TermsUpdatePage extends StatelessWidget {
  const S72TermsUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S72TermsUpdateViewModel(
        authRepo: context.read<AuthRepository>(),
        systemRepo: context.read<SystemRepository>(),
      )..init(),
      child: const _S72Content(),
    );
  }
}

class _S72Content extends StatefulWidget {
  const _S72Content();

  @override
  State<_S72Content> createState() => _S72ContentState();
}

class _S72ContentState extends State<_S72Content> {
  @override
  void dispose() {
    super.dispose();
  }

  void _handleSetTab(S72TermsUpdateViewModel vm, LegalTab tab) {
    vm.setTab(tab);
  }

  Future<void> _handleAgree(
      BuildContext context, S72TermsUpdateViewModel vm) async {
    try {
      await vm.agreeLatestTerms();
      if (!context.mounted) return;
      context.goNamed('S00');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleLogout(
      BuildContext context, S72TermsUpdateViewModel vm) async {
    try {
      await vm.logout();

      if (!context.mounted) return;
      context.pop();
      context.goNamed('S50');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _showDeclineDialog(BuildContext context, S72TermsUpdateViewModel vm) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    CommonAlertDialog.show(
      context,
      title: t.D12_logout_confirm.title,
      content: Text(
        t.D12_logout_confirm.content,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(),
        ),
        AppButton(
          text: t.D12_logout_confirm.buttons.logout,
          type: AppButtonType.primary,
          onPressed: () => _handleLogout(context, vm),
        ),
      ],
    );
  }

  bool _isTermsVisible(S72TermsUpdateViewModel vm) {
    if (vm.type == UpdateType.both) {
      return vm.currentTab == LegalTab.terms;
    }
    return vm.type == UpdateType.tosOnly;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S72TermsUpdateViewModel>();

    String getTitleTypeLabel(S72TermsUpdateViewModel vm) {
      switch (vm.type) {
        case UpdateType.privacyOnly:
          return t.common.terms.label.privacy;
        case UpdateType.both:
          return t.common.terms.label.both;
        default:
          return t.common.terms.label.terms;
      }
    }

    String getDescriptionTypeLabel(S72TermsUpdateViewModel vm) {
      switch (vm.type) {
        case UpdateType.privacyOnly:
          return t.common.terms.label.privacy;
        case UpdateType.both:
          return "${t.common.terms.label.terms}${t.common.terms.and}${t.common.terms.label.privacy}";
        default:
          return t.common.terms.label.terms;
      }
    }

    String title = t.S72_TermsUpdate.title(type: getTitleTypeLabel(vm));
    String description =
        t.S72_TermsUpdate.content(type: getDescriptionTypeLabel(vm));

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        bottomNavigationBar: StickyBottomActionBar(
          children: [
            // 不同意並登出
            AppButton(
              text: t.common.buttons.decline,
              type: AppButtonType.secondary,
              onPressed: () => _showDeclineDialog(context, vm),
            ),
            // 同意
            AppButton(
              text: t.common.buttons.agree,
              type: AppButtonType.primary,
              isLoading: vm.agreeStatus == LoadStatus.loading,
              onPressed: () => _handleAgree(context, vm),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(description),
                if (vm.type == UpdateType.both) ...[
                  const SizedBox(height: 8),
                  CustomSlidingSegment<LegalTab>(
                    selectedValue: vm.currentTab,
                    segments: {
                      LegalTab.terms: t.common.terms.label.terms,
                      LegalTab.privacy: t.common.terms.label.privacy,
                    },
                    onValueChanged: (tab) => _handleSetTab(vm, tab),
                  ),
                ],
                const SizedBox(height: 8),
                Expanded(
                  child: S71SettingsTermsPage(
                    isTerms: _isTermsVisible(vm),
                    isEmbedded: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
