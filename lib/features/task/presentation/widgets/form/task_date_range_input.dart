import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iron_split/features/common/presentation/widgets/common_wheel_picker.dart';
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

  void _showStartDatePicker() {
    // 1. 建立暫存變數
    DateTime tempDate = _startDate;

    showCommonWheelPicker(
      context: context,
      onConfirm: () {
        // 3. 按下完成才 setState
        setState(() {
          _startDate = tempDate;
          widget.onStartDateChanged(_startDate);
          // 連動檢查：如果結束時間早於開始時間，自動推延
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
            widget.onEndDateChanged(_endDate);
          }
        });
      },
      child: CupertinoDatePicker(
        initialDateTime: _startDate,
        mode: CupertinoDatePickerMode.date,
        // 2. 滑動時只更新暫存
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
        minimumDate: _startDate, // 防呆：不能選開始之前的日期
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (val) {
          tempDate = DateTime(val.year, val.month, val.day);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');

    return Column(
      children: [
        _buildRowItem(
          icon: Icons.calendar_today,
          label: t.S16_TaskCreate_Edit.field_start_date,
          value: dateFormat.format(_startDate),
          onTap: _showStartDatePicker,
          showDivider: true,
        ),
        _buildRowItem(
          icon: Icons.event_available,
          label: t.S16_TaskCreate_Edit.field_end_date,
          value: dateFormat.format(_endDate),
          onTap: _showEndDatePicker,
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildRowItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool showDivider = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 16),
                Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    size: 20, color: theme.colorScheme.outline),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
              height: 1,
              indent: 56,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ],
    );
  }
}
