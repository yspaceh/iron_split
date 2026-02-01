import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/core/constants/currency_constants.dart';
import 'package:iron_split/gen/strings.g.dart';

/// Page Key: D03_TaskCreate.Confirm
/// 職責：單純顯示確認資訊，不處理業務邏輯
class D03TaskCreateConfirmDialog extends StatelessWidget {
  final String taskName;
  final DateTime startDate;
  final DateTime endDate;
  final CurrencyConstants baseCurrencyConstants;
  final int memberCount;

  const D03TaskCreateConfirmDialog({
    super.key,
    required this.taskName,
    required this.startDate,
    required this.endDate,
    required this.baseCurrencyConstants,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return AlertDialog(
      title: Text(t.D03_TaskCreate_Confirm.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline,
                    size: 32, color: theme.colorScheme.onSecondaryContainer),
              ),
            ),

            _buildRow(context, t.D03_TaskCreate_Confirm.label_name, taskName),
            const SizedBox(height: 8),
            _buildRow(context, t.D03_TaskCreate_Confirm.label_period,
                '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}'),
            const SizedBox(height: 8),
            _buildRow(context, t.D03_TaskCreate_Confirm.label_currency,
                baseCurrencyConstants.code),
            const SizedBox(height: 8),
            _buildRow(context, t.D03_TaskCreate_Confirm.label_members,
                '$memberCount'),
          ],
        ),
      ),
      actions: [
        // Secondary: 返回
        TextButton(
          onPressed: () => Navigator.pop(context, false), // 回傳 false
          child: Text(t.D03_TaskCreate_Confirm.buttons.back),
        ),
        // Primary: 確認
        FilledButton(
          onPressed: () => Navigator.pop(context, true), // 回傳 true
          child: Text(t.D03_TaskCreate_Confirm.buttons.confirm),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey)),
        ),
        Expanded(
          child: Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
