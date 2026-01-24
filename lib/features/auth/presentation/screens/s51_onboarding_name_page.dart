import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: S51_Onboarding.Name (CSV Page 2)
/// 職責：輸入使用者顯示名稱 (Display Name)，並更新至 Firebase Auth Profile。
class S51OnboardingNamePage extends StatefulWidget {
  const S51OnboardingNamePage({super.key});

  @override
  State<S51OnboardingNamePage> createState() => _S51OnboardingNamePageState();
}

class _S51OnboardingNamePageState extends State<S51OnboardingNamePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;
  bool _isValid = false; // 控制按鈕是否啟用

  @override
  void initState() {
    super.initState();
    // 監聽輸入變化以更新按鈕狀態與計數器
    _nameController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final text = _nameController.text.trim();
    final isValidLength = text.isNotEmpty && text.length <= 10;

    // 簡單的控制字元檢查 (禁止不可見字元)
    final hasControlChars = text.contains(RegExp(r'[\x00-\x1F\x7F]'));

    setState(() {
      _isValid = isValidLength && !hasControlChars;
    });
  }

  Future<void> _handleSave() async {
    if (!_isValid) return;

    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // 更新 Firebase Auth Profile
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload(); // 確保本地資料更新
      }

      if (mounted) {
        // 設定完成，進入首頁 S02
        context.go('/tasks');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.common.error_prefix(message: e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S51_Onboarding_Name.title), // "名稱設定"
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 說明文字
              Text(
                t.S51_Onboarding_Name.description,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),

              // 輸入框 (CSV 規則：1-10字，顯示 Counter)
              TextField(
                controller: _nameController,
                maxLength: 10,
                enabled: !_isSaving,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                onSubmitted: (_) => _isValid ? _handleSave() : null,
                inputFormatters: [
                  // 禁止輸入控制字元
                  FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
                ],
                decoration: InputDecoration(
                  hintText: t.S51_Onboarding_Name.field_hint,
                  border: const OutlineInputBorder(),
                  // 自訂 Counter 顯示格式
                  counterText: t.S51_Onboarding_Name.field_counter(
                    current: _nameController.text.length,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                ),
              ),

              const Spacer(),

              // 底部按鈕
              SizedBox(
                height: 56,
                child: FilledButton(
                  // 如果不符合規則 (空白或過長)，按鈕 Disabled (onPressed = null)
                  onPressed: (_isValid && !_isSaving) ? _handleSave : null,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(t.S51_Onboarding_Name.action_next), // "設定完成"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
