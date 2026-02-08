import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
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
    // S50 是靜態頁面，主要負責顯示條款
    return Scaffold(
      appBar: AppBar(title: Text(t.S50_Onboarding_Consent.title)),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.S50_Onboarding_Consent.buttons.agree,
            type: AppButtonType.primary,
            onPressed: () => context.pushNamed('S51'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 之後要替換成圖片或動畫
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.amber,
            ),
            // TODO: 這裡要放條款連結
            Text(t.S50_Onboarding_Consent.content_prefix), // 這裡未來接 i18n
          ],
        ),
      ),
    );
  }
}
