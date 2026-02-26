// 路徑: lib/features/settlement/presentation/widgets/payment_info_form.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/models/payment_info_model.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/widgets/form/app_text_field.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_card.dart';
import 'package:iron_split/features/common/presentation/widgets/selection_tile.dart';
import 'package:iron_split/features/settlement/presentation/controllers/payment_info_form_controller.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

class PaymentInfoForm extends StatelessWidget {
  final PaymentInfoFormController controller;
  final Color? backgroundColor;
  final Color? isSelectedBackgroundColor;

  const PaymentInfoForm(
      {super.key,
      required this.controller,
      this.backgroundColor,
      this.isSelectedBackgroundColor});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final displayState = context.read<DisplayState>();
    final isEnlarged = displayState.isEnlarged;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppLayout.spaceL),
            // 1. Mode Selection
            SelectionCard(
              title: t.common.payment_info.mode.private,
              backgroundColor: backgroundColor,
              isSelectedBackgroundColor: isSelectedBackgroundColor,
              isSelected: controller.mode == PaymentMode.private,
              isRadio: true,
              onToggle: () => controller.setMode(PaymentMode.private),
              child: Text(
                t.common.payment_info.content.private,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            const SizedBox(height: AppLayout.spaceL),

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
                    t.common.payment_info.content.public,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppLayout.spaceL),
                  // A. Cash
                  SelectionTile(
                    isSelected: controller.acceptCash,
                    isRadio: false,
                    // [修正] toggleAcceptCash 接受 bool?
                    onTap: () =>
                        controller.toggleAcceptCash(!controller.acceptCash),
                    title: t.common.payment_info.type.cash,
                  ),

                  SizedBox(
                      height: isEnlarged ? AppLayout.spaceL : AppLayout.spaceS),

                  // B. Bank
                  SelectionCard(
                    title: t.common.payment_info.type.bank,
                    isSelected: controller.enableBank,
                    onToggle: () =>
                        controller.toggleEnableBank(!controller.enableBank),
                    isRadio: false,
                    child: Column(
                      children: [
                        SizedBox(
                            height: isEnlarged
                                ? AppLayout.spaceL
                                : AppLayout.spaceS),
                        Column(
                          children: [
                            AppTextField(
                              controller: controller.bankNameCtrl,
                              labelText: t.common.payment_info.label.bank_name,
                              hintText: t.common.payment_info.hint.bank_name,
                            ),
                            const SizedBox(height: AppLayout.spaceM),
                            AppTextField(
                              controller: controller.bankAccountCtrl,
                              labelText:
                                  t.common.payment_info.label.bank_account,
                              hintText: t.common.payment_info.hint.bank_account,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppLayout.spaceL),

                  // C. Apps
                  SelectionCard(
                    title: t.common.payment_info.type.apps,
                    isSelected: controller.enableApps,
                    onToggle: () =>
                        controller.toggleEnableApps(!controller.enableApps),
                    isRadio: false,
                    child: Column(
                      children: [
                        SizedBox(
                            height: isEnlarged
                                ? AppLayout.spaceL
                                : AppLayout.spaceS),
                        ...controller.appControllers
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final input = entry.value;
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppLayout.spaceM),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppLayout.spaceL,
                                  horizontal: AppLayout.spaceM),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius:
                                    BorderRadius.circular(AppLayout.radiusL),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          controller: input.nameCtrl,
                                          labelText: t.common.payment_info.label
                                              .app_name,
                                          hintText: t.common.payment_info.hint
                                              .app_name,
                                          fillColor:
                                              colorScheme.surfaceContainerLow,
                                        ),
                                      ),
                                      const SizedBox(width: AppLayout.spaceS),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: AppLayout.spaceXS,
                                            vertical: AppLayout.spaceM),
                                        child: InkWell(
                                          onTap: () =>
                                              controller.removeApp(index),
                                          child: Icon(Icons.close,
                                              size: AppLayout.iconSizeL,
                                              color:
                                                  colorScheme.onSurfaceVariant),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppLayout.spaceM),
                                  AppTextField(
                                    controller: input.linkCtrl,
                                    labelText:
                                        t.common.payment_info.label.app_link,
                                    hintText:
                                        t.common.payment_info.hint.app_link,
                                    fillColor: colorScheme.surfaceContainerLow,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            minHeight: 40,
                          ),
                          child: FilledButton(
                            onPressed: controller.addApp,
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.surface,
                              foregroundColor: colorScheme.onSurfaceVariant,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppLayout.radiusL),
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: AppLayout.iconSizeL,
                            ),
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
        );
      },
    );
  }
}
