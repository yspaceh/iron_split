import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
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
      create: (_) => S72TermsUpdateViewModel()..checkUpdateType(),
      child: const _S72Content(),
    );
  }
}

class _S72Content extends StatelessWidget {
  const _S72Content();

  // [新增] 顯示登出確認對話框
  Future<void> _showDeclineDialog(BuildContext context) async {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    final shouldLogout = await CommonAlertDialog.show<bool>(
      context,
      title: t.D12_logout_confirm.title,
      content: Text(
        t.D12_logout_confirm.description,
        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      ),
      actions: [
        AppButton(
          text: t.common.buttons.cancel,
          type: AppButtonType.secondary,
          onPressed: () => context.pop(false),
        ),
        AppButton(
          text: t.D12_logout_confirm.buttons.logout,
          type: AppButtonType.primary,
          onPressed: () => context.pop(true),
        ),
      ],
    );

    if (shouldLogout == true && context.mounted) {
      // 1. 執行登出
      await FirebaseAuth.instance.signOut();

      // 2. 導回 S50 (Onboarding)
      // 使用 go 而不是 push，清除導航堆疊
      if (context.mounted) context.goNamed('S50');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S72TermsUpdateViewModel>();
    final theme = Theme.of(context);

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
        t.S72_TermsUpdate.description(type: getDescriptionTypeLabel(vm));

    if (vm.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          // 不同意並登出
          AppButton(
            text: t.S72_TermsUpdate.buttons.decline,
            type: AppButtonType.secondary,
            onPressed: () => _showDeclineDialog(context),
          ),
          // 同意
          AppButton(
            text: t.S72_TermsUpdate.buttons.agree,
            type: AppButtonType.primary,
            isLoading: vm.isAgreed,
            onPressed: vm.isAgreed
                ? null
                : () {
                    vm.agreeLatestTerms(
                      onSuccess: () {
                        context.goNamed('S00');
                      },
                    );
                  },
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
                  onValueChanged: (tab) {
                    vm.setTab(tab);
                  },
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
    );
  }

  bool _isTermsVisible(S72TermsUpdateViewModel vm) {
    if (vm.type == UpdateType.both) {
      return vm.currentTab == LegalTab.terms;
    }
    return vm.type == UpdateType.tosOnly;
  }
}
