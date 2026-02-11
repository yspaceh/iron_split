import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';

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
    final dateFormat = DateFormat('yyyy/MM/dd');

    return CommonAlertDialog(
      title: t.D03_TaskCreate_Confirm.title,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(
                context, t.D03_TaskCreate_Confirm.label_name, taskName),
            const SizedBox(height: 16),
            _buildColumn(context, t.D03_TaskCreate_Confirm.label_period,
                '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}'),
            const SizedBox(height: 16),
            _buildColumn(context, t.D03_TaskCreate_Confirm.label_currency,
                baseCurrency.code),
            const SizedBox(height: 16),
            _buildColumn(context, t.D03_TaskCreate_Confirm.label_members,
                '$memberCount'),
          ],
        ),
      ),
      actions: [
        AppButton(
          text: t.D03_TaskCreate_Confirm.buttons.back,
          type: AppButtonType.secondary,
          onPressed: () => Navigator.pop(context, false),
        ),
        AppButton(
          text: t.D03_TaskCreate_Confirm.buttons.confirm,
          type: AppButtonType.primary,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}
