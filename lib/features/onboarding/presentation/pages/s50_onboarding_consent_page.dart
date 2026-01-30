import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s50_onboarding_consent_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S50OnboardingConsentPage extends StatelessWidget {
  const S50OnboardingConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S50OnboardingConsentViewModel(),
      child: const _S50View(),
    );
  }
}

class _S50View extends StatelessWidget {
  const _S50View();

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    // S50 是靜態頁面，主要負責顯示條款
    return Scaffold(
      appBar: AppBar(title: Text(t.S50_Onboarding_Consent.title)),
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
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                // 導航到下一頁 (S51)
                context.pushNamed('S51');
              },
              child: Text(t.S50_Onboarding_Consent.agree_btn),
            ),
          ],
        ),
      ),
    );
  }
}
