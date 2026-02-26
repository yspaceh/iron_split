import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iron_split/features/common/presentation/dialogs/common_alert_dialog.dart';
import 'package:iron_split/features/common/presentation/widgets/app_button.dart';
import 'package:iron_split/gen/strings.g.dart';

class D14DateSelectDialog extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime selectedDate;

  const D14DateSelectDialog({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.selectedDate,
  });

  static Future<T?> show<T>(BuildContext context,
      {required DateTime startDate,
      required DateTime endDate,
      required DateTime selectedDate}) {
    return showDialog(
      context: context,
      builder: (context) => D14DateSelectDialog(
          startDate: startDate, endDate: endDate, selectedDate: selectedDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime tempSelectedDate = selectedDate;

    return CommonAlertDialog(
        title: t.D14_Date_Select.title,
        content: SizedBox(
          width: double.maxFinite,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler:
                  MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
            ),
            child: CalendarDatePicker(
              initialDate: tempSelectedDate,
              firstDate: startDate.subtract(const Duration(days: 365)),
              lastDate: endDate.add(const Duration(days: 365)),
              onDateChanged: (DateTime date) {
                tempSelectedDate = date;
              },
            ),
          ),
        ),
        actions: [
          AppButton(
            text: t.common.buttons.cancel,
            type: AppButtonType.secondary,
            onPressed: () => context.pop(),
          ),
          AppButton(
            text: t.common.buttons.ok,
            type: AppButtonType.primary,
            onPressed: () => context.pop(tempSelectedDate),
          ),
        ]);
  }
}
