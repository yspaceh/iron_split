import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/state_visual.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s50_onboarding_consent_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S50OnboardingConsentPage extends StatelessWidget {
  const S50OnboardingConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S50OnboardingConsentViewModel(),
      child: const _S50Content(),
    );
  }
}

class _S50Content extends StatelessWidget {
  const _S50Content();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);

    final vm = context.watch<S50OnboardingConsentViewModel>();

    // 定義連結文字的樣式 (使用 Primary Color 讓它看起來像連結)
    final linkStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline, // 可選：加底線更像連結
      decorationColor: theme.colorScheme.primary,
    );

    // 定義一般文字樣式
    final normalStyle = theme.textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(title: Text(t.S50_Onboarding_Consent.title)),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S50_Onboarding_Consent.buttons.agree,
            type: AppButtonType.primary,
            onPressed: vm.isLoading
                ? null
                : () {
                    // [修改] 改為呼叫 VM 方法
                    vm.agreeAndContinue(
                      onSuccess: () => context.pushNamed('S51'),
                      onError: (msg) {
                        AppToast.showError(context, msg);
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //TODO: 要準備放在這的圖片
            const StateVisual(),
            Padding(
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
                        ..onTap = () {
                          context.pushNamed(
                            'S71',
                            extra: {'isTerms': true},
                          );
                        },
                    ),

                    // C. 中間: " and "
                    TextSpan(text: t.common.terms.and),

                    // D. 連結: "Privacy Policy"
                    TextSpan(
                      text: t.common.terms.label.privacy,
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.pushNamed(
                            'S71',
                            extra: {'isTerms': false},
                          );
                        },
                    ),

                    // E. 後綴: ". Tap 'Agree' to accept."
                    TextSpan(text: t.S50_Onboarding_Consent.content.suffix),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
