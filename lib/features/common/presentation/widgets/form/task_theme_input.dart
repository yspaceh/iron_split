// lib/features/common/presentation/widgets/form/task_theme_input.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/theme_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/theme_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskThemeInput extends StatelessWidget {
  const TaskThemeInput({
    super.key,
    required this.theme,
    required this.onThemeChanged,
    this.enabled = true,
    this.fillColor,
  });

  final ThemeMode theme;
  final ValueChanged<ThemeMode> onThemeChanged; // [修改] 回傳 ThemeMode
  final bool enabled;
  final Color? fillColor;

  void _showThemePicker(BuildContext context) {
    if (!enabled) return;

    ThemePickerSheet.show(
      context: context,
      initialTheme: theme,
      onSelected: (selectedLocale) {
        onThemeChanged(selectedLocale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AppSelectField(
      labelText: t.common.theme.title,
      text: ThemeConstants.getLabel(context, theme),
      onTap: enabled ? () => _showThemePicker(context) : null,
      fillColor: fillColor,
    );
  }
}
