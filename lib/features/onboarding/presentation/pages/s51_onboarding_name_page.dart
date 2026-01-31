import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s51_onboarding_name_vm.dart';

class S51OnboardingNamePage extends StatelessWidget {
  const S51OnboardingNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注入 VM
    return ChangeNotifierProvider(
      create: (_) => S51OnboardingNameViewModel(
        service: OnboardingService(authRepo: AuthRepository()),
      ),
      child: const _S51Content(),
    );
  }
}

class _S51Content extends StatefulWidget {
  const _S51Content();

  @override
  State<_S51Content> createState() => _S51ContentState();
}

class _S51ContentState extends State<_S51Content> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S51OnboardingNameViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(t.S51_Onboarding_Name.title)), // "怎麼稱呼您？"
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                t.S51_Onboarding_Name.description, // "請輸入您在分帳時顯示的名稱..."
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _controller,
                enabled: !vm.isSaving,
                maxLength: 10,
                // 連結 VM
                onChanged: vm.onNameChanged,
                onSubmitted: (_) => _submit(context, vm),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[\x00-\x1F\x7F]')),
                ],
                decoration: InputDecoration(
                  hintText: t.S51_Onboarding_Name.field_hint, // "例如：Iron Man"
                  counterText: t.S51_Onboarding_Name.field_counter(
                      current: vm.currentLength),
                  border: const OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: (vm.isValid && !vm.isSaving)
                      ? () => _submit(context, vm)
                      : null,
                  child: vm.isSaving
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

  void _submit(BuildContext context, S51OnboardingNameViewModel vm) {
    vm.saveName(
      onSuccess: () => context.pushNamed('S10'), // 假設下個頁面是任務列表
      onError: (msg) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg))),
    );
  }
}
