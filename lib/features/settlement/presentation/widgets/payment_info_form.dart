// 路徑: lib/features/settlement/presentation/widgets/payment_info_form.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_card.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/gen/strings.g.dart';

class PaymentInfoForm extends StatelessWidget {
  final PaymentInfoFormController controller;
  final Color? backgroundColor;
  final Color? isSelectedBackgroundColor;
  final FocusNode? bankNameFocusNode;
  final FocusNode? bankAccountFocusNode;
  final FocusNode Function(int)? getAppNameFocusNode;
  final FocusNode Function(int)? getAppLinkFocusNode;

  const PaymentInfoForm(
      {super.key,
      required this.controller,
      this.backgroundColor,
      this.isSelectedBackgroundColor,
      this.bankNameFocusNode,
      this.bankAccountFocusNode,
      this.getAppNameFocusNode,
      this.getAppLinkFocusNode});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // 1. Mode Selection
              SelectionCard(
                title: t.common.payment_info.mode.private,
                backgroundColor: backgroundColor,
                isSelectedBackgroundColor: isSelectedBackgroundColor,
                isSelected: controller.mode == PaymentMode.private,
                isRadio: true,
                onToggle: () => controller.setMode(PaymentMode.private),
                child: Text(
                  t.common.payment_info.description.private,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SelectionCard(
                title: t.common.payment_info.mode.public,
                backgroundColor: backgroundColor,
                isSelectedBackgroundColor: isSelectedBackgroundColor,
                isSelected: controller.mode == PaymentMode.specific,
                isRadio: true,
                onToggle: () => controller.setMode(PaymentMode.specific),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.common.payment_info.description.public,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // A. Cash
                    SelectionTile(
                      isSelected: controller.acceptCash,
                      isRadio: false,
                      // [修正] toggleAcceptCash 接受 bool?
                      onTap: () =>
                          controller.toggleAcceptCash(!controller.acceptCash),
                      title: t.common.payment_info.type.cash,
                    ),

                    const SizedBox(height: 8),

                    // B. Bank
                    SelectionCard(
                      title: t.common.payment_info.type.bank,
                      isSelected: controller.enableBank,
                      onToggle: () =>
                          controller.toggleEnableBank(!controller.enableBank),
                      isRadio: false,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              AppTextField(
                                controller: controller.bankNameCtrl,
                                focusNode: bankNameFocusNode,
                                labelText:
                                    t.common.payment_info.label.bank_name,
                                hintText: t.common.payment_info.hint.bank_name,
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: controller.bankAccountCtrl,
                                focusNode: bankAccountFocusNode,
                                labelText:
                                    t.common.payment_info.label.bank_account,
                                hintText:
                                    t.common.payment_info.hint.bank_account,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // C. Apps
                    SelectionCard(
                      title: t.common.payment_info.type.apps,
                      isSelected: controller.enableApps,
                      onToggle: () =>
                          controller.toggleEnableApps(!controller.enableApps),
                      isRadio: false,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          ...controller.appControllers
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final input = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            controller: input.nameCtrl,
                                            focusNode:
                                                getAppNameFocusNode!(index),
                                            labelText: t.common.payment_info
                                                .label.app_name,
                                            hintText: t.common.payment_info.hint
                                                .app_name,
                                            fillColor:
                                                colorScheme.surfaceContainerLow,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 12),
                                          child: InkWell(
                                            onTap: () =>
                                                controller.removeApp(index),
                                            child: Icon(Icons.close,
                                                color: colorScheme
                                                    .onSurfaceVariant),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    AppTextField(
                                      controller: input.linkCtrl,
                                      focusNode: getAppLinkFocusNode!(index),
                                      labelText:
                                          t.common.payment_info.label.app_link,
                                      hintText:
                                          t.common.payment_info.hint.app_link,
                                      fillColor:
                                          colorScheme.surfaceContainerLow,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: FilledButton(
                              onPressed: controller.addApp,
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.surface,
                                foregroundColor:
                                    theme.colorScheme.onSurfaceVariant,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
