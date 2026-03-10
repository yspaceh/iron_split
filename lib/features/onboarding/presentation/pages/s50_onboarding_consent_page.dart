import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/services/analytics_service.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/image_asset_wapper.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/presentation/viewmodels/s50_onboarding_consent_vm.dart';
import 'package:iron_split/gen/strings.g.dart';

class S50OnboardingConsentPage extends StatelessWidget {
  const S50OnboardingConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S50OnboardingConsentViewModel(
        authRepo: context.read<AuthRepository>(),
        service: OnboardingService(
          authRepo: context.read<AuthRepository>(),
          analyticsService: context.read<AnalyticsService>(),
        ),
      ),
      child: const _S50Content(),
    );
  }
}

class _S50Content extends StatefulWidget {
  const _S50Content();

  @override
  State<_S50Content> createState() => _S50ContentState();
}

class _S50ContentState extends State<_S50Content> {
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(
      BuildContext context, S50OnboardingConsentViewModel vm) async {
    try {
      await vm.submit();
      if (!context.mounted) return;
      context.goNamed('S10'); // 成功後直接導航到主畫面
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _redirectToPrivacy(BuildContext context) {
    context.pushNamed(
      'S71',
      extra: {'isTerms': false},
    );
  }

  void _redirectToTerms(BuildContext context) {
    context.pushNamed(
      'S71',
      extra: {'isTerms': true}, // [修正] 這裡原本是 false，已修正為 true
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vm = context.watch<S50OnboardingConsentViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    final linkStyle = textTheme.bodyMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
        height: finalLineHeight);

    final normalStyle = textTheme.bodyMedium?.copyWith(height: finalLineHeight);

    // 點擊空白處可收起鍵盤
    return AppKeyboardActionsWrapper(
      focusNodes: [_nameFocusNode],
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: AppLayout.spaceL, horizontal: horizontalMargin),
              color: colorScheme.surface,
              child: Text.rich(
                TextSpan(
                  style: normalStyle,
                  children: [
                    TextSpan(text: t.s50_onboarding_consent.agree.prefix),
                    TextSpan(
                      text: t.common.terms.label.terms,
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _redirectToTerms(context),
                    ),
                    TextSpan(text: t.common.terms.and),
                    TextSpan(
                      text: t.common.terms.label.privacy,
                      style: linkStyle,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _redirectToPrivacy(context),
                    ),
                    TextSpan(text: t.s50_onboarding_consent.agree.suffix),
                  ],
                ),
              ),
            ),
            StickyBottomActionBar(
              children: [
                AppButton(
                  text: t.s50_onboarding_consent.buttons
                      .start, // 或使用 t.common.buttons.done
                  type: AppButtonType.primary,
                  isLoading: vm.submitStatus == LoadStatus.loading,
                  // 必須輸入名字且格式正確才能點擊
                  onPressed:
                      (vm.isValid && vm.submitStatus != LoadStatus.loading)
                          ? () => _handleSubmit(context, vm)
                          : null,
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalMargin, vertical: AppLayout.spaceL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ImageAssetWrapper(
                        assetPath: 'assets/images/icons/iron_split_200.png',
                      ),
                      const SizedBox(height: AppLayout.spaceXL),
                      Center(
                        child: Text(
                          t.s50_onboarding_consent.content,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyLarge
                              ?.copyWith(height: finalLineHeight),
                        ),
                      ),
                      const SizedBox(height: AppLayout.spaceXL),
                      TaskNameInput(
                        focusNode: _nameFocusNode,
                        controller: vm.nameController,
                        maxLength: AppConstants.maxUserNameLength,
                        label: t.s50_onboarding_consent.label,
                        hint: t.s50_onboarding_consent.hint, // "例如：Iron Man"
                      ),
                    ],
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
