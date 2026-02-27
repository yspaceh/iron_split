import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/theme/app_layout.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';
import 'package:provider/provider.dart';

/// Page Key: D03_TaskCreate.Confirm
/// 職責：單純顯示確認資訊，不處理業務邏輯
class D03TaskCreateConfirmDialog extends StatelessWidget {
  final String taskName;
  final DateTime startDate;
  final DateTime endDate;
  final CurrencyConstants baseCurrency;
  final int memberCount;

  const D03TaskCreateConfirmDialog({
    super.key,
    required this.taskName,
    required this.startDate,
    required this.endDate,
    required this.baseCurrency,
    required this.memberCount,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String taskName,
    required DateTime startDate,
    required DateTime endDate,
    required CurrencyConstants baseCurrency,
    required int memberCount,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => D03TaskCreateConfirmDialog(
        taskName: taskName,
        startDate: startDate,
        endDate: endDate,
        baseCurrency: baseCurrency,
        memberCount: memberCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dateFormat = DateFormat('yyyy/MM/dd');
    final displayState = context.watch<DisplayState>();
    final isEnlarged = displayState.isEnlarged;
    const double componentBaseHeight = 1.5;
    final double finalLineHeight = AppLayout.dynamicLineHeight(
      componentBaseHeight,
      isEnlarged,
    );

    return CommonAlertDialog(
      title: t.d03_task_create_confirm.title,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(context, t.common.label.task_name, taskName,
                colorScheme, textTheme, finalLineHeight),
            const SizedBox(height: AppLayout.spaceL),
            _buildColumn(
                context,
                t.common.label.period,
                '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
                colorScheme,
                textTheme,
                finalLineHeight),
            const SizedBox(height: AppLayout.spaceL),
            _buildColumn(context, t.common.label.currency, baseCurrency.code,
                colorScheme, textTheme, finalLineHeight),
            const SizedBox(height: AppLayout.spaceL),
            _buildColumn(context, t.common.label.member_count, '$memberCount',
                colorScheme, textTheme, finalLineHeight),
          ],
        ),
      ),
      actions: [
        AppButton(
          text: t.d03_task_create_confirm.buttons.back_edit,
          type: AppButtonType.secondary,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          text: t.common.buttons.confirm,
          type: AppButtonType.primary,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, String label, String value,
      ColorScheme colorScheme, TextTheme textTheme, double finalLineHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(height: finalLineHeight),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
