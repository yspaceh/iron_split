import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:provider/provider.dart';

class D10RecordDeleteConfirmDialog extends StatelessWidget {
  final String recordTitle;
  final CurrencyConstants currency;
  final double amount;

  const D10RecordDeleteConfirmDialog({
    super.key,
    required this.recordTitle,
    required this.currency,
    required this.amount,
  });

  static Future<T?> show<T>(BuildContext context,
      {required String recordTitle,
      required CurrencyConstants currency,
      required double amount}) {
    return showDialog(
      context: context,
      builder: (context) => D10RecordDeleteConfirmDialog(
          recordTitle: recordTitle, currency: currency, amount: amount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );

    return CommonAlertDialog(
        title: t.D10_RecordDelete_Confirm.title,
        content: Text(
          t.D10_RecordDelete_Confirm.content(
              title: recordTitle,
              amount:
                  "${currency.symbol} ${CurrencyConstants.formatAmount(amount, currency.code)}"),
          style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
        ),
        actions: [
          AppButton(
            text: t.common.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(false),
          ),
          AppButton(
            text: t.common.buttons.delete,
            type: AppButtonType.primary,
            onPressed: () => context.pop(true),
          ),
        ]);
  }
}
