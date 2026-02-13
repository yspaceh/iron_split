// lib/features/settlement/presentation/pages/s31_settlement_payment_info_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/widgets/app_toast.dart';
import 'package:iron_split/features/settlement/presentation/widgets/payment_info_form.dart';
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
      create: (_) => S73SystemSettingsPaymentInfoViewModel()..init(),
      child: const _S73Content(),
    );
  }
}

class _S73Content extends StatelessWidget {
  const _S73Content();
  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final vm = context.watch<S73SystemSettingsPaymentInfoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(t.S70_System_Settings.menu.payment_info),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
            onPressed: () {
              // 收起鍵盤
              FocusScope.of(context).unfocus();

              // [修正] 呼叫 VM 的 save 方法，而不是傳遞 undefined 的 info
              vm.save(() {
                // 成功後顯示提示並返回
                if (context.mounted) {
                  AppToast.showSuccess(context, t.success.saved);
                  context.pop();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
