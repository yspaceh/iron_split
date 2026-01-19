import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:url_launcher/url_launcher.dart'; // 需確認 pubspec.yaml 有加 url_launcher

/// Page Key: S00_Onboarding.Consent (CSV Page 1)
/// 職責：顯示歡迎動畫與服務條款，同意後進行匿名登入。
class S00OnboardingConsentPage extends StatefulWidget {
  const S00OnboardingConsentPage({super.key});

  @override
  State<S00OnboardingConsentPage> createState() =>
      _S00OnboardingConsentPageState();
}

class _S00OnboardingConsentPageState extends State<S00OnboardingConsentPage> {
  bool _isLoading = false;

  Future<void> _handleStart() async {
    setState(() => _isLoading = true);
    try {
      // 1. 匿名登入 (Firebase Auth)
      await FirebaseAuth.instance.signInAnonymously();

      if (mounted) {
        // 2. 登入成功後，前往 S01 設定名稱
        context.go('/onboarding/name');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. 動畫區塊 (佔滿剩餘空間) ---
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO: 替換為實際的 Iron Rooster Animation (Lottie or Rive)
                    // CSV 描述：鐵公雞穿盔甲...面罩掉下來...推上去
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.security,
                          size: 80, color: colorScheme.onSecondaryContainer),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      t.S00_Onboarding_Consent.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. 底部條款與按鈕區 ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 服務條款 RichText
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                      children: [
                        TextSpan(text: t.S00_Onboarding_Consent.content_prefix),
                        // 服務條款連結
                        TextSpan(
                          text: t.S00_Onboarding_Consent.terms_link,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => context
                                .push('/settings/tos'), // 導向 App 內 TOS 頁面
                        ),
                        TextSpan(text: t.S00_Onboarding_Consent.and),
                        // 隱私政策連結
                        TextSpan(
                          text: t.S00_Onboarding_Consent.privacy_link,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _openUrl(
                                'https://example.com/privacy'), // 外部連結範例
                        ),
                        TextSpan(text: t.S00_Onboarding_Consent.content_suffix),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 開始按鈕
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _handleStart,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(t.S00_Onboarding_Consent.agree_btn),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
