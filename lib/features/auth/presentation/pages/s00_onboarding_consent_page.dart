import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S00_Onboarding.Consent
/// 實作行內 RichText 連結，提升 UI 整合度
class S00OnboardingConsentPage extends StatefulWidget {
  const S00OnboardingConsentPage({super.key});

  @override
  State<S00OnboardingConsentPage> createState() => _S00OnboardingConsentPageState();
}

class _S00OnboardingConsentPageState extends State<S00OnboardingConsentPage> {
  bool _isProcessing = false;
  
  // 建立手勢辨識器用於處理文字內的點擊
  late TapGestureRecognizer _tosRecognizer;

  @override
  void initState() {
    super.initState();
    _tosRecognizer = TapGestureRecognizer()..onTap = _handleOpenTos;
  }

  @override
  void dispose() {
    // 專業開發：必須銷毀手勢辨識器以避免記憶體洩漏
    _tosRecognizer.dispose();
    super.dispose();
  }

  void _handleOpenTos() {
    context.push('/settings/tos'); // 跳轉至 S19
  }

  Future<void> _handleAccept() async {
    setState(() => _isProcessing = true);
    try {
      await FirebaseAuth.instance.signInAnonymously();
      if (mounted) context.go('/onboarding/name');
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.error.unknown.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              const Spacer(),
              Icon(Icons.gavel_rounded, size: 80, color: colorScheme.primary),
              const SizedBox(height: 32),
              
              Text(
                t.S00_Onboarding_Consent.title,
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // 使用 Text.rich 實作行內文字連結
              Text.rich(
                TextSpan(
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5, // 增加行高提升易讀性
                  ),
                  children: [
                    TextSpan(text: t.S00_Onboarding_Consent.content_prefix),
                    TextSpan(
                      text: t.S19_Settings_Tos.title,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: _tosRecognizer, // 綁定點擊手勢
                    ),
                    TextSpan(text: t.S00_Onboarding_Consent.content_suffix),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // 底部主按鈕
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleAccept,
                  child: _isProcessing
                      ? CircularProgressIndicator(color: colorScheme.onPrimary)
                      : Text(
                          t.S00_Onboarding_Consent.agree_btn,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}