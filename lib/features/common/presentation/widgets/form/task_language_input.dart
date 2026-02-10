// lib/features/common/presentation/widgets/form/task_language_input.dart

import 'package:flutter/material.dart';
import 'package:iron_split/core/constants/language_constants.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/app_select_field.dart';
import 'package:iron_split/features/common/presentation/widgets/pickers/language_picker_sheet.dart';
import 'package:iron_split/gen/strings.g.dart';

class TaskLanguageInput extends StatelessWidget {
  const TaskLanguageInput({
    super.key,
    required this.language, // [修改] 型別 AppLocale
    required this.onLanguageChanged,
    this.enabled = true,
    this.fillColor,
  });

  final AppLocale language;
  final ValueChanged<AppLocale> onLanguageChanged; // [修改] 回傳 AppLocale
  final bool enabled;
  final Color? fillColor;

  void _showLanguagePicker(BuildContext context) {
    if (!enabled) return;

    LanguagePickerSheet.show(
      context: context,
      initialLanguage: language,
      onSelected: (selectedLocale) {
        onLanguageChanged(selectedLocale);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return AppSelectField(
      labelText: t.common.language.title,
      // [修改] 這裡需要轉換成顯示文字
      text: LanguageConstants.getLabel(context, language),
      onTap: enabled ? () => _showLanguagePicker(context) : null,
      fillColor: fillColor,
    );
  }
}
