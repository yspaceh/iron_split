import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart'; // [新增]
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s51_onboarding_name_vm.dart';

class S51OnboardingNamePage extends StatelessWidget {
  const S51OnboardingNamePage({super.key});

  @override
  Widget build(BuildContext context) {
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
  void initState() {
    super.initState();
    // 監聽文字變動並同步給 VM
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // 安全讀取 VM 並更新狀態
    context.read<S51OnboardingNameViewModel>().onNameChanged(_controller.text);
  }

  void _submit(BuildContext context, S51OnboardingNameViewModel vm) {
    vm.saveName(
      onSuccess: () => context.pushNamed('S10'), // 假設下個頁面是任務列表
      onError: (msg) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg))),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S51OnboardingNameViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(t.S51_Onboarding_Name.title)),
      bottomNavigationBar: StickyBottomActionBar(
        children: [
          AppButton(
            text: t.common.buttons.back,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          AppButton(
            text: t.S51_Onboarding_Name.buttons.next,
            type: AppButtonType.primary,
            isLoading: vm.isSaving,
            onPressed: (vm.isValid && !vm.isSaving)
                ? () => _submit(context, vm)
                : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(t.S51_Onboarding_Name.description),
              const SizedBox(height: 24),
              TaskNameInput(
                controller: _controller,
                maxLength: 10,
                label: t.S51_Onboarding_Name.title,
                placeholder: t.S51_Onboarding_Name.field_hint, // "例如：Iron Man"
              ),
            ],
          ),
        ),
      ),
    );
  }
}
