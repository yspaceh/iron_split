import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskDateRangeInput extends StatefulWidget {
  const TaskDateRangeInput({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartDateChanged;
  final ValueChanged<DateTime> onEndDateChanged;

  @override
  State<TaskDateRangeInput> createState() => _TaskDateRangeInputState();
}

class _TaskDateRangeInputState extends State<TaskDateRangeInput> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  // 邏輯保持不變
  void _showStartDatePicker() {
    DateTime tempDate = _startDate;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        setState(() {
          _startDate = tempDate;
          widget.onStartDateChanged(_startDate);
          // 連動檢查
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
            widget.onEndDateChanged(_endDate);
          }
        });
      },
      child: CupertinoDatePicker(
        initialDateTime: _startDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          tempDate = DateTime(val.year, val.month, val.day);
        },
      ),
    );
  }

  void _showEndDatePicker() {
    DateTime tempDate = _endDate;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        setState(() {
          _endDate = tempDate;
          widget.onEndDateChanged(_endDate);
        });
      },
      child: CupertinoDatePicker(
        initialDateTime: _endDate,
        minimumDate: _startDate,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          tempDate = DateTime(val.year, val.month, val.day);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 建議：加上星期 (E) 讓資訊更清楚，例如 "2024/02/06 (Tue)"
    final dateFormat = DateFormat('yyyy/MM/dd (E)');

    return Column(
      children: [
        // 1. 開始日期
        AppSelectField(
          labelText: t.S16_TaskCreate_Edit.field_start_date,
          text: dateFormat.format(_startDate),
          // 使用 Outlined Icon 更精緻
          prefixIcon: Icons.calendar_today_outlined,
          onTap: _showStartDatePicker,
        ),

        // 2. 間距 (取代原本的 Divider)
        const SizedBox(height: 12),

        // 3. 結束日期
        AppSelectField(
          labelText: t.S16_TaskCreate_Edit.field_end_date,
          text: dateFormat.format(_endDate),
          prefixIcon: Icons.event_available_outlined,
          onTap: _showEndDatePicker,
        ),
      ],
    );
  }
}
