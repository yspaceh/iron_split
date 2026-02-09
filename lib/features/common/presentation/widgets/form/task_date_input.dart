import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/common_wheel_picker.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';

class TaskDateInput extends StatelessWidget {
  const TaskDateInput({
    super.key,
    required this.label,
    required this.date,
    required this.onDateChanged,
    this.iconData,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onDateChanged;
  final IconData? iconData;

  void _showDatePicker(BuildContext context) {
    // 這裡不需要 tempDate，因為是 Stateless，每次開啟都是拿最新的 date
    DateTime tempDate = date;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        // 直接回傳給外部，不需要 setState
        onDateChanged(tempDate);
      },
      child: CupertinoDatePicker(
        // 確保 Picker 打開時是選中目前的 date
        initialDateTime: date,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          tempDate = DateTime(val.year, val.month, val.day);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('yyyy/MM/dd (E)', locale);

    return AppSelectField(
      labelText: label,
      // 直接使用外部傳入的 date，確保畫面永遠跟 ViewModel 同步
      text: dateFormat.format(date).toUpperCase(),
      // prefixIcon: iconData ?? Icons.calendar_today_outlined,
      onTap: () => _showDatePicker(context),
    );
  }
}
