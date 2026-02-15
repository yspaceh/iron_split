import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart'; //
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
          service: OnboardingService(authRepo: context.read<AuthRepository>()),
          authRepo: context.read<AuthRepository>())
        ..init(),
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
  late S51OnboardingNameViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = context.read<S51OnboardingNameViewModel>();
    _vm.init();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    // 安全讀取 VM 並更新狀態
    context.read<S51OnboardingNameViewModel>().onNameChanged(_controller.text);
  }

  Future<void> _submit(
      BuildContext context, S51OnboardingNameViewModel vm) async {
    try {
      await vm.saveName();
      if (!context.mounted) return;
      context.goNamed('S10');
    } on AppErrorCodes catch (code) {
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final vm = context.watch<S51OnboardingNameViewModel>();
    final title = t.S51_Onboarding_Name.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      errorActionText: t.common.buttons.back,
      onErrorAction: vm.init,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.S51_Onboarding_Name.title),
          centerTitle: true,
        ),
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
              isLoading: vm.submitStatus == LoadStatus.loading,
              onPressed: () =>
                  (vm.isValid && vm.submitStatus != LoadStatus.loading)
                      ? _submit(context, vm)
                      : null,
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
                Text(
                  t.S51_Onboarding_Name.description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
                TaskNameInput(
                  controller: _controller,
                  maxLength: 10,
                  label: t.S51_Onboarding_Name.title,
                  hint: t.S51_Onboarding_Name.hint, // "例如：Iron Man"
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
