// lib/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_error_codes.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/core/utils/error_mapper.dart';
import 'package:iron_split/features/common/presentation/view/common_state_view.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_keyboard_actions_wrapper.dart';
import 'package:iron_split/features/onboarding/data/auth_repository.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
import 'package:iron_split/features/system/data/system_repository.dart';
import 'package:iron_split/features/system/presentation/viewmodels/s73_system_settings_payment_info_vm.dart';
import 'package:provider/provider.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/features/common/presentation/widgets/sticky_bottom_action_bar.dart';

class S73SystemSettingsPaymentInfoPage extends StatelessWidget {
  const S73SystemSettingsPaymentInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => S73SystemSettingsPaymentInfoViewModel(
        authRepo: context.read<AuthRepository>(),
        systemRepo: context.read<SystemRepository>(),
      )..init(),
      child: const _S73Content(),
    );
  }
}

class _S73Content extends StatefulWidget {
  const _S73Content();

  @override
  State<_S73Content> createState() => _S73ContentState();
}

class _S73ContentState extends State<_S73Content> {
  // 1. 靜態欄位 Node
  late FocusNode _bankNameNode;
  late FocusNode _bankAccountNode;
  final Map<int, FocusNode> _appNameNodes = {};
  final Map<int, FocusNode> _appLinkNodes = {};
  @override
  void initState() {
    super.initState();
    _bankNameNode = FocusNode();
    _bankAccountNode = FocusNode();
  }

  @override
  void dispose() {
    _bankNameNode.dispose();
    _bankAccountNode.dispose();
    for (var node in _appNameNodes.values) {
      node.dispose();
    }
    for (var node in _appLinkNodes.values) {
      node.dispose();
    }
    super.dispose();
  }

  // 取得動態 Node 的 Helper
  FocusNode _getAppLinkNode(int index) {
    return _appLinkNodes.putIfAbsent(index, () => FocusNode());
  }

  FocusNode _getAppNameNode(int index) {
    return _appNameNodes.putIfAbsent(index, () => FocusNode());
  }

  Future<void> _handleSave(
      BuildContext context, S73SystemSettingsPaymentInfoViewModel vm) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      vm.save();
      if (!context.mounted) return;
      AppToast.showSuccess(context, t.success.saved);
      context.pop();
    } on AppErrorCodes catch (code) {
      if (!context.mounted) return;
      final msg = ErrorMapper.map(context, code: code);
      AppToast.showError(context, msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = context.watch<S73SystemSettingsPaymentInfoViewModel>();
    final isEnlarged = context.watch<DisplayState>().isEnlarged;
    final double horizontalMargin = AppLayout.pageMargin(isEnlarged);

    final allNodes = [
      _bankNameNode,
      _bankAccountNode,
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppNameNode(i)),
      ...List.generate(
          vm.formController.appControllers.length, (i) => _getAppLinkNode(i)),
    ];

    final title = t.S70_System_Settings.menu.payment_info;

    return CommonStateView(
      status: vm.initStatus,
      errorCode: vm.initErrorCode,
      title: title,
      child: AppKeyboardActionsWrapper(
        focusNodes: allNodes,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Column(
                children: [
                  PaymentInfoForm(
                    controller: vm.formController,
                    isSelectedBackgroundColor: colorScheme.surface,
                    backgroundColor: colorScheme.surfaceContainerLow,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          bottomNavigationBar: StickyBottomActionBar(
            children: [
              AppButton(
                text: t.common.buttons.back,
                type: AppButtonType.secondary,
                onPressed: () => context.pop(),
              ),
              AppButton(
                text: t.common.buttons.save,
                type: AppButtonType.primary,
                onPressed: () => _handleSave(context, vm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
