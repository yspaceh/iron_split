import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/invite/application/pending_invite_provider.dart';

/// Page Key: S01_Onboarding.Name
/// 描述：使用者初始設定顯示名稱頁面。
class S01OnboardingNamePage extends StatefulWidget {
  const S01OnboardingNamePage({super.key});

  @override
  State<S01OnboardingNamePage> createState() => _S01OnboardingNamePageState();
}

class _S01OnboardingNamePageState extends State<S01OnboardingNamePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// 儲存名稱並執行導向邏輯
  Future<void> _handleNext() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      // 更新 Firebase 使用者名稱
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      if (mounted) {
        // 檢查是否有 15 分鐘內有效的中斷邀請
        final pendingCode = context.read<PendingInviteProvider>().pendingCode;

        if (pendingCode != null) {
          // 若有邀請碼，引導至 S04_Invite.Confirm
          context.go('/invite/confirm?code=$pendingCode');
        } else {
          // 無邀請則進入首頁 (聖經預定為 S02_Home.TaskList)
          context.go('/tasks');
        }
      }
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
    // 透過 Theme 獲取 M3 語義化色彩
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        // 驗收點 5：標題對齊
        title: Text(t.S01_Onboarding_Name.title),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // 輸入欄位：使用 M3 樣式
              TextField(
                controller: _nameController,
                autofocus: true,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: t.S01_Onboarding_Name.hint,
                  filled: true,
                  fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const Spacer(),
              // 下一步按鈕：樣式繼承自 AppTheme
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isProcessing || _nameController.text.trim().isEmpty)
                      ? null
                      : _handleNext,
                  child: _isProcessing
                      ? CircularProgressIndicator(color: colorScheme.onPrimary)
                      : Text(
                          t.S01_Onboarding_Name.next_btn,
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