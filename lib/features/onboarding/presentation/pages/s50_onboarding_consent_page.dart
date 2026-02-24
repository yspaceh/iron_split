import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/state_visual.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s50_onboarding_consent_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S50OnboardingConsentPage extends StatelessWidget {
  const S50OnboardingConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S50OnboardingConsentViewModel(
          authRepo: context.read<AuthRepository>()),
      child: const _S50Content(),
    );
  }
}

class _S50Content extends StatelessWidget {
  const _S50Content();

  Future<void> _handleAgree(
      BuildContext context, S50OnboardingConsentViewModel vm) async {
    try {
      await vm.agreeAndContinue();
      if (!context.mounted) return;
      context.pushNamed('S51');
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _redirectToPrivacy(BuildContext context) {
    context.pushNamed(
      'S71',
      extra: {'isTerms': false},
    );
  }

  void _redirectToTerms(BuildContext context) {
    context.pushNamed(
      'S71',
      extra: {'isTerms': false},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final vm = context.watch<S50OnboardingConsentViewModel>();

    // 定義連結文字的樣式 (使用 Primary Color 讓它看起來像連結)
    final linkStyle = textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline, // 可選：加底線更像連結
        decorationColor: colorScheme.primary,
        height: 1.5);

    // 定義一般文字樣式
    final normalStyle = textTheme.bodyMedium?.copyWith(height: 1.5);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S50_Onboarding_Consent.title),
        centerTitle: true,
      ),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S50_Onboarding_Consent.buttons.start,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StateVisual(
              assetPath: 'assets/images/iron/iron_image_intro.png',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: // 2. 條款文字區域 (RichText)
                      RichText(
                    textAlign: TextAlign.left, // 文字置中
                    text: TextSpan(
                      style: normalStyle,
                      children: [
                        // A. 前綴: "Read our "
                        TextSpan(text: t.S50_Onboarding_Consent.content.prefix),

                        // B. 連結: "Terms of Service"
                        TextSpan(
                          text: t.common.terms.label.terms,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _redirectToTerms(context),
                        ),

                        // C. 中間: " and "
                        TextSpan(text: t.common.terms.and),

                        // D. 連結: "Privacy Policy"
                        TextSpan(
                          text: t.common.terms.label.privacy,
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _redirectToPrivacy(context),
                        ),

                        // E. 後綴: ". Tap 'Agree' to accept."
                        TextSpan(text: t.S50_Onboarding_Consent.content.suffix),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
