import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/app_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/core/viewmodels/display_vm.dart';
import 'package:iron_split/core/viewmodels/locale_vm.dart';
import 'package:iron_split/core/viewmodels/theme_vm.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_display_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_theme_input.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/features/onboarding/application/onboarding_service.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_language_input.dart';
import 'package:iron_split/features/common/presentation/widgets/form/task_name_input.dart';
import 'package:iron_split/features/common/presentation/widgets/nav_title.dart';
import 'package:iron_split/features/common/presentation/widgets/section_wrapper.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s70_system_settings_vm.dart';

/// S70_System.Settings
class S70SystemSettingsPage extends StatelessWidget {
  const S70SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 提供 VM
    return ChangeNotifierProvider(
      create: (context) => S70SystemSettingsViewModel(
        onboardingService: context.read<OnboardingService>(),
        authRepo: context.read<AuthRepository>(),
        systemRepo: context.read<SystemRepository>(),
        initialName: '',
      )..init(),
      child: const _S70Content(),
    );
  }
}

class _S70Content extends StatefulWidget {
  const _S70Content();

  @override
  State<_S70Content> createState() => _S70ContentState();
}

class _S70ContentState extends State<_S70Content> {
  late S70SystemSettingsViewModel _vm;
  final FocusNode _nameFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _vm = context.read<S70SystemSettingsViewModel>();

    _nameFocusNode.addListener(() async {
      if (!_nameFocusNode.hasFocus) {
        try {
          await _vm.updateName();
          if (!mounted) return;
          AppToast.showSuccess(context, t.success.saved);
        } on AppErrorCodes catch (code) {
          final msg = ErrorMapper.map(context, code: code);
          AppToast.showError(context, msg);
        }
      }
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateLanguage(BuildContext context,
      LocaleViewModel localeVm, AppLocale newLocale) async {
    try {
      await localeVm.updateLanguage(newLocale);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleUpdateTheme(
      BuildContext context, ThemeViewModel themeVm, ThemeMode newTheme) async {
    try {
      await themeVm.setThemeMode(newTheme);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  Future<void> _handleUpdateDisplay(BuildContext context,
      DisplayViewModel displayVm, DisplayMode newDisplay) async {
    try {
      await displayVm.setDisplayMode(newDisplay);
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  void _redirectToPaymentInfo(BuildContext context) {
    context.pushNamed('S73');
  }

  void _redirectToDeleteAccount(BuildContext context) {
    context.pushNamed('S74');
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
      extra: {'isTerms': false},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final vm = context.watch<S70SystemSettingsViewModel>();
    final displayStatus = context.watch<DisplayState>();
    final isEnlarged = displayStatus.isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);
    final themeVm = context.watch<ThemeViewModel>();
    final displayVm = context.watch<DisplayViewModel>();
    final localeVm = context.watch<LocaleViewModel>();
    final title = t.S70_System_Settings.title;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title), // 或 t.S70_System_Settings.title
          centerTitle: true,
        ),
        // 點擊空白處收起鍵盤 (這會觸發 FocusNode 的 listener -> updateName)
        body: AppKeyboardActionsWrapper(
          focusNodes: [_nameFocusNode],
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
            children: [
              SectionWrapper(
                title: t.S70_System_Settings.section.basic,
                children: [
                  // 顯示名稱
                  TaskNameInput(
                    controller: vm.nameController,
                    focusNode: _nameFocusNode,
                    label: t.S70_System_Settings.menu.user_name,
                    hint: t.S51_Onboarding_Name.hint,
                    maxLength: AppConstants.maxUserNameLength,
                  ),
                  SizedBox(
                      height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                  // 收款資料
                  NavTile(
                    title: t.S70_System_Settings.menu.payment_info,
                    onTap: () => _redirectToPaymentInfo(context),
                  ),
                  SizedBox(
                      height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                  // 語言設定
                  TaskLanguageInput(
                    language: localeVm.currentLocale,
                    onLanguageChanged: (newLocale) =>
                        _handleUpdateLanguage(context, localeVm, newLocale),
                  ),
                  SizedBox(
                      height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                  // 深淺模式
                  TaskThemeInput(
                    theme: themeVm.themeMode,
                    onThemeChanged: (newTheme) =>
                        _handleUpdateTheme(context, themeVm, newTheme),
                  ),
                  SizedBox(
                      height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),
                  // 深淺模式
                  TaskDisplayInput(
                    display: displayVm.displayMode,
                    onDisplayChanged: (newDisplay) =>
                        _handleUpdateDisplay(context, displayVm, newDisplay),
                  ),
                ],
              ),
              const SizedBox(height: AppLayout.spaceL),
              SectionWrapper(
                  title: t.S70_System_Settings.section.legal,
                  children: [
                    NavTile(
                      title: t.S70_System_Settings.menu.terms,
                      onTap: () => _redirectToTerms(context),
                    ),
                    const SizedBox(height: AppLayout.spaceS),
                    NavTile(
                      title: t.S70_System_Settings.menu.privacy,
                      onTap: () => _redirectToPrivacy(context),
                    ),
                  ]),
              const SizedBox(height: AppLayout.spaceL),
              SectionWrapper(
                  title: t.S70_System_Settings.section.account,
                  children: [
                    NavTile(
                      title: t.S70_System_Settings.menu.delete_account,
                      isDestructive: true,
                      onTap: () => _redirectToDeleteAccount(context),
                    ),
                  ]),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
