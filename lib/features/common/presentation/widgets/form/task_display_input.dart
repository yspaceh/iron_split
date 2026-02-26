// lib/features/common/presentation/widgets/form/task_display_input.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/display_constants.dart';
import 'package:iron_split/core/enums/app_enums.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/display_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskDisplayInput extends StatelessWidget {
  const TaskDisplayInput({
    super.key,
    required this.display,
    required this.onDisplayChanged,
    this.enabled = true,
    this.fillColor,
  });

  final DisplayMode display;
  final ValueChanged<DisplayMode> onDisplayChanged; // [修改] 回傳 DisplayMode
  final bool enabled;
  final Color? fillColor;

  void _showDisplayPicker(BuildContext context) {
    if (!enabled) return;

    DisplayPickerSheet.show(
      context: context,
      initialDisplay: display,
      onSelected: (selectedLocale) {
        onDisplayChanged(selectedLocale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AppSelectField(
      labelText: t.common.display.title,
      text: DisplayConstants.getLabel(context, display),
      onTap: enabled ? () => _showDisplayPicker(context) : null,
      fillColor: fillColor,
    );
  }
}
